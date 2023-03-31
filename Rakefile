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
    source_dir: File.join(__dir__, 'written'),
    build_dir: build_path,
    domain: 'jtarchie.com'
  )
  builder.execute!
end