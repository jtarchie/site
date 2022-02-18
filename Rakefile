# frozen_string_literal: true

require 'filewatcher'
require_relative 'lib/builder'

build_path = File.join(__dir__, 'docs')

task default: %i[fmt build server]

task :fmt do
  sh('rubocop -a')
  sh('deno fmt .')
end

task :build do
  builder = Blog::Builder.new(
    source_dir: __dir__,
    build_dir: build_path,
    domain: 'jtarchie.com'
  )
  builder.execute!
end

def check_links
  raise 'there was a 404 error in the site' unless system('muffet --skip-tls-verification http://localhost:8000')
end

task :server do
  io = IO.popen("ruby -run -ehttpd #{build_path} -p8000")
  sleep 2

  check_links

  Filewatcher.new(['**/*.md', 'Rakefile', '*.html', '_layout.html.erb']).watch do
    Rake::Task['build']
    check_links
  end
ensure
  Process.kill('INT', io.pid)
  io.close
end
