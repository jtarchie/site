# ChatGPT Prompts

This section captures the ChatGPT prompts that I have used. They cover different
purposes, but this a way to document them.

<!-- deno-fmt-ignore-start -->

<ul class="index">
{{range $doc := iterDocs "chatgpt/" 0}}<li><time datetime="{{regexFind "^[0-9]{4}-[0-9]{1,2}-[0-9]{1,2}" $doc.Basename}}">{{regexFind "^[0-9]{4}-[0-9]{1,2}-[0-9]{1,2}" $doc.Basename}}</time> <a href="{{$doc.Path}}">{{$doc.Title}}</a></li>
{{end}}</ul>

<!-- deno-fmt-ignore-end -->
