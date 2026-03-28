# NYC Setup Guide

NYC-specific setup for the MCP Demo environment. Complete [SETUP.md](SETUP.md) first — it configures all API keys and MCP servers.

This guide covers NYC Cyvl projects, Socrata datasets, and verification steps.

---

## NYC Cyvl Projects

Four Cyvl projects cover NYC, with a **Queens focus**. These are the primary demo areas.

| Area | Project ID | Borough | Notes |
|------|-----------|---------|-------|
| Jackson Heights | `1924f65d-01b6-4170-b0b8-ddf6a887b6e5` | Queens | Full coverage, best for demos |
| Long Island City (LIC) | `5be713ea-d739-4ecc-876d-ccadbe57c04b` | Queens | Full coverage |
| Jamaica | `e57afa42-1052-4313-a26b-8df6e3154a58` | Queens | Full coverage |
| Manhattan Pilot | `8cb1a9f3-f2ac-4de9-ad00-b8187db3e63f` | Manhattan | **Partial coverage** — avoid for demos |

**NYC School of Data note:** These projects were surveyed in collaboration with NYC School of Data (nycsod). The imagery and infrastructure assessments power community-driven data analysis workshops.

For demos, always start with Jackson Heights, LIC, or Jamaica. Manhattan Pilot has gaps in coverage and may return sparse results for some queries.

---

## Socrata Datasets (NYC Open Data)

The Socrata MCP connects to `data.cityofnewyork.us` by default. Key datasets for the NYC demo:

| Dataset | ID | Use |
|---------|----|-----|
| 311 Service Requests | `erm2-nwe9` | Complaints, noise, street conditions |
| Restaurant Inspections | `43nn-pn8j` | DOHMH inspection grades and violations |
| Housing Violations | `wvxf-dwi5` | HPD housing maintenance violations |

## Data Commons (Demographics)

NYC DCID: `geoId/3651000`

Use for population, income, housing, and employment data. See `reference/datacommons-reference.md` for the full variable list.

---

## Verify Setup

Complete the base setup in [SETUP.md](SETUP.md) first, then verify NYC-specific access below.

### Option A: Claude Desktop (Cowork)

1. Open Claude Desktop
2. Start a **Cowork** session scoped to the **mcp-demo** repo
3. Verify you see `CLAUDE.md` referenced in the session context
4. Connect Cyvl via the MCP connectors panel (one-time OAuth)

### Option B: Claude Code

```bash
cd mcp-demo
claude
```

Then inside Claude Code:

```
/mcp
```

Verify all four servers appear: `cyvl`, `socrata`, `data-commons`, `boston`.

---

## Test Prompts

Run these after setup to confirm everything works.

### Test 1: Cyvl — Queens Imagery

> Search for fire hydrants in Jackson Heights, Queens. Show me 3 images.

**Expected:** Cyvl returns street-level photos from the Jackson Heights project (`1924f65d-...`) with GPS coordinates in Queens and confidence scores above 70%. If this works, your Cyvl OAuth and project access are confirmed.

### Test 2: Socrata — NYC 311

> What are the top 5 complaint types in Queens this month?

**Expected:** Socrata queries `erm2-nwe9` with a borough filter for QUEENS and date filter for the current month. Returns a ranked list of complaint types (typically: Noise, Heat/Hot Water, Illegal Parking, Blocked Driveway, Street Condition).

### Test 3: Socrata — Restaurant Inspections

> Show me restaurants with grade C in Jackson Heights

**Expected:** Queries `43nn-pn8j` filtering by zipcode or neighborhood for Jackson Heights. Returns restaurant names, addresses, violation descriptions, and grades.

### Test 4: Data Commons — Demographics

> What is the median household income in New York City?

**Expected:** Returns ~$75,000-$80,000 (latest ACS estimate) with Census Bureau source citation. Uses DCID `geoId/3651000`.

### Test 5: Cross-Source

> Compare sidewalk complaints in Queens (311) with sidewalk conditions visible in Cyvl imagery for Jackson Heights

**Expected:** Pulls 311 complaints filtered to Queens sidewalk-related categories, then searches Cyvl imagery for cracked sidewalks in Jackson Heights. Presents both datasets and notes coverage gaps.

---

## Troubleshooting

| Problem | Fix |
|---------|-----|
| Cyvl returns no results for Queens | Verify project access with `list_projects(has_embeddings=true)` — you should see all 4 NYC projects |
| Socrata returns Manhattan data | Add `WHERE upper(borough) = 'QUEENS'` to SoQL queries |
| Manhattan Pilot returns sparse data | Expected — partial coverage. Switch to Jackson Heights, LIC, or Jamaica |
| 311 queries timeout | Add date filters: `WHERE created_date > '2026-01-01'` |

---

## Next Steps

- **Demo walkthrough:** See [EXAMPLES-NYC.md](EXAMPLES-NYC.md) for the full NYC demo script
- **Dataset reference:** See `reference/nyc-datasets.md` for dataset schemas and SoQL patterns
- **Spatial reference:** See `reference/nyc-spatial.md` for borough coordinates and neighborhood lookups
- **Prompt library:** See `prompts/nyc-open-data.md` for copy-paste demo prompts
