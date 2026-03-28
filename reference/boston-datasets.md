# Boston Open Data -- CKAN Dataset Reference

Server: `boston` | Portal: data.boston.gov | 6 tools

## Datasets

### Vision Zero Crashes
- **Resource ID:** `e4bfe397-6bfc-49c5-9367-c879fac7401d`
- **Key columns:** `dispatch_ts` (text), `mode_type` (text), `street` (text), `lat` (text), `long` (text)
- **Gotchas:**
  - `mode_type` values are abbreviated: `'mv'`, `'ped'`, `'bike'` -- not spelled out
  - `street` is UPPERCASE: `'BLUE HILL AVE'` not `'Blue Hill Ave'`
  - ~40% of records have NULL street
  - `lat` and `long` are TEXT -- must `CAST(lat AS FLOAT)` for spatial queries
  - Use `left(dispatch_ts, 4)` for year extraction -- `EXTRACT()` is blocked on this portal
  - No `neighborhood` column -- filter by coordinates or street name

### Vision Zero Fatalities
- **Resource ID:** `92f18923-d4ec-4c17-9405-4e0da63e1d6c`
- **Key columns:** Same schema as crashes
- **Gotchas:** Same as crashes. Small dataset -- fatal crashes only.

### Active Work Zones
- **Resource ID:** `36fcf981-e414-4891-93ea-f5905cec46fc`
- **Key columns:** `"Neighborhood"`, `"Street"`, `"Project_Category"`, `"Status"`, `"ExpirationDate"`
- **Gotchas:**
  - **All columns are PascalCase** -- must double-quote in SQL: `SELECT "Street", "Neighborhood" FROM "36fcf981-e414-4891-93ea-f5905cec46fc"`
  - Must use `execute_sql` -- other tools fail with PascalCase columns
  - Column names are case-sensitive

### Building Permits
- **Resource ID:** `6ddcd912-32a0-43df-9908-63574f8c7e77`
- **Key columns:** varies -- always call `get_schema` first
- **Gotchas:** Covers 2009 to present. Large dataset.

### 311 Requests -- Legacy (2026)
- **Resource ID:** `1a0b420d-99f1-4887-9851-990b2a5a6e17`
- **Key columns:** `case_title` (text), `neighborhood` (text), `latitude` (text), `longitude` (text)
- **Gotchas:**
  - **Pothole and sidewalk complaints are ONLY in this dataset** -- the new system does not have them
  - Use `ILIKE` for case_title filtering: `case_title ILIKE '%pothole%'`
  - `latitude` and `longitude` are TEXT

### 311 Requests -- New System
- **Resource ID:** `254adca6-64ab-4c5c-9fc0-a6da622be185`
- **Key columns:** varies -- call `get_schema` first
- **Gotchas:**
  - Post October 2025 requests only
  - Does NOT contain pothole or sidewalk categories -- use the legacy dataset for those

### Safety Concerns
- **Resource ID:** `42c33f05-2572-404e-9782-38d755f0f069`
- **Key columns:** varies -- call `get_schema` first
- **Gotchas:** Community-reported safety hazards. Complements official crash data.

## Query Patterns

**Always start with schema discovery:**
```sql
-- Check columns before querying
get_schema("e4bfe397-6bfc-49c5-9367-c879fac7401d")
```

**Resource IDs must be double-quoted in FROM clauses:**
```sql
SELECT * FROM "e4bfe397-6bfc-49c5-9367-c879fac7401d" LIMIT 5
```

**Year extraction (EXTRACT is blocked):**
```sql
SELECT left(dispatch_ts, 4) AS year, COUNT(*) FROM "e4bfe397-6bfc-49c5-9367-c879fac7401d" GROUP BY year
```

**Spatial filtering with TEXT coordinates:**
```sql
SELECT * FROM "e4bfe397-6bfc-49c5-9367-c879fac7401d"
WHERE CAST(lat AS FLOAT) BETWEEN 42.29 AND 42.32
  AND CAST(long AS FLOAT) BETWEEN -71.09 AND -71.06
```

## Tool Selection

| Tool | When to Use |
|------|-------------|
| `execute_sql` | Default for all queries. Most reliable. |
| `get_schema` | Before any query on a new resource. Non-negotiable. |
| `get_dataset` | Metadata and resource IDs for a dataset. |
| `search_datasets` | Find datasets by keyword. |
| `aggregate_data` | Simple GROUP BY on lowercase-column datasets only. |
| `query_data` | Unfiltered sampling with `limit` only. Never use filters -- returns HTTP 409. |
