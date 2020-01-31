# frozen_string_literal: true

require 'fileutils'
require 'redcarpet'
require 'erb'

build_path = File.join(__dir__, 'docs')

def erb_binding
  binding
end

def layout
  @layout ||= ERB.new(File.read(File.join(__dir__, '_layout.html.erb')))
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

task default: [:build, :server]

task :build do
  FileUtils.rm_rf(build_path)

  Dir[File.join(__dir__, '**', '*.md')].sort.each do |path|
    print "processing #{path} ... "
    post_path = File.join(
      build_path,
      File.dirname(path).gsub(__dir__, ''),
      File.basename(path, '.md') + '.html'
    )
    FileUtils.mkdir_p(File.dirname(post_path))
    File.write(post_path, layout.result(
                            erb_binding do
                              markdown.render(File.read(path))
                            end
                          ))
    puts "wrote file #{post_path}"
    system("tidy -mq #{post_path}")
  end
  File.write(File.join(build_path, 'CNAME'), 'jtarchie.com')
end

task :server do
  system("ruby -run -ehttpd #{build_path} -p8000")
end