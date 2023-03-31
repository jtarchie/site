# Blog

A note on my writing style. I write as I speak.

These are the posts from the blog -- sorted newest to oldest.

<!-- deno-fmt-ignore-start -->

{{range $doc := iterDocs "posts/" 0}}
- [{{$doc.Title}}]({{$doc.Path}}) on {{$doc.Basename}}
{{end}}

<!-- deno-fmt-ignore-end -->
