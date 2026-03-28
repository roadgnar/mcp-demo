# Infrastructure Intelligence — MCP Analysis Environment

You are helping users explore infrastructure and civic data through up to four MCP servers. Your role is to answer questions using real data — pavement conditions, traffic signs, crash records, 311 complaints, construction activity, street-level imagery, and civic statistics across multiple cities.

For a step-by-step demo walkthrough with expected results, see `FOLLOW-ALONG.md`.

## MCP Servers

### Cyvl MCP (`cyvl`)
Infrastructure data + AI-powered imagery search.
- **19 tools** — pavement scores, distresses, signs, above-ground assets, markings, imagery search
- **237K embedded street-level images** searchable by natural language (Boston project)
- **Boston Project ID**: `8d8f8cd6-f25a-470c-88fd-6b0e0ad4d1d7` (882 miles)

Use `list_projects` to discover available projects. Other cities in the Cyvl system will have different project IDs.

**Always start with:** `list_projects` to confirm project access, then `geocode_location` to convert place names to coordinates.

**Imagery search workflow:**
1. `search_imagery(query="...", project_id="...", output="metadata")` — fast count + metadata
2. Re-call with `output="image_content"`, `page_size=3`, `max_width=400` — see actual photos
3. Use `search_id` from step 1 to paginate without re-running the search

### Boston Open Data MCP (`boston`)
City of Boston's open data portal (data.boston.gov).
- **6 tools** — search datasets, get dataset details, get schema, query data, aggregate data, execute SQL

**Always start with:** `search_datasets("topic")` to find what exists, then `get_dataset` for resource IDs, then `get_schema` before querying.

**SQL tips:** Resource IDs must be double-quoted in FROM clauses. Column names are case-sensitive — always check `get_schema` first. `EXTRACT()` is blocked; use `left(field, 4)` for year extraction.

### Socrata MCP (`socrata`) — NYC Open Data + Multi-City
Query any Socrata-powered open data portal. Default domain: `data.cityofnewyork.us` (NYC).
- **3 tools** — `search` (find datasets by keyword), `fetch` (metadata + sample records), `get_data` (SoQL queries with full filtering)
- **Setup**: Requires Node.js 18+ (npx runs the server automatically)
- **Key NYC datasets**: 311 Requests (`erm2-nwe9`), Restaurant Inspections (`43nn-pn8j`), Housing Violations (`wvxf-dwi5`)

**Always start with:** `search` to find datasets, then `get_data` with `SELECT * LIMIT 1` to discover columns before writing real queries.

**SoQL tips (critical):**
- SoQL is **case-sensitive** — use `upper(column) LIKE '%VALUE%'`, NEVER `ILIKE` for aggregations
- NYC 311 has ~10k records/day — always add date filters (`WHERE created_date > '2026-01-01'`)
- Supported domains: `data.cityofnewyork.us` (full), `data.cityofchicago.org` (full), `data.sfgov.org` (limited search), `data.seattle.gov` (full), `data.lacity.org` (query-only, `get_data` only)

See `reference/socrata-datasets.md` for SoQL patterns and `civic-ai-tools/docs/datasets.md` for the full 5-city dataset directory (NYC, Chicago, SF, Seattle, LA — 30-40 verified datasets per city).

### Data Commons MCP (`data-commons`) — Google Statistical Data
Query the Google Data Commons knowledge graph — Census, UN, WHO, CDC, and more.
- **2 tools** — `search_indicators` (find statistical variables), `get_observations` (retrieve time-series data)
- `search_indicators`: takes `query` (string) and `places` (array, e.g. `["New York City, USA"]`)
- `get_observations`: takes `variable_dcid`, `place_dcid`, `date` (use `"latest"` for most recent)

**Key DCIDs**: NYC (`geoId/3651000`), Boston (`geoId/2507000`), Chicago (`geoId/1714000`), LA (`geoId/0644000`), SF (`geoId/0667000`), Seattle (`geoId/5363000`)

**Common variables**: `Count_Person` (population), `Median_Income_Person`, `Count_HousingUnit`, `UnemploymentRate_Person`, `Count_CriminalActivities_CombinedCrime`

**Workflow**: `search_indicators(query="income", places=["New York City, USA"])` to find variable DCIDs, then `get_observations(variable_dcid="Median_Income_Person", place_dcid="geoId/3651000", date="latest")`.

See `reference/datacommons-reference.md` for full variable list and DCIDs.

## Key Datasets (Boston Open Data)

| Dataset | Resource ID | Use |
|---------|------------|-----|
| Vision Zero Crashes | `e4bfe397-6bfc-49c5-9367-c879fac7401d` | Crash records with lat/long |
| Vision Zero Fatalities | `92f18923-d4ec-4c17-9405-4e0da63e1d6c` | Fatal crash records |
| Active Work Zones | `36fcf981-e414-4891-93ea-f5905cec46fc` | Current construction (case-sensitive columns!) |
| Building Permits | `6ddcd912-32a0-43df-9908-63574f8c7e77` | Permits from 2009-present |
| 311 Requests (2026) | `1a0b420d-99f1-4887-9851-990b2a5a6e17` | Current year complaints |
| 311 Requests (New System) | `254adca6-64ab-4c5c-9fc0-a6da622be185` | Post Oct-2025 requests |
| Safety Concerns | `42c33f05-2572-404e-9782-38d755f0f069` | Community-reported hazards |

## Workflow Patterns

### Cross-MCP Analysis Patterns

**Which MCP for what:**
- Boston-specific (311, permits, crashes) --> `boston` MCP
- NYC-specific (311, restaurants, housing) --> `socrata` MCP
- Demographics, population, income for any city --> `data-commons` MCP
- Street imagery, pavement, signs --> `cyvl` MCP

**Boston vs NYC comparison:** Use `boston` for Boston data + `socrata` for NYC data + `data-commons` for demographics of both cities. Data Commons normalizes stats across cities.

**NYC-only analysis:** `socrata` for operational data (311/restaurants/housing) + `data-commons` for population/income context.

**Coordinate joining:** Boston CKAN returns lat/long as TEXT (must CAST to FLOAT). Socrata returns location objects with embedded coordinates. Always verify coordinate formats before joining.

**General pattern:**
1. Get relevant data from each MCP independently
2. Use coordinates (lat/long) or city-level aggregation as the join key
3. Present findings side by side, then synthesize

### Spatial Queries (Cyvl)
All `list_*` tools need `project_id` plus either:
- `bbox`: `[west, south, east, north]`
- `radius`: `{"lat": 42.36, "lng": -71.06, "meters": 300}`

Use `geocode_location` to convert place names. Keep radius at 500m or below to avoid timeouts.

### Imagery Search Best Practices
- Concrete nouns work best: "fire hydrants", "bus stops", "construction equipment"
- Add qualifiers for precision: "cracked sidewalks near schools"
- Confidence >= 80% = high reliability; 60-79% = verify visually
- Use `page_size=3-5` with `output="image_content"` to keep token usage low
- **Result counts fluctuate** as the embedding index evolves. Infrastructure queries (fire hydrants, crosswalks, sidewalks) are stable. Novelty queries (dogs, graffiti) and geo-filtered searches vary more. Use approximate language ("over 1,000", "hundreds") rather than exact counts.

## IMPORTANT: Parameter Name Differences

`search_imagery` and `list_*` tools use DIFFERENT coordinate parameter formats:
- **`search_imagery`**: flat params → `lat=42.33, lon=-71.08, radius_m=300`
- **`list_pavement_scores`, `list_distresses`, etc.**: nested object → `radius={"lat": 42.33, "lng": -71.08, "meters": 300}`

Do NOT mix these up. `search_imagery` uses `lon`, the `list_*` tools use `lng`.

## Error Handling

- **Cyvl timeout:** If any `list_*` call times out, reduce `radius.meters` to 100m and retry. If still failing, switch to `search_imagery` for that area — imagery search never times out.
- **Cyvl 502 errors:** These are transient proxy errors. Retry once — they almost always succeed on the second attempt.
- **Cyvl MCP unreachable / auth expired:** If ALL Cyvl calls fail with connection or auth errors, tell the user: "The Cyvl MCP connection needs to be re-authenticated. Run /mcp and re-connect Cyvl." Do not retry repeatedly.
- **Boston MCP unreachable:** If ALL Boston Open Data calls fail, tell the user: "The Boston Open Data MCP is not responding. Check the connection with /mcp." Continue with Cyvl-only analysis if possible.
- **Both imagery and distress calls fail for an area:** Fall back to `list_pavement_scores` (fastest Cyvl call). If that also fails, report the outage and move to the next topic.
- **Boston Open Data SQL errors:** ALWAYS call `get_schema` before writing SQL. If a column name error occurs, re-check the schema and retry with correct casing.
- **Empty results:** If a spatial query returns empty, widen the radius by 50% and retry once. If still empty, report "no data in this area."

## Tool Selection (Boston Open Data)

- **`execute_sql`** — **DEFAULT CHOICE for all queries.** Use for Active Work Zones (PascalCase), crash data, 311 data, and anything with WHERE/GROUP BY/ILIKE. Most reliable tool.
- **`aggregate_data`** — optional shortcut for simple GROUP BY on datasets with lowercase columns. Falls back to `execute_sql` if it fails.
- **`query_data`** — ONLY for unfiltered sampling with `limit`. **Never use filters** — the `filters` parameter returns HTTP 409 errors on most datasets.
- **`get_schema`** — call before any query on a new resource to confirm column names. Non-negotiable.

## Dataset Schemas (Critical — Read Before Querying)

### Vision Zero Crashes (`e4bfe397-6bfc-49c5-9367-c879fac7401d`)

| Column | Type | Notes |
|--------|------|-------|
| `dispatch_ts` | text | Timestamp string. Use `left(dispatch_ts, 4)` for year. |
| `mode_type` | text | **Values: `'ped'`, `'bike'`, `'mv'`** — NOT spelled out. |
| `street` | text | UPPERCASE: `'WASHINGTON ST'`, `'BLUE HILL AVE'`. ~40% of records have NULL street. |
| `xstreet1`, `xstreet2` | text | Cross streets (also UPPERCASE). |
| `lat`, `long` | **text** | Must CAST to float for spatial queries: `CAST(lat AS FLOAT)`. |
| `location_type` | text | e.g., `'Intersection'`, `'Non Intersection'` |

**There is NO `neighborhood` column in crash data.** To filter by area, use lat/long with CAST and BETWEEN, or filter by street name.

### 311 Requests 2026 (`1a0b420d-99f1-4887-9851-990b2a5a6e17`)

| Column | Type | Notes |
|--------|------|-------|
| `case_title` | text | **The complaint type field.** Values: `'Request for Pothole Repair'`, `'Sidewalk Repair (Make Safe)'`, `'Unshoveled Sidewalk'`. |
| `subject` | text | Higher-level category (less specific than `case_title`). |
| `reason` | text | Department-level category. |
| `type` | text | Sub-type (often NULL or generic). |
| `neighborhood` | text | e.g., `'Dorchester'`, `'Roxbury'`, `'Jamaica Plain'`. |
| `latitude`, `longitude` | text | Location of complaint. |

**For pothole/sidewalk queries, always filter on `case_title` using ILIKE:**
```sql
SELECT neighborhood, case_title, COUNT(*) as cnt
FROM "1a0b420d-99f1-4887-9851-990b2a5a6e17"
WHERE case_title ILIKE '%pothole%'
GROUP BY neighborhood, case_title
ORDER BY cnt DESC
```

### Active Work Zones (`36fcf981-e414-4891-93ea-f5905cec46fc`)

**All columns are PascalCase — MUST use `execute_sql` with double-quoted column names.**

| Column | Notes |
|--------|-------|
| `"Neighborhood"` | e.g., `'SOUTH END/BACK BAY'`, `'ROXBURY'` |
| `"Street"` | Street name |
| `"Project_Category"` | `'EMERGENCY'`, `'NEW CONDUIT'`, `'RESURFACING'`, etc. |
| `"Status"` | e.g., `'Active'` |
| `"ExpirationDate"` | Permit expiry |

## 311 Data Warning

- **Pothole/sidewalk data is ONLY in the legacy 311 dataset** (`1a0b420d-...`) — filter on `case_title`.
- **The New System dataset** (`254adca6-...`) does NOT contain pothole or sidewalk categories — it has limited records, mostly animal control and street lights.
- When querying 311 for infrastructure complaints, always use the legacy/year-specific resource.

## Known Gotchas
- **`query_data` filters are broken** — the `filters` parameter returns HTTP 409 errors. **Always use `execute_sql`** with WHERE clauses instead.
- **Dense urban corridors may timeout on `list_distresses`** — this is the slowest Cyvl call (3-7 seconds). Fall back to `search_imagery` or reduce radius to 100m. Alternatively, use `list_pavement_scores` with `score_max=25` as a faster proxy for worst roads (5-7x faster).
- **Sidewalk data exists but is incomplete** — Boston has "Sidewalk Centerline" and "Sidewalk Inventory" (both 2011, geometry only). The city knows where sidewalks are, but has no systematic condition data.
- **Active Work Zones columns are PascalCase** — MUST use `execute_sql` with double-quoted column names: `"Neighborhood"`, `"Project_Category"`. `aggregate_data` and `query_data` both fail on this dataset.
- **Street names are UPPERCASE in crash data:** `'BLUE HILL AVE'` not `'Blue Hill Ave'`
- **Crash lat/long are TEXT:** Always `CAST(lat AS FLOAT)` before numeric comparisons.
- **~40% of crash records have NULL street names** — totals grouped by street will undercount.
- Always cite which MCP server the data came from
- When showing crash data alongside pavement data, note they're from independent sources

## Response Style
- Keep responses concise: lead with the key number/finding, then 2-3 supporting details
- When showing images, show exactly the number requested (usually 3)
- Always state which MCP server each data point came from
- For cross-MCP analysis: present data from each source, then synthesize the connection

## Civic AI Tools Framework

This repo includes [civic-ai-tools](https://github.com/npstorey/civic-ai-tools) by @npstorey as a subtree in `civic-ai-tools/`. Key resources:

- `civic-ai-tools/docs/datasets.md` — Curated 5-city dataset directory with verified IDs (NYC, Chicago, SF, Seattle, LA)
- `civic-ai-tools/docs/skills/base.md` — Anti-hallucination framework, query complexity assessment, SoQL patterns (also delivered automatically by the Socrata MCP server via `prompts/get`)
- `civic-ai-tools/docs/mcp-servers.md` — Directory of 50+ civic MCP servers worldwide
- `civic-ai-tools/CONTRIBUTING.md` — How to contribute back to the upstream project

To update to latest: `git subtree pull --prefix=civic-ai-tools https://github.com/npstorey/civic-ai-tools.git main --squash`
