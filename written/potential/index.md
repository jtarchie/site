# Potential blog posts

<!-- deno-fmt-ignore-start -->

{{range $doc := iterDocs "potential/" 0}}
- [{{$doc.Title}}]({{$doc.SlugPath}}) on {{$doc.Basename}}
{{end}}

<!-- deno-fmt-ignore-end -->
