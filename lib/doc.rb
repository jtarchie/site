# frozen_string_literal: true

require 'gemoji'
require 'erb'

module Blog
  Doc = Struct.new(:source_dir, :filename, keyword_init: true) do
    def path
      File.join(
        File.dirname(filename).gsub(source_dir, ''),
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
end
