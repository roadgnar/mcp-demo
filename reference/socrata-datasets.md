# Socrata MCP — NYC Open Data + Multi-City Reference

Server name: `socrata` | 3 tools | Default domain: `data.cityofnewyork.us`

## Tools

| Tool | Purpose | Key Parameters |
|------|---------|----------------|
| `search` | Find datasets by keyword | `query`, `domain` (optional) |
| `fetch` | Get dataset metadata or sample records | `dataset_id`, `domain` (optional) |
| `get_data` | Run SoQL queries against a dataset | `dataset_id`, `query` (SoQL string), `domain` (optional) |

## Supported Domains

| Domain | Support Level | Notes |
|--------|--------------|-------|
| `data.cityofnewyork.us` | Full | Default. All 3 tools work. |
| `data.cityofchicago.org` | Full | All 3 tools work. |
| `data.seattle.gov` | Full | All 3 tools work. |
| `data.sfgov.org` | Limited search | `search` may return NYC datasets instead of SF. Use `get_data` with known IDs. |
| `data.lacity.org` | Query-only | Only `get_data` works. `search` and `fetch` fail. |

## Key NYC Datasets

| Dataset | ID | Key Columns | Volume |
|---------|----|-------------|--------|
| 311 Service Requests | `erm2-nwe9` | `complaint_type`, `borough`, `created_date`, `closed_date` | ~10k records/day |
| Restaurant Inspections | `43nn-pn8j` | `boro`, `grade`, `inspection_date`, `cuisine_description` | — |
| Housing Violations | `wvxf-dwi5` | `boro`, `violationid`, `inspectiondate` | ~500-1k/day |

## SoQL Query Patterns

**CRITICAL: Always run `SELECT * LIMIT 1` first on unfamiliar datasets to discover column names.**

**Basic query:**
```
SELECT complaint_type, borough, created_date WHERE borough = 'MANHATTAN' ORDER BY created_date DESC LIMIT 100
```

**Case-sensitive matching (NO ILIKE in SoQL):**
```
SELECT * WHERE upper(complaint_type) LIKE '%NOISE%'
```

**Date filtering:**
```
SELECT * WHERE created_date >= '2026-01-01T00:00:00'
```

**Aggregation:**
```
SELECT complaint_type, COUNT(*) AS cnt GROUP BY complaint_type ORDER BY cnt DESC LIMIT 20
```

**Time series (monthly):**
```
SELECT DATE_TRUNC_MONTH(created_date) AS month, COUNT(*) AS cnt GROUP BY month ORDER BY month
```

**Time series (yearly):**
```
SELECT DATE_TRUNC_Y(created_date) AS year, COUNT(*) AS cnt GROUP BY year ORDER BY year
```

**Spatial filter:**
```
SELECT * WHERE within_circle(location, 40.7831, -73.9712, 500)
```

## Date Range Guidelines

- **Single-city analysis (NYC 311):** Default to last 30 days
- **Multi-city comparison:** Default to last 7 days (keeps volume manageable)
- Always add date filters on high-volume datasets to avoid timeouts

## Error Codes

| Code | Meaning | Fix |
|------|---------|-----|
| 400 | SoQL syntax error | Check column names, quoting, function spelling |
| 403 | Auth/token issue | Verify API key in environment |
| 404 | Invalid dataset ID | Double-check the 4x4 identifier |
| 429 | Rate limited | Wait and retry; reduce query frequency |

## Gotchas

- **SoQL is case-sensitive.** Use `upper(column) LIKE '%VALUE%'` — there is no `ILIKE`.
- **SF search returns NYC data.** When searching `data.sfgov.org`, results may come from NYC. Verify the domain in results.
- **LA is query-only.** Only `get_data` works on `data.lacity.org`. You must already know the dataset ID.
- **Column names vary across cities.** NYC 311 uses `complaint_type`; Chicago uses different names. Always `SELECT * LIMIT 1` first.
