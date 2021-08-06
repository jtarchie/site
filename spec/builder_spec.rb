# frozen_string_literal: true

require 'tmpdir'
require 'fileutils'
require_relative '../lib/builder'

RSpec.describe 'building the site' do
  let(:source_dir) { Dir.mktmpdir }
  let(:build_dir) { Dir.mktmpdir }

  def create_doc(filename, contents)
    path = File.join(source_dir, filename)
    FileUtils.mkdir_p(File.dirname(path))
    File.write(path, contents)
  end

  def read_file(filename)
    path = File.join(build_dir, filename)
    File.read(path)
  end

  def build!
    builder = Blog::Builder.new(
      source_dir: source_dir,
      build_dir: build_dir
    )
    builder.execute!
  end

  before do
    create_doc('_layout.html.erb', <<~HTML)
      <!doctype html>
        <html lang="en">
          <head>
            <title>test</title>
          </head>
          <body>
            <%= yield %>
          </body>
        </html>
    HTML
  end

  it 'supports converting the resume to PDF' do
  end

  it 'supports named emojis' do
    create_doc('index.md', ':cat:')
    build!
    expect(read_file('index.html')).to include '🐱'
  end
end
