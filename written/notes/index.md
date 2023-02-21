# Notes

Some notes I'd like to keep, separate from blog posts.

<!-- deno-fmt-ignore-start -->

<%- docs(filter: ->(f) {f.include?('notes') }).each do |doc| %>
- [<%= doc.title %>](<%= doc.path %>) on <%= doc.basename %>
<%- end %>

<!-- deno-fmt-ignore-end -->
