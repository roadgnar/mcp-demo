# Cross-MCP Analysis Prompts

These prompts use BOTH the Cyvl MCP and Boston Open Data MCP together. The AI joins data across the two sources automatically.

## Crash + Pavement Correlation

> What are the most dangerous streets in Boston based on crash data? Then show me the pavement condition on those streets.

> Is there a correlation between road quality and crash frequency on Blue Hill Avenue? Show me the crash counts from Vision Zero and the pavement distress data from Cyvl.

> Find streets where pedestrian crashes are high AND pavement condition is poor. These should be priority repair candidates.

## 311 Complaints + Visual Evidence

> Find all pothole complaints from 311 in Dorchester this year. Then search Cyvl imagery for visible potholes in the same area. Do the complaints match what's visible on the street?

> Compare 311 complaint density by neighborhood with Cyvl pavement condition scores. Which neighborhoods complain the most relative to actual road quality?

> Search 311 for "Unshoveled Sidewalk" complaints, then use Cyvl imagery to show what those sidewalks look like.

## Construction Monitoring

> Get the list of active work zones from Boston open data. Then search Cyvl imagery for "construction sites" in the same neighborhoods. Are there construction sites visible in imagery that don't have permits?

> Which neighborhoods have the most active construction? Cross-reference with pavement condition — is construction happening where roads need it most?

## Safety Prioritization

> Build a prioritized repair list: streets with the worst pavement scores (Cyvl) that also have high crash counts (Vision Zero) and active 311 complaints. Rank by combined severity.

> Find intersections near schools where pavement condition is poor AND there have been pedestrian crashes.

## Tips

- The AI uses **coordinates (lat/long)** as the join key between sources
- Boston CKAN data has `lat`/`long` fields on crashes and 311 records
- Cyvl tools accept `radius` filters with `lat`/`lng`/`meters`
- Cross-MCP queries take longer — be patient with compound questions
- Always note which data came from which source when presenting results

## NYC + Boston Comparisons

> Compare pothole complaints: NYC 311 via Socrata vs Boston 311 via CKAN. Which city has more per capita?

> Which city has worse infrastructure complaints per capita -- NYC or Boston? Pull 311 totals from both and normalize by population from Data Commons.

> Show crash hotspots in Boston (Vision Zero) alongside NYC's most-complained-about streets from 311. Where do the worst corridors compare?

> Compare noise complaint patterns between NYC (Socrata 311) and Boston (CKAN 311). Which neighborhoods in each city are loudest?

> How do housing violation rates in Brooklyn compare to housing code violations in Boston? Use Socrata for NYC and CKAN for Boston.
