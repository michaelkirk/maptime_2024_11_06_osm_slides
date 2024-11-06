# <br /><br />Using OpenStreetMap Data

Now that we've all spent some time putting data **into** OSM,
let's get some data **out** of OSM.

# But first...
## a pedantic diversion.

# What is OpenStreetMap?

# What is OpenStreetMap?

- It's a website: [openstreetmap.org](https://openstreetmap.org).

# What is OpenStreetMap?

- It's a website: [openstreetmap.org](https://openstreetmap.org).
- It's an accumulation of facts (a database).

# Facts, you say?

# Facts, you say?

Two kinds of facts in OSM.

# Facts, you say?

<div class="column">

## Geometry

Where the thing is.

</div>

# Facts, you say?

<div class="column">

## Geometry

Where the thing is.

</div>

<div class="column">

## Tags 

What the thing is.

</div>

# Geometry: Where the thing is

Pretty self-explanatory conceptually, though the details can be tricky. 

All geometry in OSM is stored as latitude and longitude (e.g. no projected points).

When doing a query you'll often want to know the "bounds" of your area of interest.

# Tags: What the thing is.

# Overpass t-t-t-turbo 🔥🔥🔥

Overpass Turbo is a website for extracting data from OSM.

<https://overpass-turbo.eu>

# Overpass: ⚠️ caveats

<https://wiki.openstreetmap.org/wiki/Overpass_API>

> It can take a couple of minutes for [changes](https://wiki.openstreetmap.org/wiki/Changeset "Changeset") to the [database](https://wiki.openstreetmap.org/wiki/Database "Database") to show up in the Overpass API query results.

# Overpass: ⚠️ caveats

Quick and "easy" for small-ish one-off exports.

What if I need a bigger (or faster) export?

# osmium (cli tool)

Rather than querying a remote API, download "all the data" and do queries locally.

# <span style="text-align: center">Part II</span>

<img src="images/could-should.jpeg" width=70% style="margin-left: 15%;" />

# So, *should* you use OSM data?

# So, *should* you use OSM data?

  - Completeness?

# Is OSM Complete?

# Is OSM Complete?

Of course not.

# Is OSM Complete?

Of course not. But it's pretty good for some things!

# Is OSM Complete?

Of course not. But it's pretty good for some things!

Best with things that don't frequently change:

- major geographic features
- political borders
- most roads
- buildings in larger cities
- long-lived businesses, churches, libraries, hospitals
- places where map nerds with extra time live

# Is OSM Complete?

Conversely, OSM is less good at things that change often.

- recently opened businesses
- tags not visible on osm.org (non-geometry data) tend to be worse
  - website URLs
  - business opening hours
  - minor roads, less populated areas

# So, *should* you use OSM data?

  - Completeness?

# So, *should* you use OSM data?

  - Completeness: Best for things that don't change a lot.

# So, *should* you use OSM data?

  - Completeness: Best for things that don't change a lot.
  - Correctness:

# Is OSM data always correct?

# Is OSM data always correct?

Of course not.

# Is OSM data always correct?

Of course not. But it's usually pretty good!

# Is OSM data always correct?

Of course not. But it's usually pretty good!

It's a public website, like wikipedia, so vandalism happens.
But it's usually cleaned up quickly.

<https://daylightmap.org> (Meta/Microsoft and others) exists as a "curated" subset of OSM for this purpose. Unfortunately it's being discontinued.

# Is OSM data reliable?

Well... it depends.

# Where does OSM data come from?

Mostly volunteers.
  - Passing hobbyists with a few minutes to spend.
  - Prolific enthusiasts (like [Clifford](https://www.openstreetmap.org/user/Glassman)!).
  - People like [me](https://www.openstreetmap.org/user/michael_kirk) who make about 3 edits a year. 😬

# Where does OSM data come from?

More and more coporate editing for specific datasets - e.g. amazon and driveways.

# TODO

Add slide count
