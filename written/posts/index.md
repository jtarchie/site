# Writing

A note on my writing style. I write as I speak.

Newest first.

<!-- deno-fmt-ignore-start -->

<ul class="index">
{{range $doc := iterDocs "posts/" 0}}<li><time datetime="{{regexFind "^[0-9]{4}-[0-9]{1,2}-[0-9]{1,2}" $doc.Basename}}">{{regexFind "^[0-9]{4}-[0-9]{1,2}-[0-9]{1,2}" $doc.Basename}}</time> <a href="{{$doc.SlugPath}}">{{$doc.Title}}</a></li>
{{end}}</ul>

<!-- deno-fmt-ignore-end -->
