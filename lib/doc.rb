# frozen_string_literal: true

require 'gemoji'
require 'erb'

module Blog
  Doc = Struct.new(:source_dir, :filename, keyword_init: true) do
    def path(ext: 'html')
      File.join(
        File.dirname(filename).gsub(source_dir, ''),
        "#{basename}.#{ext}"
      )
    end

    def title
      @title ||= contents.scan(/^# (.*)$/).flatten.first
    end

    def contents
      @contents ||= File.read(filename).gsub(/:(\w+):/) do |_|
        name  = Regexp.last_match[1]
        emoji = Emoji.find_by_alias(name)
        raise "Cannot find emoji for '#{name}'" unless emoji

        emoji.raw
      end
    end

    def basename
      return File.basename(filename, '.pdf.md') if requires_pdf?

      File.basename(filename, '.*').gsub(/\.erb|\.md/, '')
    end

    def requires_pdf?
      filename.include?('.pdf')
    end
  end
end
