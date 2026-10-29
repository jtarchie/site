# Scripts for Youtube shorts

These are the documents used in the Youtube Short series. They are generated via
[short generator](https://github.com/jtarchie/short-generator).

<!-- deno-fmt-ignore-start -->

<ul class="index">
{{range $doc := iterDocs "scripts/" 0}}<li><time datetime="{{regexFind "^[0-9]{4}-[0-9]{1,2}-[0-9]{1,2}" $doc.Basename}}">{{regexFind "^[0-9]{4}-[0-9]{1,2}-[0-9]{1,2}" $doc.Basename}}</time> <a href="{{$doc.Path}}">{{$doc.Title}}</a></li>
{{end}}</ul>

<!-- deno-fmt-ignore-end -->
