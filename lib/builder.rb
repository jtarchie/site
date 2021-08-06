# frozen_string_literal: true

require_relative 'doc'
require 'fileutils'
require 'redcarpet'
require 'erb'

module Blog
  Builder = Struct.new(:source_dir, :build_dir, keyword_init: true) do
    def execute!
      which!('tidy')
      which!('wkhtmltopdf')

      FileUtils.rm_rf(build_dir)

      docs.each do |doc|
        path = doc.filename
        print "processing #{path} ... "
        doc_path = File.join(
          build_dir,
          doc.path
        )
        FileUtils.mkdir_p(File.dirname(doc_path))
        File.write(doc_path, layout.result(
                               erb_binding do
                                 markdown.render(
                                   doc.render(erb_binding)
                                 )
                               end
                             ))
        puts "wrote file #{doc_path}"
        run!("tidy -mq #{doc_path}")
      end
      File.write(File.join(build_dir, 'CNAME'), 'jtarchie.com')
      run!('wkhtmltopdf docs/resume/index.html docs/resume/resume.pdf')
    end

    private

    def erb_binding
      binding
    end

    def layout
      @layout ||= ERB.new(File.read(File.join(source_dir, '_layout.html.erb')))
    end

    def markdown
      @markdown ||= Redcarpet::Markdown.new(Redcarpet::Render::HTML.new(
                                              prettify: true,
                                              with_toc_data: true
                                            ),
                                            fenced_code_blocks: true,
                                            space_after_headers: true,
                                            strikethrough: true,
                                            tables: true,
                                            autolink: true)
    end

    def run!(command)
      raise "cannot run command '#{command}'" unless system(command)
    end

    def which!(command)
      raise "command '#{which} does not exist, please install" unless system("which #{command}")
    end

    def docs
      @docs ||= Dir[File.join(source_dir, '**', '*.md')].sort.reverse.map do |path|
        Doc.new(
          source_dir: source_dir,
          filename: path
        )
      end
    end
  end
end
