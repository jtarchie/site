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
      build_dir: build_dir,
      domain: 'example.com'
    )
    builder.execute!
  end

  before do
    create_doc('_layout.html.erb', <<~HTML)
      <!doctype html>
        <html lang="en">
          <head>
            <title><%= title || "default title" %></title>
          </head>
          <body>
            <%= content %>
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
    expect(contents).to include '<li>Item 1'
    expect(contents).to include '<li>Item 2'
    expect(contents).to include '🐱'
  end

  it 'supports posts' do
    create_doc('posts/2020-01-01.md', '# Some post')
    create_doc('posts/index.erb.md', <<~ERB)
      # Posts
      <%- posts.each do |doc| %>
      * [<%= doc.title%>](<%= doc.path %>)
      <%- end %>
    ERB
    create_doc('index.erb.md', <<~ERB)
      <%- posts.each do |doc| %>
      * [<%= doc.title%>](<%= doc.path %>)
      <%- end %>
    ERB
    build!

    files = Dir[File.join(build_dir, '**', '*.html')].sort
    expect(files.map { |file| File.basename(file) }).to eq ['index.html', '2020-01-01.html', 'index.html']

    expect(read_file('index.html')).to include '<a href="/posts/2020-01-01.html">Some post'
    expect(read_file('index.html')).to_not include '<a href="/posts/index.html">Posts'

    expect(read_file('posts/index.html')).to include '<a href="/posts/2020-01-01.html">Some post'
    expect(read_file('posts/index.html')).to_not include '<a href="/posts/index.html">Posts'

    expect(read_file('posts/2020-01-01.html')).to include '<title>Some post</title>'
    expect(read_file('posts/2020-01-01.html')).to include '<h1 id="some-post">Some post</h1>'
  end

  it 'generates a CNAME artifact' do
    build!
    expect(read_file('CNAME')).to eq 'example.com'
  end
end
