# NYC Open Data Prompts

Prompts for exploring NYC infrastructure through Cyvl imagery, Socrata open data, and Data Commons demographics.

## Cyvl Imagery — Queens

> Search for fire hydrants in Jackson Heights using project 1924f65d-01b6-4170-b0b8-ddf6a887b6e5. Show me 3 images.

> Find cracked sidewalks in Jamaica using project e57afa42-1052-4313-a26b-8df6e3154a58. How widespread is the damage?

> Get pavement scores near 40.7425, -73.9235 in the LIC project 5be713ea-d739-4ecc-876d-ccadbe57c04b. What's the average PCI?

> List distresses in Jackson Heights (project 1924f65d-01b6-4170-b0b8-ddf6a887b6e5) within 300m of 40.7557, -73.8831. What types of damage are most common?

> Compare pavement conditions across all three Queens projects — Jackson Heights (1924f65d), LIC (5be713ea), and Jamaica (e57afa42). Which neighborhood has the worst roads?

## 311 Complaints by Borough

> What are the top 20 complaint types in Queens this year? Use dataset erm2-nwe9 on data.cityofnewyork.us.

> Compare noise complaint rates across all 5 boroughs using dataset erm2-nwe9. Which borough is loudest?

> Show me 311 complaints near Jackson Heights (within 1km of 40.7557, -73.8831) — what do residents report most?

## Restaurant Inspections

> What percentage of Queens restaurants have an A grade? Use dataset 43nn-pn8j.

> Find restaurants with critical violations in Jackson Heights (zipcode 11372) using dataset 43nn-pn8j. What are the most common violations?

> Compare restaurant grade distributions across all 5 boroughs using dataset 43nn-pn8j.

## Housing Violations

> What are the most common housing violation types in Queens (boroid 4) this year? Use dataset wvxf-dwi5.

> How many Class C (immediately hazardous) violations are open in Jamaica? Use dataset wvxf-dwi5 filtered to zip codes 11432, 11433, 11434.

> Compare housing violation rates across boroughs — which has the most open Class B and C violations per capita?

## Cross-Source Analysis

> Compare Cyvl sidewalk damage in Jackson Heights (project 1924f65d) with 311 sidewalk complaints near the same area (dataset erm2-nwe9). Where are the gaps?

> Pull pavement scores from Cyvl for all three Queens neighborhoods, then compare with 311 street condition complaints in each area. Do the data sources agree?

> What is the median income in NYC (geoId/3651000) from Data Commons? How do 311 complaint volumes correlate with neighborhood income levels?

## Demographics and Comparisons

> Compare population and median household income for NYC (geoId/3651000) vs Chicago (geoId/1714000) vs Los Angeles (geoId/0644000) using Data Commons.

> What is the unemployment rate trend for NYC over the last 5 years? Use Data Commons variable UnemploymentRate_Person with place geoId/3651000.
