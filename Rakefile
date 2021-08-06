# frozen_string_literal: true

require 'filewatcher'
require_relative 'lib/builder'

build_path = File.join(__dir__, 'docs')

task default: %i[build server]

task :build do
  builder = Blog::Builder.new(
    source_dir: __dir__,
    build_dir: build_path
  )
  builder.execute!
end

task :server do
  io = IO.popen("ruby -run -ehttpd #{build_path} -p8000")

  Filewatcher.new(['**/*.md', 'Rakefile', '*.html', '_layout.html.erb']).watch do
    Rake::Task['build']
    raise 'there was a 404 error in the site' unless system('muffet -x http://localhost:8000')
  end
ensure
  Process.kill('INT', io.pid)
  io.close
end
