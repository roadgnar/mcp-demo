# Boston Open Data — Dataset Reference

Portal: data.boston.gov | MCP server: `boston` | 6 tools

## Tools

| Tool | Purpose | When to Use |
|------|---------|-------------|
| `search_datasets` | Full-text search across all datasets | First step — find what exists |
| `get_dataset` | Get metadata + list of resources | Get resource IDs |
| `get_schema` | Column names and types for a resource | Before querying — know the fields |
| `query_data` | Fetch rows with optional filters | Simple lookups, spot checks |
| `aggregate_data` | GROUP BY with metrics | Analytics, summaries |
| `execute_sql` | Raw PostgreSQL SELECT | Complex queries, joins, window functions |

## Key Datasets

### Vision Zero Crash Records
- **Resource ID:** `e4bfe397-6bfc-49c5-9367-c879fac7401d`
- **Fields:** `dispatch_ts`, `mode_type`, `location_type`, `street`, `xstreet1`, `xstreet2`, `lat`, `long`
- **Coverage:** 2015-2025, ~53K records
- **`mode_type` values:** `'ped'`, `'bike'`, `'mv'` — abbreviated, NOT spelled out
- **`street`:** UPPERCASE — `'WASHINGTON ST'`, `'BLUE HILL AVE'`
- **`lat`/`long`:** TEXT type — must `CAST(lat AS FLOAT)` for numeric operations
- **~40% of records have NULL street names** — aggregations by street will undercount
- **No `neighborhood` column** — filter by street name or use CAST lat/long with BETWEEN
- **No severity field.** One record per incident.

### Vision Zero Fatality Records
- **Resource ID:** `92f18923-d4ec-4c17-9405-4e0da63e1d6c`
- **Fields:** `date_time`, `mode_type`, `street`, `xstreet1`, `xstreet2`, `lat`, `long`

### 311 Service Requests

**New System (Oct 2025+):**
- **Resource ID:** `254adca6-64ab-4c5c-9fc0-a6da622be185`
- **Fields:** `case_id`, `open_date`, `case_topic`, `service_name`, `assigned_department`, `case_status`, `neighborhood`, `latitude`, `longitude`
- **Filter potholes:** `service_name` containing "pothole"

**Legacy (2026, pre-transition):**
- **Resource ID:** `1a0b420d-99f1-4887-9851-990b2a5a6e17`
- **Fields:** `case_enquiry_id`, `open_dt`, `case_title`, `subject`, `reason`, `type`, `neighborhood`, `latitude`, `longitude`
- **Filter potholes:** `case_title ILIKE '%pothole%'` — returns `'Request for Pothole Repair'`, `'Pothole'`, `'BWSC Pothole'`
- **Filter sidewalks:** `case_title ILIKE '%sidewalk%'` — returns `'Sidewalk Repair (Make Safe)'`, `'Unshoveled Sidewalk'`
- **WARNING:** The `type` field is NOT the complaint type — use `case_title` instead

**Historical:** Resources exist for every year 2011-2025.

### Public Works Active Work Zones
- **Resource ID:** `36fcf981-e414-4891-93ea-f5905cec46fc`
- **Fields:** `Neighborhood`, `Street`, `Address_1`, `Permittee`, `Contractor`, `Permit`, `Project_Category`, `Construction_Notes`, `Status`, `ExpirationDate`, `Estimated_Completion_Date`, `Roadway_Plates_In_Use`, `Sidewalk_Plates_In_Use`
- **IMPORTANT:** Column names are **PascalCase** and case-sensitive in SQL. Use double quotes: `"Neighborhood"`, `"Project_Category"`

### Approved Building Permits
- **Resource ID:** `6ddcd912-32a0-43df-9908-63574f8c7e77`
- **Fields:** `permitnumber`, `worktype`, `permittypedescr`, `description`, `applicant`, `declared_valuation`, `issued_date`, `status`, `address`, `y_latitude`, `x_longitude`

### Vision Zero Safety Concerns
- **Resource ID:** `42c33f05-2572-404e-9782-38d755f0f069`
- **Fields:** `date_and_time`, `your_mode_of_transportation`, `request`, `additional_comments`, `POINT_X`, `POINT_Y`

## SQL Gotchas

1. **Double-quote resource IDs:** `FROM "e4bfe397-6bfc-49c5-9367-c879fac7401d"`
2. **Case-sensitive columns:** Active Work Zones uses `"Neighborhood"`, not `neighborhood`
3. **No EXTRACT():** Use `left(dispatch_ts, 4)` instead of `EXTRACT(YEAR FROM ...)`
4. **Text coordinates:** Crash data lat/long are text type — cast with `::float` for math
5. **`query_data` filters FAIL on most datasets** — always use `execute_sql` with WHERE clauses for filtered queries. `query_data` works fine for unfiltered sampling with `limit`.
6. **`aggregate_data` fails on PascalCase columns** — Active Work Zones breaks `aggregate_data` because it lowercases column names. Always use `execute_sql` for Work Zones.
7. **Work Zone category spelling** — "NEW CONDUIT AND / OR MAIN" and "NEW CONDUIT AND/OR MAIN" are both present. Use `LIKE '%NEW CONDUIT%'` instead of exact match.

## 311 Data Warning

- **Pothole/sidewalk data is ONLY in the legacy 311 dataset** (`1a0b420d-...`) — filter on `case_title` (NOT `type`)
- **The New System dataset** (`254adca6-...`) does NOT contain pothole or sidewalk categories — only ~7K records, mostly animal control and street lights
- When querying 311 for infrastructure complaints, always use the legacy/year-specific resource

## Datasets NOT Available (Use Cyvl Instead)

These come up frequently but don't exist in Boston's open data:
- **Sidewalk conditions** — Boston has geometry-only "Sidewalk Centerline" and "Sidewalk Inventory" from 2011, but NO condition data. Use Cyvl imagery search.
- **Curb management / loading zones** — use Cyvl imagery search
- **Pavement condition scores** — use Cyvl MCP
- **Street-level imagery** — use Cyvl MCP
