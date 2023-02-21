# Blog

A note on my writing style. I write as I speak.

These are the posts from the blog -- sorted newest to oldest.

<!-- deno-fmt-ignore-start -->

<%- posts.each do |doc| %>
- [<%= doc.title %>](<%= doc.path %>) on <%= doc.basename %>
<%- end %>

<!-- deno-fmt-ignore-end -->
