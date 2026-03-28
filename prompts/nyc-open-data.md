# NYC Open Data Prompts

Query NYC datasets through the Socrata MCP (data.cityofnewyork.us) and Google Data Commons MCP. These prompts work with 311 requests, restaurant inspections, housing violations, and cross-city statistical comparisons.

## NYC 311 Service Requests

> What are the top 10 complaint types in NYC 311 this month?

> Show me noise complaints by borough for the last 7 days

> Compare pothole complaints across Manhattan, Brooklyn, and Queens this year

> What's the average time to close a heat/hot water complaint in the Bronx?

## Restaurant Inspections

> Which Manhattan restaurants got a C grade in the last 30 days?

> What are the most common violation types for Chinese restaurants in Flushing?

> Show restaurant grade trends by borough over the past year

## Housing Violations

> Which Brooklyn zip codes have the most housing violations this quarter?

> Show the trend of housing violations in the Bronx over the last 6 months

## Cross-City Comparisons (Socrata + Data Commons)

> Compare 311 complaint volumes in NYC vs Chicago, normalized by population

(Uses Socrata for 311 counts from both cities, then Data Commons for population to calculate per-capita rates.)

> How does NYC's restaurant inspection failure rate compare to SF's?

(Queries restaurant inspection datasets on both data.cityofnewyork.us and data.sfgov.org via Socrata.)

> What's the median income in each NYC borough vs Boston neighborhoods?

(Uses Data Commons for median income by county-level geographies covering each borough.)

## Demographics (Data Commons)

> Compare the population growth of NYC, Boston, and Chicago over the last decade

> What's the unemployment rate in NYC vs the national average?

> Show housing unit counts for the 5 largest US cities

## Tips

- **NYC 311 is high-volume** (~10K records/day). Always add date filters to avoid timeouts.
- **Key dataset IDs**: 311 (`erm2-nwe9`), Restaurant Inspections (`43nn-pn8j`), Housing Violations (`wvxf-dwi5`)
- **SoQL is case-sensitive** -- use `upper(column)` with `LIKE` for reliable text matching
- **Run `SELECT * LIMIT 1` first** on unfamiliar datasets to discover available columns
- **Cross-city queries** hit Socrata twice (one per city domain) -- expect longer response times
- **Data Commons DCIDs**: NYC (`geoId/3651000`), Chicago (`geoId/1714000`), Boston (`geoId/2507000`)
