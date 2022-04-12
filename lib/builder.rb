# frozen_string_literal: true

require_relative 'doc'
require 'fileutils'
require 'kramdown'
require 'erb'

module Blog
  Builder = Struct.new(:source_dir, :build_dir, :domain, keyword_init: true) do
    def execute!
      which!('tidy')
      which!('wkhtmltopdf')
      which!('minify')

      FileUtils.rm_rf(build_dir)
      FileUtils.mkdir_p(build_dir)

      docs.each do |doc|
        path     = doc.filename
        print "processing #{path} ... "
        doc_path = File.join(
          build_dir,
          doc.path
        )
        FileUtils.mkdir_p(File.dirname(doc_path))
        File.write(doc_path, layout.result(
                               erb_binding do |type, default|
                                 case type
                                 when :title
                                   doc.title || default
                                 else
                                   markdown_render(
                                     doc.render(erb_binding)
                                   )
                                 end
                               end
                             ))
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
    end

    private

    def erb_binding
      binding
    end

    def layout
      @layout ||= ERB.new(File.read(File.join(source_dir, '_layout.html.erb')))
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

    def docs
      @docs ||= Dir[File.join(source_dir, '**', '*.md')].grep_v(/vendor/).sort.reverse.map do |path|
        Doc.new(
          source_dir: source_dir,
          filename: path
        )
      end
    end

    def posts
      @posts ||= docs.select(&:post?)
    end
  end
end
