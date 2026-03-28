# Data Commons MCP — Google Statistical Data Reference

Server name: `data-commons` | 2 tools | Source: Census, UN, WHO, CDC, BLS

## Tools

**CORRECT tool names — do NOT use `search_entities` or `get_statistics` (those are wrong).**

| Tool | Purpose | Key Parameters |
|------|---------|----------------|
| `search_indicators` | Discover statistical variables for a place | `query` (string), `places` (array of human-readable names), `per_search_limit` (int) |
| `get_observations` | Retrieve time series data for a variable + place | `variable_dcid` (string), `place_dcid` (string), `date` (string, use `"latest"`) |

## search_indicators

Takes human-readable place names (not DCIDs):
```
search_indicators(query="population", places=["New York City, USA"], per_search_limit=5)
```

Returns:
- **Topics** with member variables (grouped by theme)
- **Individual variables** with DCIDs (e.g., `Count_Person`)

Use this to discover what data exists before calling `get_observations`.

## get_observations

Takes DCIDs (not human-readable names):
```
get_observations(variable_dcid="Count_Person", place_dcid="geoId/3651000", date="latest")
```

Returns time series data with source metadata. Use `date="latest"` for most recent value.

**Example result:** NYC population = 8,478,072 (2024)

## City DCIDs

| City | place_dcid |
|------|-----------|
| New York City | `geoId/3651000` |
| Boston | `geoId/2507000` |
| Chicago | `geoId/1714000` |
| Los Angeles | `geoId/0644000` |
| San Francisco | `geoId/0667000` |
| Seattle | `geoId/5363000` |

## Common Variables

| variable_dcid | Meaning | Example (NYC) |
|---------------|---------|---------------|
| `Count_Person` | Total population | 8,478,072 (2024) |
| `Median_Income_Person` | Median income | $41,482 (2023) |
| `Median_Age_Person` | Median age | — |
| `Count_HousingUnit` | Housing units | — |
| `UnemploymentRate_Person` | Unemployment rate | — |
| `Count_CriminalActivities_CombinedCrime` | Total crime count | — |

## Workflow

1. **Discover variables:** `search_indicators(query="housing", places=["Chicago, USA"])`
2. **Get data:** `get_observations(variable_dcid="Count_HousingUnit", place_dcid="geoId/1714000", date="latest")`

## Cross-City Comparison Pattern

To compare a metric across cities, call `get_observations` once per city with the same `variable_dcid`:

```
get_observations(variable_dcid="Count_Person", place_dcid="geoId/3651000", date="latest")  # NYC
get_observations(variable_dcid="Count_Person", place_dcid="geoId/2507000", date="latest")  # Boston
get_observations(variable_dcid="Count_Person", place_dcid="geoId/1714000", date="latest")  # Chicago
```

Then present results in a comparison table. Each call returns independently — no built-in multi-city query.

## Gotchas

- **Tool names changed.** The correct names are `search_indicators` and `get_observations`. Old names (`search_entities`, `get_statistics`) will not work.
- **search_indicators takes names, get_observations takes DCIDs.** Do not pass DCIDs to `search_indicators` or names to `get_observations`.
- **Not all variables exist for all cities.** If `get_observations` returns empty, the variable may not be available for that place.
- **Date granularity varies.** Some variables are annual, some monthly. Use `"latest"` to get the most recent regardless.
