# Blog

A note on my writing style. I write as I speak.

These are the posts from the blog -- sorted newest to oldest.

<%- posts.each do |doc| %>
- [<%= doc.title %>](<%= doc.path %>) on <%= doc.basename %>
<%- end %>
