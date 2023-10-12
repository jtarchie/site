# OQL queries

> I'd like to find a city in Colorado, which has bike lanes in the city limits.
> Within that city there should also 5 or more coffee places, which aren't
> Starbucks. And I would like the city to be within 25 miles of a Costco.

```oql
[out:json];
area["ISO3166-2"="US-CO"][boundary=administrative] -> .colorado;

// Find Costcos in Colorado
(
	node(area.colorado)['name'~'Costco'];
  	way(area.colorado)['name'~'Costco'];
) -> .costcos;

// Find cities within 40km of a Costco
node(around.costcos:40000)["place"~"city|town|village|hamlet"] -> .all_cities;

// Find bike lanes and get cities around them
way(around.all_cities:500)["highway"="cycleway"];
node(around:500)["place"~"city|town|village|hamlet"] -> .cities_with_bikelanes;

// Find non-Starbucks coffee shops and get cities around them
node(around.all_cities:500)["amenity"="cafe"]["name"!="Starbucks"];
node(around:500)["place"~"city|town|village|hamlet"] -> .cities_with_coffee;

// Intersect the two lists to get cities that meet both criteria
node.cities_with_bikelanes.cities_with_coffee;

out geom;
```

> 5 miles of a trailhead, 15 miles to whole foods, an area of for population
> density for dating
