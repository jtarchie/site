# Potential blog posts

<!-- deno-fmt-ignore-start -->

<ul class="index">
{{range $doc := iterDocs "potential/" 0}}<li><time datetime="{{regexFind "^[0-9]{4}-[0-9]{1,2}-[0-9]{1,2}" $doc.Basename}}">{{regexFind "^[0-9]{4}-[0-9]{1,2}-[0-9]{1,2}" $doc.Basename}}</time> <a href="{{$doc.SlugPath}}">{{$doc.Title}}</a></li>
{{end}}</ul>

<!-- deno-fmt-ignore-end -->
