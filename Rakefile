# frozen_string_literal: true

require 'fileutils'
require 'redcarpet'
require 'erb'
require 'filewatcher'
require 'gemoji'

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

def execute(command)
  raise "cannot run command '#{command}'" unless system(command)
end

def which(command)
  raise "command '#{which} does not exist, please install" unless system("which #{command}")
end

Doc = Struct.new(:filename) do
  def path
    File.join(
      File.dirname(filename).gsub(__dir__, ''),
      "#{basename}.html"
    )
  end

  def title
    @title ||= contents.scan(/^# (.*)$/).flatten.first
  end

  def render(binding)
    @layout ||= begin
      with_emojis = contents.gsub(/:(\w+):/) do |_|
        name = Regexp.last_match[1]
        emoji = Emoji.find_by_alias(name)
        raise "Cannot find emoji for '#{name}'" unless emoji

        emoji.raw
      end
      ERB.new(with_emojis)
    end
    @layout.result(binding)
  end

  def basename
    File.basename(filename, '.md')
  end

  def post?
    filename.include?('/posts/')
  end

  private

  def contents
    @contents ||= File.read(filename)
  end
end

def docs
  @docs ||= Dir[File.join(__dir__, '**', '*.md')].sort.reverse.map do |path|
    Doc.new(path)
  end
end

task default: %i[build server]

task :build do
  which('tidy')
  which('wkhtmltopdf')

  FileUtils.rm_rf(build_path)

  docs.each do |doc|
    path = doc.filename
    print "processing #{path} ... "
    doc_path = File.join(
      build_path,
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
    execute("tidy -mq #{doc_path}")
  end
  File.write(File.join(build_path, 'CNAME'), 'jtarchie.com')
  execute('wkhtmltopdf docs/resume.html docs/resume.pdf')
end

task :server do
  io = IO.popen("ruby -run -ehttpd #{build_path} -p8000")
  Filewatcher.new(['**/*.md', 'Rakefile', '*.html', '_layout.html.erb']).watch do
    Rake::Task['build']
  end
  Process.kill('INT', io.pid)
  io.close
end
