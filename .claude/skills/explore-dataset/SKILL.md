---
name: explore-dataset
description: Explore and query Boston open data. Use when the user wants to find, browse, or analyze city datasets.
allowed-tools: mcp__claude_ai_Boston_CIO_MCP__*, mcp__boston__*
argument-hint: [topic to search for, e.g. "trees", "crime", "budget"]
---

# Explore Boston Open Data

Search and query datasets from data.boston.gov.

## Workflow

1. **Search:** `search_datasets("$ARGUMENTS")`
2. **Inspect:** `get_dataset(dataset_id)` → list resources and descriptions
3. **Schema:** `get_schema(resource_id)` → see column names and types
4. **Sample:** `query_data(resource_id, limit=5)` → preview records
5. **Analyze:** `aggregate_data` or `execute_sql` for rollups

## SQL Tips
- Double-quote resource IDs: `FROM "uuid-here"`
- Column names may be case-sensitive — always check schema first
- `EXTRACT()` is blocked — use `left(field, N)` for date parts
- Filters in `query_data` are simple key-value: `{"field": "value"}`
- `query_data` filters use exact match only and fail on some datasets — prefer `execute_sql` with WHERE clauses for reliable filtering
- For GROUP BY with `aggregate_data`, columns must be lowercase unless the schema says otherwise
- Active Work Zones uses PascalCase columns: `"Neighborhood"`, `"Project_Category"`

## Known Datasets
| Topic | Resource ID |
|-------|------------|
| Crashes | `e4bfe397-6bfc-49c5-9367-c879fac7401d` |
| Fatalities | `92f18923-d4ec-4c17-9405-4e0da63e1d6c` |
| Work Zones | `36fcf981-e414-4891-93ea-f5905cec46fc` |
| Building Permits | `6ddcd912-32a0-43df-9908-63574f8c7e77` |
| 311 (2026) | `1a0b420d-99f1-4887-9851-990b2a5a6e17` |
| 311 (New System) | `254adca6-64ab-4c5c-9fc0-a6da622be185` |
| Safety Concerns | `42c33f05-2572-404e-9782-38d755f0f069` |
