# NYC Datasets — Quick Reference

## Cyvl Projects (nycsod org)

| Area | Project ID |
|------|-----------|
| Jackson Heights, Queens | `1924f65d-01b6-4170-b0b8-ddf6a887b6e5` |
| Long Island City, Queens | `5be713ea-d739-4ecc-876d-ccadbe57c04b` |
| Jamaica, Queens | `e57afa42-1052-4313-a26b-8df6e3154a58` |
| Manhattan Pilot (partial) | `8cb1a9f3-f2ac-4de9-ad00-b8187db3e63f` |

Use `search_imagery`, `list_pavement_scores`, `list_distresses`, and other Cyvl tools with these project IDs. See `nyc-spatial.md` for neighborhood coordinates.

---

## Socrata Datasets (data.cityofnewyork.us)

### 311 Service Requests — `erm2-nwe9`

NYC's unified 311 complaint dataset. ~37M+ records total, ~10K new records per day.

**Key columns:** `complaint_type`, `descriptor`, `borough`, `city`, `created_date`, `closed_date`, `latitude`, `longitude`, `incident_zip`

**SoQL gotchas:**
- Always add date filters: `WHERE created_date > '2026-01-01'` — the full dataset is massive
- Borough values are UPPERCASE: `'QUEENS'`, `'MANHATTAN'`, `'BROOKLYN'`, `'BRONX'`, `'STATEN ISLAND'`
- SoQL is case-sensitive — use `upper(column)` for safe matching, NEVER `ILIKE`
- `complaint_type` values vary in casing — always `SELECT DISTINCT complaint_type LIMIT 50` first

**Common queries:**
```
SELECT complaint_type, count(*) as cnt WHERE borough = 'QUEENS' AND created_date > '2026-01-01' GROUP BY complaint_type ORDER BY cnt DESC LIMIT 20
```

### Restaurant Inspections (DOHMH) — `43nn-pn8j`

NYC restaurant inspection results with grades.

**Key columns:** `camis` (restaurant ID), `dba` (name), `boro`, `zipcode`, `cuisine_description`, `inspection_date`, `action`, `violation_code`, `violation_description`, `critical_flag`, `score`, `grade`

**SoQL gotchas:**
- `boro` values are UPPERCASE: `'QUEENS'`, `'MANHATTAN'`, etc.
- `grade` values: `'A'`, `'B'`, `'C'`, `'Z'` (pending), `'P'` (pending grade)
- Multiple rows per restaurant (one per violation per inspection) — aggregate by `camis` for unique restaurants
- `score` is numeric — lower is better (0 = no violations)

**Common queries:**
```
SELECT grade, count(*) as cnt WHERE boro = 'QUEENS' AND inspection_date > '2025-01-01' GROUP BY grade ORDER BY cnt DESC
```

### Housing Violations (HPD) — `wvxf-dwi5`

HPD housing code violations across NYC.

**Key columns:** `boroid`, `block`, `lot`, `buildingid`, `streetname`, `zip`, `violationid`, `violationstatus`, `class`, `novdescription`, `inspectiondate`, `currentstatusdate`, `latitude`, `longitude`

**SoQL gotchas:**
- `boroid` is numeric: Queens = `4`, Manhattan = `1`, Brooklyn = `3`, Bronx = `2`, Staten Island = `5`
- `class` values: `'A'` (non-hazardous), `'B'` (hazardous), `'C'` (immediately hazardous)
- `violationstatus` includes `'Open'` and `'Close'`
- `novdescription` contains the violation detail — use `upper(novdescription) LIKE '%MOLD%'` for keyword search

**Common queries:**
```
SELECT class, count(*) as cnt WHERE boroid = '4' AND inspectiondate > '2025-01-01' GROUP BY class ORDER BY cnt DESC
```

---

## Data Commons

| Place | DCID |
|-------|------|
| New York City | `geoId/3651000` |

**Common variables:** `Count_Person`, `Median_Income_Person`, `Count_HousingUnit`, `UnemploymentRate_Person`, `Count_CriminalActivities_CombinedCrime`

Use `search_indicators(query="population", places=["New York City, USA"])` to discover available variables, then `get_observations(variable_dcid="Count_Person", place_dcid="geoId/3651000", date="latest")` to retrieve data.
