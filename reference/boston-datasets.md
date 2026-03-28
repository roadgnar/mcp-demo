# Boston CKAN Datasets

All datasets are on data.boston.gov, queried through the Boston Open Data MCP (`boston`). Always call `get_schema` before writing SQL -- column names are case-sensitive.

## Dataset Directory

### Vision Zero Crashes

| Field | Value |
|-------|-------|
| Resource ID | `e4bfe397-6bfc-49c5-9367-c879fac7401d` |
| Description | All crash records with location, mode type, and timestamp |
| Key columns | `dispatch_ts` (text), `mode_type` (text: `'ped'`, `'bike'`, `'mv'`), `street` (text, UPPERCASE), `lat` (text), `long` (text) |
| Gotchas | No `neighborhood` column — filter by lat/long (CAST to float) or street name. ~40% of records have NULL street. Use `left(dispatch_ts, 4)` for year. |

### Vision Zero Fatalities

| Field | Value |
|-------|-------|
| Resource ID | `92f18923-d4ec-4c17-9405-4e0da63e1d6c` |
| Description | Fatal crash records — separate from the general crash dataset |
| Key columns | Similar schema to crashes but fatalities only |

### Active Work Zones

| Field | Value |
|-------|-------|
| Resource ID | `36fcf981-e414-4891-93ea-f5905cec46fc` |
| Description | Current construction and work zone locations |
| Key columns | `"Neighborhood"`, `"Street"`, `"Project_Category"`, `"Status"`, `"ExpirationDate"` |
| Gotchas | **All columns are PascalCase** — MUST use `execute_sql` with double-quoted column names. `query_data` and `aggregate_data` may fail. |

### Building Permits

| Field | Value |
|-------|-------|
| Resource ID | `6ddcd912-32a0-43df-9908-63574f8c7e77` |
| Description | Building permits issued from 2009 to present |
| Key columns | Neighborhood, address, permit type, status, dates |

### 311 Requests (2026 — Legacy System)

| Field | Value |
|-------|-------|
| Resource ID | `1a0b420d-99f1-4887-9851-990b2a5a6e17` |
| Description | Current year 311 service requests (legacy system) |
| Key columns | `case_title` (text — complaint type), `neighborhood` (text), `latitude` (text), `longitude` (text) |
| Gotchas | **Pothole and sidewalk complaints are ONLY in this dataset**, not the new system. Use ILIKE for `case_title` filtering. |

### 311 Requests (New System)

| Field | Value |
|-------|-------|
| Resource ID | `254adca6-64ab-4c5c-9fc0-a6da622be185` |
| Description | Post October 2025 requests from the new 311 system |
| Key columns | Different schema from legacy — check `get_schema` |
| Gotchas | Does NOT contain pothole or sidewalk categories. For those, use the legacy dataset above. |

### Safety Concerns

| Field | Value |
|-------|-------|
| Resource ID | `42c33f05-2572-404e-9782-38d755f0f069` |
| Description | Community-reported safety hazards and concerns |
| Key columns | Location, concern type, status |

## Query Tips

- **Default tool:** `execute_sql` — most reliable for all queries
- **Schema first:** Always `get_schema(resource_id)` before writing SQL
- **Resource IDs in SQL:** Must be double-quoted in FROM clauses: `SELECT * FROM "e4bfe397-6bfc-49c5-9367-c879fac7401d"`
- **Year extraction:** `EXTRACT()` is blocked — use `left(field, 4)` instead
- **Spatial filtering:** lat/long columns are TEXT — use `CAST(lat AS FLOAT) BETWEEN x AND y`
- **Street names:** UPPERCASE in crash data (`'BLUE HILL AVE'` not `'Blue Hill Ave'`)
- **Avoid `query_data` filters:** The `filters` parameter returns HTTP 409 errors. Use `execute_sql` with WHERE clauses.
