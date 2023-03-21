# frozen_string_literal: true

require_relative 'doc'
require 'fileutils'
require 'kramdown'
require 'erb'
require 'tilt'

module Blog
  Builder = Struct.new(:source_dir, :build_dir, :domain, keyword_init: true) do
    def execute!
      which!('tidy')
      which!('wkhtmltopdf')
      which!('minify')

      FileUtils.rm_rf(build_dir)
      FileUtils.mkdir_p(build_dir)

      docs.each do |doc|
        path          = doc.filename
        print "processing #{path} ... "
        doc_path      = File.join(
          build_dir,
          doc.path
        )
        templates_for = [Tilt::ErubiTemplate, Tilt::KramdownTemplate]
        puts templates_for
        rendered      = templates_for.reduce(doc.contents) do |contents, template|
          template.new({
                         input: 'GFM',
                         gfm_emojis: true,
                         hard_wrap: false
                       }) { contents }.render(self)
        end

        FileUtils.mkdir_p(File.dirname(doc_path))
        File.write(doc_path, layout.render(self, {
                                             title: doc.title,
                                             content: rendered
                                           }))

        puts "wrote file #{doc_path}"
        run!("tidy -cmq --omit --utf8 --ashtml yes --output-bom no --wrap 0 #{doc_path}")
        run!("minify --html-keep-quotes -o #{doc_path} #{doc_path}")
        next unless doc.requires_pdf?

        pdf_path = File.join(
          build_dir,
          doc.path(ext: 'pdf')
        )

        run!("wkhtmltopdf #{doc_path} #{pdf_path}")
      end
      File.write(File.join(build_dir, 'CNAME'), domain)
      File.write(File.join(build_dir, 'robots.txt'), '')
    end

    private

    def erb_binding
      binding
    end

    def layout
      @layout ||= Tilt.new(File.join(source_dir, '_layout.html.erb'))
    end

    def markdown_render(text)
      Kramdown::Document.new(
        text,
        input: 'GFM',
        gfm_emojis: true,
        hard_wrap: false
      ).to_html
    end

    def run!(command)
      raise "cannot run command '#{command}'" unless system(command)
    end

    def which!(command)
      raise "command '#{which} does not exist, please install" unless system("which #{command}")
    end

    def docs(filter: nil)
      @docs ||= Dir[File.join(source_dir, '**', '*.md')].sort.reverse.map do |path|
        Doc.new(
          source_dir: source_dir,
          filename: path
        )
      end
      if filter
        return @docs.select do |doc|
          filter.call(doc.filename)
        end
      end

      @docs
    end

    def posts
      @posts ||= docs(filter: lambda do |filename|
        filename.include?('/posts/') && filename =~ /\d{4}-\d{2}-\d{2}/
      end)
    end
  end
end
