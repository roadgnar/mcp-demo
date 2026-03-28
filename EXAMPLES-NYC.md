# NYC Infrastructure Intelligence — Hands-On Demo

**Explore Queens street conditions, NYC open data, and cross-source analysis with AI.**

> Copy-paste the prompts below into Claude and see the results live. Each part builds on the last, but you can jump to any section.

---

## Setup

**Desktop:** Open Claude Desktop, start a Cowork session scoped to the `mcp-demo` repo.

**Terminal:**

```bash
cd mcp-demo
claude
```

The **Socrata** and **Data Commons** MCP servers connect automatically via npx/uvx -- no keys needed.

The **Cyvl** MCP requires a one-time OAuth login. Run `/mcp` inside Claude Code, click Cyvl, and follow the prompt. Future sessions remember your auth.

### Cyvl Projects (NYC)

| Area | Project ID | Notes |
|------|-----------|-------|
| Jackson Heights, Queens | `1924f65d-01b6-4170-b0b8-ddf6a887b6e5` | Primary demo area |
| Long Island City, Queens | `5be713ea-d739-4ecc-876d-ccadbe57c04b` | Primary demo area |
| Jamaica, Queens | `e57afa42-1052-4313-a26b-8df6e3154a58` | Primary demo area |
| Manhattan Pilot (partial) | `8cb1a9f3-f2ac-4de9-ad00-b8187db3e63f` | Bonus -- partial coverage only |

**Focus on Queens.** Jackson Heights, LIC, and Jamaica have full coverage. Manhattan Pilot has limited data -- use it as a bonus comparison, not the primary demo.

---

## Part 1: See Queens Streets

Cyvl has indexed street-level images across Queens neighborhoods, all searchable by natural language. No model was trained for these queries -- it works for anything visible in the photos.

> Search for fire hydrants in Jackson Heights using project 1924f65d-01b6-4170-b0b8-ddf6a887b6e5 — how many can you find? Show me 3 images.

**Expected:** Hydrant results with GPS coordinates and confidence scores across Jackson Heights. Concrete nouns like "fire hydrant" return the highest confidence.

> Show me cracked sidewalks in Jamaica using project e57afa42-1052-4313-a26b-8df6e3154a58

**Expected:** Sidewalk damage with confidence scores and GPS coordinates in the Jamaica neighborhood. No city maintains a sidewalk condition database -- imagery is the only way to inventory damage at scale.

> Get pavement scores for Jackson Heights — use project 1924f65d-01b6-4170-b0b8-ddf6a887b6e5 with a 500m radius around 40.7557, -73.8831

**Expected:** PCI (Pavement Condition Index) scores for road segments in Jackson Heights. Scores range from 0 (failed) to 100 (perfect). Look for clusters of low scores.

> List distresses in Long Island City — use project 5be713ea-d739-4ecc-876d-ccadbe57c04b near 40.7425, -73.9235 within 400m

**Expected:** Specific pavement distress types (cracking, rutting, patching) with severity levels. Each distress maps to a GPS location on a specific road segment.

> Search for faded crosswalk markings in Jamaica using project e57afa42-1052-4313-a26b-8df6e3154a58

**Expected:** Crosswalk markings with fading severity assessment. Safety-critical marking degradation that no spreadsheet tracks.

> Compare imagery in Jackson Heights vs LIC — search for damaged road surfaces in both projects

**Expected:** Side-by-side results from two Queens neighborhoods. Different areas show different infrastructure patterns based on traffic volume, age, and maintenance history.

Cyvl sees things that no city dataset contains. This is infrastructure intelligence from AI vision -- not from a spreadsheet.

---

## Part 2: Explore NYC Open Data

NYC's Socrata portal (`data.cityofnewyork.us`) has thousands of datasets. AI helps you find the right one without knowing the dataset ID, the column names, or the query language.

> What are the top 311 complaint types in Queens this year? Use dataset erm2-nwe9 on data.cityofnewyork.us

**Expected:** Top complaint categories from NYC 311 data, filtered to Queens. Noise, heating, and street conditions typically dominate. The AI handles SoQL query construction automatically.

> Show me the top 10 complaint types in Queens vs Manhattan — which borough complains about what?

**Expected:** Side-by-side comparison of complaint profiles. Manhattan skews toward noise and rodents; Queens shows more building and street complaints. Same dataset, different story by borough.

> What restaurant inspection grades are in Jackson Heights? Use dataset 43nn-pn8j, filter near zipcode 11372

**Expected:** Restaurant inspection results with grade distribution (A/B/C). Jackson Heights has one of the most diverse food scenes in NYC -- the inspection data reflects that density.

> Show me housing violations in Jamaica, Queens — use dataset wvxf-dwi5

**Expected:** Housing violation types and counts. Look for patterns: lead paint, mold, heat/hot water complaints cluster in specific building types and seasons.

> What is the population and median income for New York City? Use Data Commons with DCID geoId/3651000

**Expected:** Census-sourced population and income data with citations. Provides demographic context for any operational data analysis.

Open data portals have thousands of datasets. AI finds the right one without you knowing the dataset ID, the column names, or the query language.

---

## Part 3: Find the Patterns

Connect what Cyvl sees to what open data shows -- cross-MCP analysis that no single source can provide.

> Compare Cyvl imagery results for cracked sidewalks in Jackson Heights (project 1924f65d-01b6-4170-b0b8-ddf6a887b6e5) with 311 sidewalk complaints in Queens (dataset erm2-nwe9). Do complaints match what imagery shows?

**Expected:** 311 sidewalk repair requests versus Cyvl sidewalk damage imagery -- a gap analysis. Citizens report damage one at a time; imagery search provides the neighborhood-wide view. The gaps reveal where residents have stopped reporting.

> Pull pavement distresses from Cyvl for LIC (project 5be713ea-d739-4ecc-876d-ccadbe57c04b) and compare with 311 street condition complaints near LIC. Which streets show up in both?

**Expected:** Pavement distress locations from imagery overlaid with 311 complaint locations. Some streets appear in both sources (confirmed problems); others appear in only one (unreported damage or complaints without visible evidence).

> Compare 311 complaint volumes across all 5 NYC boroughs — normalize by population using Data Commons

**Expected:** Per-capita complaint rates by borough. Raw volumes favor Manhattan and Brooklyn (more people); per-capita rates tell a different story. Data Commons provides Census population; Socrata provides 311 counts.

> What is the median household income in Queens vs Manhattan? How does that relate to 311 complaint rates?

**Expected:** Data Commons returns income data for both boroughs. Combined with 311 volumes, this reveals whether wealthier areas file more complaints (they often do) or if complaint patterns reflect actual infrastructure gaps.

> Compare restaurant inspection failure rates across boroughs using dataset 43nn-pn8j

**Expected:** Grade distribution by borough. Some boroughs have higher failure rates, but that may reflect inspection frequency, restaurant density, or cuisine type rather than food safety.

AI imagery + open data + demographics = connections no single source reveals.

---

## Part 4: Make the Case

Turn analysis into a deliverable for Community Board 3 Queens (Jackson Heights area).

> Create a brief on road and sidewalk conditions in Jackson Heights for CB3 Queens. Use Cyvl project 1924f65d-01b6-4170-b0b8-ddf6a887b6e5 for pavement scores and imagery. Pull 311 complaint data from dataset erm2-nwe9 filtered to the Jackson Heights area. Include street-level photos of damage. Save to results/jackson-heights-cb3/.

**Expected:** An HTML report with pavement condition scores, 311 complaint trends, embedded street-level photos of damage, and prioritized recommendations. Sources cited throughout -- exactly what a community board member needs to advocate for repairs.

> Build a comparison of infrastructure conditions across Jackson Heights, LIC, and Jamaica. Include pavement scores from all three Cyvl projects, 311 data from each area, and population context from Data Commons. Save to results/queens-comparison/.

**Expected:** A formatted document comparing three Queens neighborhoods side by side -- condition scores, complaint volumes, demographics. The kind of analysis that normally takes a research team days.

> Generate a one-page summary of housing violations in Jamaica using dataset wvxf-dwi5. Include the most common violation types and trends. Save to results/jamaica-housing/.

**Expected:** A concise summary of housing violation patterns in Jamaica -- top violation categories, seasonal trends, building types most affected. Quick enough for a meeting handout.

From question to shareable deliverable in minutes -- with photos, data, and citations.

---

## Quick Reference

### Cyvl Project IDs

| Area | Project ID |
|------|-----------|
| Jackson Heights | `1924f65d-01b6-4170-b0b8-ddf6a887b6e5` |
| Long Island City | `5be713ea-d739-4ecc-876d-ccadbe57c04b` |
| Jamaica | `e57afa42-1052-4313-a26b-8df6e3154a58` |
| Manhattan Pilot | `8cb1a9f3-f2ac-4de9-ad00-b8187db3e63f` |

### Socrata Datasets (data.cityofnewyork.us)

| Dataset | ID | Use |
|---------|----|-----|
| 311 Service Requests | `erm2-nwe9` | Complaints by type, borough, location |
| Restaurant Inspections | `43nn-pn8j` | Grades, violations, cuisine type |
| Housing Violations | `wvxf-dwi5` | HPD violations by building, type |

### Data Commons

| Place | DCID |
|-------|------|
| New York City | `geoId/3651000` |

### Queens Coordinates

| Neighborhood | Lat | Lon | Cyvl Project |
|-------------|-----|-----|--------------|
| Jackson Heights | 40.7557 | -73.8831 | `1924f65d-...` |
| Long Island City | 40.7425 | -73.9235 | `5be713ea-...` |
| Jamaica | 40.7029 | -73.7898 | `e57afa42-...` |
