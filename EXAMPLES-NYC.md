# NYC Examples

**Explore Queens neighborhoods and NYC civic data with AI.**

Complete [SETUP.md](SETUP.md) first for API keys and prerequisites. Then run through these examples to verify everything works.

---

## Before You Start

### NYC Cyvl Projects

| Area | Project ID | Notes |
|------|-----------|-------|
| Jackson Heights, Queens | `1924f65d-01b6-4170-b0b8-ddf6a887b6e5` | Primary demo area |
| Long Island City, Queens | `5be713ea-d739-4ecc-876d-ccadbe57c04b` | Primary demo area |
| Jamaica, Queens | `e57afa42-1052-4313-a26b-8df6e3154a58` | Primary demo area |
| Manhattan Pilot | `8cb1a9f3-f2ac-4de9-ad00-b8187db3e63f` | Partial coverage — bonus only |

**For demos, use the Queens projects.** Manhattan Pilot has gaps.

### NYC Open Data (Socrata)

| Dataset | ID |
|---------|----|
| 311 Service Requests | `erm2-nwe9` |
| Restaurant Inspections | `43nn-pn8j` |
| Housing Violations | `wvxf-dwi5` |

Data Commons NYC DCID: `geoId/3651000`

### Open the Project

```bash
cd mcp-demo
claude
/mcp   # Connect Cyvl via OAuth (one-time)
```

### Recommended: Run Through These Examples

The examples below verify each MCP connection and show what's possible. If any example fails, check [Troubleshooting](#troubleshooting) at the bottom.

*NYC School of Data note: These projects were surveyed in collaboration with nycsod. This branch was prepared for the NYC School of Data unconference (BetaNYC, March 2026).*

---

## Part 1: See Queens Through AI Vision

Cyvl has indexed street-level imagery across three Queens neighborhoods -- Jackson Heights, Long Island City, and Jamaica. Search by natural language for anything visible in the photos.

> Search for fire hydrants in Jackson Heights, Queens. Show me 3 images.

**Expected:** Cyvl queries the Jackson Heights project (`1924f65d-01b6-4170-b0b8-ddf6a887b6e5`). Returns hundreds of results with GPS coordinates, confidence scores, and street-level photos showing hydrants in context. Concrete nouns like "fire hydrant" return the highest confidence.

> Show me cracked sidewalks in Jamaica, Queens

**Expected:** Cyvl searches the Jamaica project (`e57afa42-1052-4313-a26b-8df6e3154a58`) for sidewalk damage. Returns locations with confidence scores and severity indicators. No city agency maintains a sidewalk condition inventory at this scale -- this is the only way to see it.

> Find faded crosswalk markings in Long Island City

**Expected:** Queries the LIC project (`5be713ea-d739-4ecc-876d-ccadbe57c04b`). Returns crosswalk markings with degradation visible in photos. Safety-critical infrastructure that no spreadsheet tracks.

> Search for bus stops with shelters across all Queens projects

**Expected:** Cyvl searches all three Queens projects. Returns bus stop locations with shelter presence/absence. Useful for transit equity analysis -- which neighborhoods have sheltered stops?

> Find construction equipment near roadways in Jackson Heights

**Expected:** Active construction visible in street-level photos, independent of any permit database. Compare what imagery shows to what the city officially knows about.

> Show me trees with visible root damage pushing up sidewalks in Jamaica

**Expected:** Tree root heave causing sidewalk damage -- a common Queens infrastructure issue. Cyvl finds examples that would take weeks to inventory by walking.

Cyvl sees things no city dataset contains. Three Queens neighborhoods, searchable by natural language.

---

## Part 2: Explore NYC Open Data

Use Socrata to query NYC's open data portal -- 311 complaints, restaurant inspections, housing violations, and more.

> What are the top 10 complaint types in Queens from NYC 311 this month?

**Expected:** Socrata queries `erm2-nwe9` with `WHERE upper(borough) = 'QUEENS' AND created_date > '2026-03-01'`. Returns ranked complaint types -- typically Noise, Heat/Hot Water, Illegal Parking, Blocked Driveway, Street Condition. Volumes depend on the time of year.

> Show me restaurant inspection results for Jackson Heights. Any grade C or worse?

**Expected:** Queries `43nn-pn8j` filtering by Jackson Heights zip codes (11372, 11373). Returns restaurant names, inspection dates, grades, and violation descriptions. Grade C means significant violations found.

> What are the most common housing violations in Queens this year?

**Expected:** Queries `wvxf-dwi5` with borough and date filters. Returns violation types ranked by frequency -- typically paint/plaster, plumbing, vermin, heat. HPD violation data is detailed: apartment-level, with inspection dates and compliance status.

> How many 311 street condition complaints has Queens had this year vs Manhattan?

**Expected:** Aggregates `erm2-nwe9` by borough for street-condition-related complaint types. Queens typically has higher volumes than Manhattan for street conditions, potholes, and blocked driveways.

> Find noise complaints near Jackson Heights in the last 7 days

**Expected:** Spatial query on `erm2-nwe9` using `within_circle(location, 40.7557, -73.8831, 1000)` with recent date filter. Returns noise complaint locations near the Jackson Heights Cyvl coverage area.

Open data portals have thousands of datasets. AI helps you find the right one and query it without knowing dataset IDs, column names, or SoQL.

---

## Part 3: Cross-Source Analysis

Connect what Cyvl sees to what open data shows. Cross-MCP analysis that no single source can provide.

> Do sidewalk 311 complaints in Queens match what Cyvl imagery shows in Jackson Heights?

**Expected:** Pulls 311 sidewalk complaints from `erm2-nwe9` for the Jackson Heights area, then searches Cyvl imagery for cracked sidewalks. The gap analysis reveals where damage exists that residents haven't reported -- and vice versa.

> Compare restaurant inspection grades in Jackson Heights with housing violation density

**Expected:** Queries both `43nn-pn8j` (restaurants) and `wvxf-dwi5` (housing) for the Jackson Heights area. High housing violation density alongside restaurant concentration reveals neighborhood infrastructure pressure.

> What does the infrastructure look like on streets with the most 311 complaints in Jamaica?

**Expected:** Identifies top-complaint streets from 311 data, then pulls Cyvl imagery for those streets in the Jamaica project. Visual evidence of the conditions residents are complaining about.

> Show me Queens population and median income, then overlay where the most housing violations are

**Expected:** Data Commons returns population (~2.3M) and median income for Queens from Census data (DCID `geoId/3651000` for NYC-level, or borough-level if available). Socrata returns housing violation concentrations by zip code. Demographics + operational data = equity lens.

> Compare pavement conditions in Jackson Heights vs LIC using Cyvl, and correlate with 311 pothole complaints for each area

**Expected:** Cyvl pavement scores from both projects, side by side. 311 pothole complaints for each area from Socrata. The correlation (or gap) between citizen reports and AI-measured conditions tells the real story.

Two, three, four data sources -- one analysis. This is what cross-MCP intelligence looks like.

---

## Part 4: Community Board 3 Queens -- Make the Case

Community Board 3 (CB3) covers Jackson Heights, East Elmhurst, and North Corona. Use everything above to build a real briefing.

> Create a brief on sidewalk conditions in CB3 Queens for the district manager

**Expected:** The AI gathers:
- Cyvl sidewalk imagery from Jackson Heights (cracked sidewalks, tree root heave, curb damage)
- 311 sidewalk complaints for the CB3 area from Socrata
- Housing violation density from HPD data
- Population and demographics from Data Commons

Produces an HTML report with findings, embedded street photos, data tables, and prioritized recommendations. Sources cited throughout.

> What are the top infrastructure concerns in the Jackson Heights area? Use all available data sources.

**Expected:** Combines Cyvl imagery search (pavement, sidewalks, markings, signs), 311 complaint analysis (top categories, trends), housing violations (HPD data), and demographic context. Synthesizes into a prioritized list of concerns with supporting evidence from each source.

> Build a 311 trend analysis for CB3 Queens -- what's getting better, what's getting worse?

**Expected:** Time-series analysis of 311 complaint categories for the CB3 area over the past 12 months. Monthly trends by category, with year-over-year comparison where data exists. Identifies categories with increasing complaint volumes (getting worse) vs decreasing (getting better).

> Generate a community infrastructure scorecard for Jackson Heights

**Expected:** A structured assessment combining:
- Pavement condition scores (Cyvl)
- Sidewalk condition assessment (Cyvl imagery)
- 311 complaint volume and response trends (Socrata)
- Housing maintenance compliance (HPD violations)
- Demographic context (Data Commons)

Formatted as a shareable scorecard with grades or ratings per category.

From question to stakeholder-ready deliverable in minutes -- with photos, data, and citations.

---

## What You Just Did

- **Searched** street-level imagery across three Queens neighborhoods with natural language (Cyvl)
- **Explored** NYC open data -- 311, restaurants, housing -- without writing code (Socrata)
- **Connected** visual evidence to operational data across MCP servers
- **Built** a community board briefing with photos, trends, and demographic context

This is infrastructure intelligence for Queens: AI vision + NYC open data + demographics, unified through natural language.

---

## Quick Reference

| What | How |
|------|-----|
| Queens Cyvl projects | Jackson Heights, LIC, Jamaica (see `reference/nyc-coverage.md`) |
| NYC datasets | 311 (`erm2-nwe9`), restaurants (`43nn-pn8j`), housing (`wvxf-dwi5`) |
| Demographics | Data Commons DCID: `geoId/3651000` |
| SoQL patterns | See `reference/nyc-datasets.md` |
| Spatial filters | See `reference/nyc-spatial.md` |
| All prompts | See `prompts/nyc-open-data.md` |

## Troubleshooting

| Problem | Fix |
|---------|-----|
| Cyvl returns no results for Queens | Verify project access with `list_projects(has_embeddings=true)` — you should see all 4 NYC projects |
| Socrata returns wrong borough | Add `WHERE upper(borough) = 'QUEENS'` to SoQL queries |
| Manhattan Pilot returns sparse data | Expected — partial coverage. Switch to Jackson Heights, LIC, or Jamaica |
| 311 queries timeout | Add date filters: `WHERE created_date > '2026-01-01'` (10k records/day) |
| Restaurant grades all NULL | Filter with `WHERE grade IS NOT NULL` — many records are pending inspection |
| SoQL case errors | SoQL is case-sensitive — use `upper(column) LIKE '%VALUE%'`, not ILIKE |
