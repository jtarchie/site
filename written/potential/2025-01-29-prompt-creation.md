# Using LLMs to Convert Natural Language into Structured Queries

Over the past year, I have been building an application platform that enables
searching through OpenStreetMap (OSM) data via an API endpoint and an embedded
JavaScript runtime. The idea behind this interface is to minimize data transfer
and round trips between the client and the server. This allows client-side
JavaScript to be executed on the server for a specific use case: querying and
collating
[geospatial points of interest from OpenStreetMap](/posts/2024-07-02-optimizing-large-scale-openstreetmap-data-with-sqlite).

Even though I have
[documentation for the custom query language](https://knowhere.live/docs/query/),
but I found that it requires significant domain knowledge about how OSM tags are
used to identify places. For example, a gas station in OSM could be tagged as
`store=convenience`, `amenity=gas`, or something else entirely. The
inconsistency in tagging made it difficult to surface relevant search results.

Initially, I considered creating an endpoint that returns all possible tags, but
I found that the sheer number of tags—potentially hundreds of thousands—made it
difficult to present in a human-readable way. This led me to explore a different
approach: converting user queries, such as "grocery store," into predefined OSM
tags.

To achieve this, I categorized common amenities for real estate searches—such as
police stations, gas stations, schools, and hospitals—and built an interface
that
[allowed users to input an address](https://knowhere.live/beta/nearby/search).

For example, the manifest for Arts and Entertainment captured the following
tags:

```js
{
  // ... many more tags ...
"arts_and_entertainment": {
    queries: [
      "[amenity=arts_centre][name]",
      "[leisure=theatre][name]",
      "[tourism=gallery][name]",
    ],
    markerSymbol: "art-gallery",
    label: "Arts and Entertainment",
  }
}
```

However, this approach had limitations. The predefined categories restricted
what users could search for. For example, if someone wanted to exclude
mainstream coffee shops to discover locally owned businesses, I would need to
maintain an exclusion list, which was impossible.

### Experimenting with LLMs

Given the rise of large language models (LLMs), I wanted to see if they could
help translate user queries into structured OSM tags. My initial approach was to
experiment with ChatGPT by manually testing prompts.

The prompt:

> You will be given a user query in natural language, and you will return
> structured JSON representing the OpenStreetMap tags that correspond to the
> query.

The query:

> Find me coffee shops in my neighborhood

The results:

```json
{
  "amenity": "cafe"
}
```

On a first try, this is a really promising result. Open Street Map documents the
[`amenity` tag](https://wiki.openstreetmap.org/wiki/Tag:amenity=cafe) and also
has [`shop=coffee`](https://wiki.openstreetmap.org/wiki/Tag:shop%3Dcoffee).

However, on subsequent runs, sometimes an explanation of JSON structure was
provided by the LLM, and a different model would never return JSON at all.

To improve accuracy, I refined my prompt to specify an expected JSON schema:

The prompt:

> You will be given a user query in natural language, and you will return
> structured JSON representing the OpenStreetMap tags that correspond to the
> query. Please format in the follow JSON format to allow multiple queries.

```json
[
  { "amenity": "cafe" },
  { "amenity": "fuel" }
]
```

The query:

Find coffee shops and high schools.

The results:

```json
[
  { "amenity": "cafe" },
  { "amenity": "school", "school:level": "high" }
]
```

This is perfect! It is the exact JSON shape that I wanted. However, it should be
noted that `school:level` is not a valid tag documented in Open Street Map wiki.

After iterating with various user queries and responses, I integrated this into
my application. The interface allowed users to describe a neighborhood, and the
system returned relevant points of interest on a map.

### Teaching an LLM a Custom Query Language

I had already developed a custom query language, similar to OQL, that allows
structured searches through OSM tags. This language supports substring matching,
range filters, and directives for scoping searches to specific areas. Teaching
an LLM to generate queries in this format was another challenge.

To address this, I provided ChatGPT with documentation on the query language,
including syntax and examples.

*** Placeholder for a link to the query language documentation ***

Using OpenAI’s best practices, I asked ChatGPT to generate an optimized prompt
based on my documentation. The refined prompt improved the results, but when I
used it via the OpenAI API, the responses were inconsistent, with around 70%
being correctly structured while others included hallucinated data.

### Improving Accuracy with Fine-Tuning

To improve accuracy, I took two additional steps:

1. **Providing a list of high-value OSM tags** – I manually curated a list of 50
   essential tags, then asked ChatGPT to extend it. The model generated 120
   tags, of which 15 were invalid, but I was able to refine the list further.
2. **Enhancing area knowledge** – I expanded my prompt to include a predefined
   list of U.S. states and Canadian provinces, ensuring that area-based queries
   returned structured JSON with multiple valid regions.

*** Code placeholder: Example query including areas ***

### Optimizing with Fine-Tuning

Since my prompt was becoming lengthy and complex, I explored fine-tuning an
OpenAI model. Fine-tuning allows a model to learn from a dataset of expected
inputs and outputs. I extracted structured examples from my original prompt and
created a training dataset.

I then asked ChatGPT Pro to generate additional examples to supplement my
dataset. After verifying these examples, I trained a fine-tuned model based on
GPT-4-turbo, which significantly improved query accuracy and response speed.

*** Placeholder for fine-tuned model comparison results ***

Fine-tuning also enabled me to adapt the model based on real-world feedback. For
example, when users reported that skate parks were missing, I researched
relevant OSM tags and added them to the training set. By continuously
fine-tuning based on user feedback, I was able to improve the model’s ability to
infer correct tags without endlessly expanding my predefined tag list.

### Next Steps

The current implementation enables users to enter a natural language description
of a neighborhood and receive structured OSM query results. While it works well,
there are further optimizations to explore, such as reducing token usage in
prompts, refining fine-tuning datasets, and improving response latency.

*** Placeholder for a link to the live implementation ***

That's it. Let me know if you have any questions. Thanks for reading.
