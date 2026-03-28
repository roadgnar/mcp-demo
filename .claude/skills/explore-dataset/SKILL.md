---
name: explore-dataset
description: Explore and query open data from Boston, NYC, or other supported cities.
allowed-tools: mcp__claude_ai_Boston_CIO_MCP__*, mcp__boston__*, mcp__socrata__*, mcp__data-commons__*
argument-hint: [topic to search for, e.g. "trees", "crime", "budget"]
---

# Explore Open Data

Search and query datasets from Boston, NYC, and other supported cities.

## Workflow

0. **Determine city.**
   - Boston → use boston MCP (`search_datasets`).
   - NYC / Chicago / SF / Seattle / LA → use socrata MCP (`search`).
   - Any city demographics → use data-commons MCP (`search_indicators`).

### Boston (CKAN)

1. **Search:** `search_datasets("$ARGUMENTS")`
2. **Inspect:** `get_dataset(dataset_id)` → list resources and descriptions
3. **Schema:** `get_schema(resource_id)` → see column names and types
4. **Sample:** `query_data(resource_id, limit=5)` → preview records
5. **Analyze:** `aggregate_data` or `execute_sql` for rollups

### Socrata (NYC, Chicago, SF, Seattle, LA)

1. **Search:** `search(query="$ARGUMENTS", domain="data.cityofnewyork.us")`
2. **Preview:** `get_data(dataset_id, query="SELECT * LIMIT 1")` → discover columns
3. **Query:** `get_data(dataset_id, query="SELECT ...")` with SoQL filters

### Data Commons (any city demographics)

1. **Search:** `search_indicators(query="$ARGUMENTS", places=["City, USA"])`
2. **Get data:** `get_observations(variable_dcid, place_dcid, date="latest")`

## SQL Tips
- Boston: Double-quote resource IDs: `FROM "uuid-here"`
- Boston: Column names may be case-sensitive — always check schema first
- Boston: `EXTRACT()` is blocked — use `left(field, N)` for date parts
- Boston: `query_data` filters use exact match only and fail on some datasets — prefer `execute_sql`
- Socrata SoQL: case-sensitive — use `upper(column) LIKE '%VALUE%'`, never `ILIKE`
- Active Work Zones uses PascalCase columns: `"Neighborhood"`, `"Project_Category"`

## Known Datasets

**Boston (CKAN):**
| Topic | Resource ID |
|-------|------------|
| Crashes | `e4bfe397-6bfc-49c5-9367-c879fac7401d` |
| Fatalities | `92f18923-d4ec-4c17-9405-4e0da63e1d6c` |
| Work Zones | `36fcf981-e414-4891-93ea-f5905cec46fc` |
| Building Permits | `6ddcd912-32a0-43df-9908-63574f8c7e77` |
| 311 (2026) | `1a0b420d-99f1-4887-9851-990b2a5a6e17` |
| 311 (New System) | `254adca6-64ab-4c5c-9fc0-a6da622be185` |
| Safety Concerns | `42c33f05-2572-404e-9782-38d755f0f069` |

**NYC (Socrata):**
| Topic | Dataset ID |
|-------|-----------|
| 311 Requests | `erm2-nwe9` |
| Restaurant Inspections | `43nn-pn8j` |
| Housing Violations | `wvxf-dwi5` |
| Motor Vehicle Collisions | `h9gi-nx95` |
