# Construction Monitoring Prompts

Cross-reference Cyvl's street-level imagery with Boston's Active Work Zones and Building Permits data.

## Construction Discovery

> Search for "construction sites with heavy machinery" in Boston. How many active sites can you find in imagery?

> Find "road resurfacing in progress" — active paving operations captured in imagery.

> Search for "utility trenches and excavation" — underground work visible at street level.

## Permit Verification

> Get the list of active work zones from Boston open data, grouped by neighborhood. Which neighborhoods have the most construction?

> Find construction visible in imagery in the South End, then check if those locations have active work zone permits.

> Search for "construction barriers and road closures" in Back Bay. Cross-reference with the active work zones dataset.

## Benchmarking

> Compare construction activity levels between Dorchester and South Boston. Use both active work zone counts and imagery search results.

> Which neighborhoods have the most emergency construction permits (gas leaks, sewer repairs)?

> What's the ratio of emergency vs. planned construction by neighborhood?

## Impact Analysis

> Find active work zones on streets with the worst pavement conditions. Is construction happening where roads need it most?

> Are there streets with high 311 pothole complaints that have NO active work zones?

## Tips

- Active Work Zones dataset has case-sensitive columns (e.g., "Neighborhood", "Project_Category")
- Use SQL with double-quoted column names: `SELECT "Neighborhood", count(*) FROM "resource-id" GROUP BY "Neighborhood"`
- Imagery search for "construction" returns high-confidence results — construction equipment and barriers are visually distinctive
- Project_Category values include: EMERGENCY, NEW CONDUIT AND/OR MAIN, RESURFACING, etc.
