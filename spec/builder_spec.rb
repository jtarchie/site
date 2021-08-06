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
            <title><%= yield(:title, 'default title') %></title>
          </head>
          <body>
            <%= yield %>
          </body>
        </html>
    HTML
  end

  it 'supports converting markdown files to PDF' do
    create_doc('index.pdf.md', ':cat:')
    build!
    expect(read_file('index.html')).to include '🐱'
    expect(read_file('index.pdf')).to include 'PDF'
  end

  it 'supports markdown files' do
    create_doc('index.md', <<~MARKDOWN)
      ## Hello world
      * Item 1
      * Item 2
      * :cat:
    MARKDOWN

    build!
    contents = read_file('index.html')

    expect(contents).to include '<title>default title</title>'
    expect(contents).to include '<h2 id="hello-world">Hello world</h2>'
    expect(contents).to include '<li>Item 1</li>'
    expect(contents).to include '<li>Item 2</li>'
    expect(contents).to include '🐱'
  end

  it 'supports posts' do
    create_doc('posts/20200101.md', '# Some post')
    create_doc('index.md', <<~ERB)
      <% posts.each do |doc| %>
        * [<%= doc.title%>](<%= doc.path %>)
      <% end %>
    ERB
    build!

    expect(read_file('index.html')).to include '<li><a href="/posts/20200101.html">Some post</a></li>'
    expect(read_file('posts/20200101.html')).to include '<title>Some post</title>'
    expect(read_file('posts/20200101.html')).to include '<h1 id="some-post">Some post</h1>'
  end
end
