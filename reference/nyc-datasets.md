# NYC Datasets Reference

## Cyvl Projects (Infrastructure Imagery)

| Area | Project ID | Tools Available |
|------|-----------|-----------------|
| Jackson Heights | `1924f65d-01b6-4170-b0b8-ddf6a887b6e5` | All 19 Cyvl tools |
| Long Island City | `5be713ea-d739-4ecc-876d-ccadbe57c04b` | All 19 Cyvl tools |
| Jamaica | `e57afa42-1052-4313-a26b-8df6e3154a58` | All 19 Cyvl tools |
| Manhattan Pilot | `8cb1a9f3-f2ac-4de9-ad00-b8187db3e63f` | All tools, but partial coverage |

**Cyvl tools include:** `search_imagery`, `list_pavement_scores`, `list_distresses`, `list_signs`, `list_above_ground_assets`, `list_markings`, `assess_infrastructure`, `geocode_location`, and more.

---

## Socrata Datasets (NYC Open Data)

Domain: `data.cityofnewyork.us`

### 311 Service Requests (`erm2-nwe9`)

The primary dataset for civic complaints. ~10K new records per day.

| Column | Type | Notes |
|--------|------|-------|
| `unique_key` | text | Record identifier |
| `created_date` | floating_timestamp | When the complaint was filed |
| `complaint_type` | text | Category (e.g., "Noise - Residential") |
| `descriptor` | text | Subcategory detail |
| `borough` | text | BRONX, BROOKLYN, MANHATTAN, QUEENS, STATEN ISLAND |
| `incident_zip` | text | Zip code |
| `incident_address` | text | Street address |
| `location` | point | Lat/long (supports `within_circle`) |

**Queens filter:** `WHERE upper(borough) = 'QUEENS'`

### Restaurant Inspections (`43nn-pn8j`)

DOHMH restaurant inspection results with grades.

| Column | Type | Notes |
|--------|------|-------|
| `camis` | text | Unique restaurant ID |
| `dba` | text | Restaurant name (doing business as) |
| `boro` | text | Borough code: 1=Manhattan, 2=Bronx, 3=Brooklyn, 4=Queens, 5=SI |
| `zipcode` | text | Zip code |
| `cuisine_description` | text | Cuisine type |
| `inspection_date` | floating_timestamp | Date of inspection |
| `violation_code` | text | Specific violation |
| `violation_description` | text | Description of violation |
| `grade` | text | A, B, C, or blank (pending) |

**Queens filter:** `WHERE boro = '4'`
**Jackson Heights zips:** 11372, 11373

### Housing Violations (`wvxf-dwi5`)

HPD housing maintenance code violations.

| Column | Type | Notes |
|--------|------|-------|
| `violationid` | number | Unique violation ID |
| `boroid` | text | Borough: 1=Manhattan, 2=Bronx, 3=Brooklyn, 4=Queens, 5=SI |
| `block` | text | Tax block |
| `lot` | text | Tax lot |
| `class` | text | Violation class: A (non-hazardous), B (hazardous), C (immediately hazardous) |
| `inspectiondate` | floating_timestamp | When violation was observed |
| `approveddate` | floating_timestamp | When violation was approved |
| `currentstatus` | text | VIOLATION OPEN, VIOLATION CLOSED |
| `violationstatus` | text | Status detail |
| `ordernumber` | text | Order category |

**Queens filter:** `WHERE boroid = '4'`

---

## SoQL Gotchas

1. **No ILIKE.** SoQL is case-sensitive. Use `upper(column) LIKE '%VALUE%'` for case-insensitive matching.
2. **Always add date filters** on 311 data. Without them, queries scan millions of records and timeout.
   ```
   WHERE created_date > '2026-01-01'
   ```
3. **Borough values differ by dataset.** 311 uses full names (`'QUEENS'`), restaurant inspections use codes (`'4'`), housing violations use codes (`'4'`).
4. **`within_circle` requires a location column.** Not all datasets have one. 311 has `location`; others may need zip code or address filtering.
5. **`SELECT * LIMIT 1` first.** Always discover columns before writing real queries. Column names vary between datasets.
6. **Date functions:** Use `DATE_TRUNC_MONTH(date)` for monthly aggregation, `DATE_TRUNC_Y(date)` for yearly.
