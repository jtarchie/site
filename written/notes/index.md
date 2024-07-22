# Notes

Some notes I'd like to keep, separate from blog posts.

<!-- deno-fmt-ignore-start -->

{{range $doc := iterDocs "notes/" 0}}
- [{{$doc.Title}}]({{$doc.Path}}) on {{$doc.Basename}}
{{end}}

<!-- deno-fmt-ignore-end -->
