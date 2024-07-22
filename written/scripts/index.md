# Scripts for Youtube shorts

These are the documents used in the Youtube Short series. They are generated via
[short generator](https://github.com/jtarchie/short-generator).

<!-- deno-fmt-ignore-start -->

{{range $doc := iterDocs "scripts/" 0}}
- [{{$doc.Title}}]({{$doc.Path}}) on {{$doc.Basename}}
{{end}}

<!-- deno-fmt-ignore-end -->
