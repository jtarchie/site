## Using LLMs to Convert Natural Language Queries into Structured Queries

### Context

Over the past year, I have been working on building an application platform that
supports searching through OpenStreetMap data via an API endpoint and an
embedded JavaScript runtime into Golang.

The idea behind that interface is to minimize the amount of data and round trips
that need to be done from a client interface. Client-side JavaScript can be
passed to server-side JavaScript for a very subset use case, which is querying
and collating geospatial points of interest from OpenStreetMap.

[Placeholder for a link to that blog post.]

I have documentation for my query language, but what I found was that it
required a lot of domain knowledge related to how OpenStreetMap tags may be used
to identify a place.

For example, an OpenStreetMap gas station could be marked as `store=convenience`
or `amenity=gas` or might have neither or only one of them. Discovering those
tags to help search led me to try to expose that information in different ways.

Initially, I thought about creating an endpoint that returns information about
all the tags. However, I found that there was a lot of noise in the tags, making
it difficult to present the data in a human-readable and usable way. There can
be tens of thousands, if not hundreds of thousands, of tags with multiple values
for each.

### Initial Approach

I wanted to take a different approach: Could I have something that converted a
user's query, such as "grocery store," and mapped it to predefined tags?

I built an interface where I predetermined a categorization of tags, covering
common amenities for real estate searches such as police stations, gas stations,
schools, and hospitals.

[Placeholder for a link to that interface.]

This allowed users to input an address, which would use an element from the
Mapbox SDK to return latitude and longitude. I could then use predefined
categorizations to find nearby points of interest.

However, this approach was limited. It only allowed predefined categories to be
shown, restricting the scope of discovery. For example, what if someone wanted
to exclude mainstream coffee shops to find local businesses? This would require
maintaining a list of coffee shops to exclude or providing an exclusion
mechanism for users—making the interface complex.

### Experimenting with LLMs

Given these limitations, I explored the possibility of using a Large Language
Model (LLM) to process natural language queries and convert them into structured
queries.

I started by experimenting with ChatGPT, manually testing prompts. My initial
prompt was:

> "You will be given a user query in natural language and return structured JSON
> representing the OpenStreetMap tags that correspond to the query."

Example query:

> "Find me coffee shops in my neighborhood."

[Placeholder for what ChatGPT initially returned.]

The results were promising but lacked structure. So, I defined a schema for the
expected JSON output and refined my prompt:

> "Given a user's query in natural language, return OpenStreetMap tags in a JSON
> format. Here is an example of the expected output."

Example query:

> "What coffee shops are in my neighborhood?"

[Placeholder for expected JSON output.]

[Placeholder for an example with ChatGPT’s result.]

### Integrating LLMs into My Application

With structured JSON working, I incorporated it into my application—a text box
where users could describe their desired neighborhood, and it would return
points of interest on a map.

However, I encountered new challenges:

- **Scoping queries:** My database was structured by states and Canadian
  provinces. Users had to specify these areas, which broke the natural language
  flow.
- **Teaching an LLM my custom query language:** My query language allowed
  substring matching, range limits, and directives to scope searches.

To address these issues, I documented my query language, detailing syntax and
examples.

[Placeholder for link to query syntax documentation.]

I then asked ChatGPT to refine my prompt:

> "Here’s documentation on my query language. Help me write a prompt that
> ensures you understand it."

[Placeholder for shortened example of refined prompt.]

### Enhancing Query Accuracy

To improve accuracy, I identified meaningful OpenStreetMap tags by researching
community discussions and manually curating a list of about 50 high-value tags
(e.g., shops, amenities, roads, schools, parks). I then asked ChatGPT:

> "Here's a list of 50 OpenStreetMap tags for describing a neighborhood. Can you
> extend it for better specificity?"

It suggested 120 tags, of which 15 were incorrect. After review, I refined the
list and incorporated it into the LLM prompt:

> "If looking for OpenStreetMap tags, use these as a guide, but feel free to use
> others."

Testing showed that responses were now more specific. For example:

> "Find coffee shops that are not mainstream."

[Placeholder for resulting query JSON.]

### Handling Geographic Areas

To improve area selection, I extended the JSON output schema to include multiple
areas. Instead of requiring users to select one state, I allowed descriptions
like "Southwestern states" to infer multiple areas.

[Placeholder for a query that includes southwestern states.]

### Optimizing Performance

While my implementation worked, optimizations were necessary:

1. **Fine-Tuning the Model**
   - I converted example prompts and expected outputs into fine-tuning data.
   - I asked ChatGPT to generate additional examples, reviewed them, and removed
     incorrect ones.
   - I fine-tuned a GPT-4 model with 30+ examples to improve performance.
   - Results: A slight performance boost and more accurate outputs.

2. **Providing Output Prediction**
   - OpenAI's API allows defining an expected output structure.
   - I used this feature to ensure JSON output consistency.

[Placeholder for OpenAI API link about this feature.]

3. **Leveraging Prompt Caching**
   - OpenAI caches prompts for faster response times, reducing costs.
   - This ensured my long prompt wasn't reprocessed on every request.

4. **Limiting Token Usage**
   - I capped JSON output to 300 tokens and limited user input to 300
     characters.
   - This prevented excessive API costs and safeguarded against abuse.

### Conclusion

By integrating OpenStreetMap data with LLMs, I enabled users to query geospatial
data using natural language. The system supports filtering, distance
constraints, and negations, making searches more intuitive.

[Placeholder for a link to the neighborhood search demo.]

This approach remains **best effort**—not perfect, but continually improving. I
plan to refine results through fine-tuning and ongoing user feedback to enhance
accuracy and usability.
