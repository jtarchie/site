# frozen_string_literal: true

require_relative 'doc'
require 'fileutils'
require 'kramdown'
require 'erb'
require 'tilt'

module Blog
  Builder = Struct.new(:source_dir, :build_dir, keyword_init: true) do
    def execute!
      system("builder --source-path #{source_dir} --build-path #{build_dir}")
    end
  end
end
