# Boston Infrastructure Intelligence -- Hands-On Demo

**Explore Boston's streets, data, and infrastructure with AI.**

> Copy-paste the prompts below into Claude and see the results live. Each part builds on the last, but you can jump to any section.

---

## Setup

**Desktop:** Open Claude Desktop, start a Cowork session scoped to the `mcp-demo` repo.

**Terminal:**

```bash
cd mcp-demo
claude
```

All four MCPs (Cyvl, Boston CKAN, Socrata, Data Commons) connect automatically. Run `/mcp` to verify. Cyvl requires a one-time OAuth login.

For base setup instructions, see [SETUP.md](SETUP.md). For Boston-specific setup details, see [SETUP-BOSTON.md](SETUP-BOSTON.md).

---

## Part 1: See Boston's Streets (Cyvl)

Cyvl has indexed over 237,000 street-level images across Boston, all searchable by natural language. No model was trained for these queries -- it works for anything visible in the photos.

> Search for fire hydrants in Boston and show me 3 images

**Expected:** Thousands of results across the full city. Street-level photos with GPS coordinates and confidence scores. Concrete nouns like "fire hydrant" return the highest confidence.

> Show me cracked sidewalks in Dorchester

**Expected:** Sidewalk damage with confidence scores and GPS coordinates in the Dorchester area. No city maintains a sidewalk condition database -- imagery search is the only way to inventory damage at scale.

> Find faded crosswalk markings near Blue Hill Ave

**Expected:** Crosswalk markings with fading severity along Blue Hill Ave, one of Boston's most heavily used corridors. Safety-critical marking degradation that no spreadsheet tracks.

> Search for potholes on roads in Roxbury

**Expected:** Road surface damage visible in street photos. Compare what imagery shows to what 311 reports -- the gap reveals unreported damage.

> Find construction equipment near roadways in Dorchester

**Expected:** Active construction activity visible in photos, independent of any permit database. Use this alongside the Active Work Zones dataset to compare official records with ground truth.

### Somerville

> Search for cracked sidewalks in Somerville

**Expected:** Uses the Somerville project (`090e18f2`). Demonstrates multi-city coverage -- same search syntax, different project.

---

## Part 2: Explore Boston's Data (CKAN)

Boston's open data portal (data.boston.gov) has hundreds of datasets. The Boston CKAN MCP lets you discover and query them with plain English.

> How many pedestrian crashes has Boston had this year?

**Expected:** A count from the Vision Zero crash dataset, filtered to `mode_type = 'ped'` and the current year. Source: Boston CKAN (`e4bfe397`).

> What are the most common 311 complaint types in Dorchester?

**Expected:** A ranked list of complaint types from the 311 dataset, filtered to `neighborhood = 'Dorchester'`. Potholes and street cleaning typically rank high.

> Show me active construction work zones in Boston

**Expected:** Current work zones from the Active Work Zones dataset (`36fcf981`). Note: columns are PascalCase -- the AI handles this automatically via `get_schema`.

> How many building permits were issued in Roxbury this year?

**Expected:** A count from the Building Permits dataset (`6ddcd912`), filtered by neighborhood and year. Boston has issued permits since 2009.

> What safety concerns have been reported near schools?

**Expected:** Community-reported hazards from the Safety Concerns dataset (`42c33f05`). Location data allows spatial filtering near school addresses.

> Are there any fatal crashes recorded this year?

**Expected:** Results from the Vision Zero Fatalities dataset (`92f18923`), a separate dataset from the general crash records.

### Dataset Discovery

> What datasets does Boston have about transportation?

**Expected:** The AI searches data.boston.gov and returns matching datasets with descriptions and record counts. You discover what exists without visiting a portal.

---

## Part 3: Connect the Dots (Cross-MCP)

This is where it gets powerful -- combining what Cyvl sees with what the data shows.

> Do crashes happen where pavement is worst on Blue Hill Ave?

**Expected:** The AI pulls crash records from Boston CKAN (filtering by street name `'BLUE HILL AVE'`), then retrieves pavement condition scores from Cyvl for the same corridor. Streets with worse pavement correlate with higher crash frequency. Two independent data sources, one finding.

> Compare 311 sidewalk complaints in Dorchester with what Cyvl imagery shows

**Expected:** 311 sidewalk repair requests from the legacy dataset (`1a0b420d`) versus Cyvl sidewalk damage imagery for Dorchester. The gap analysis reveals where residents have stopped reporting -- or where damage exists that nobody has complained about yet.

> What's the median household income in Boston, and how does infrastructure quality vary by neighborhood?

**Expected:** Data Commons returns Census-sourced income for Boston (`geoId/2507000`). Cyvl provides pavement scores by neighborhood. The AI synthesizes: do lower-income neighborhoods have worse infrastructure?

> Show me crash hotspots near active work zones

**Expected:** Vision Zero crash data overlaid with Active Work Zones locations. Are construction areas creating safety hazards? This cross-references two CKAN datasets spatially.

> How does Boston's population compare to Somerville, and do both cities have Cyvl coverage?

**Expected:** Data Commons returns population for both cities. Cyvl confirms coverage for both projects (`8d8f8cd6` for Boston, `090e18f2` for Somerville). Context for any cross-city comparison.

---

## Part 4: Make the Case (Reports)

Turn analysis into a deliverable you can hand to a decision-maker.

> Create a brief on road conditions along Blue Hill Ave for the public works director

**Expected:** The AI gathers pavement scores, crash data, 311 complaints, and street-level photos for Blue Hill Ave, then generates an HTML report with findings, data tables, embedded images, and prioritized recommendations. Sources cited throughout.

> Build an infrastructure equity report for Dorchester and Roxbury

**Expected:** A formatted document combining pavement conditions (Cyvl), crash data (CKAN), 311 complaints (CKAN), and demographic context -- income, population (Data Commons). The kind of analysis that normally takes a research team days.

> Generate a sidewalk damage assessment for the Dorchester neighborhood

**Expected:** Cyvl imagery search for sidewalk damage, 311 sidewalk complaints from CKAN, and a synthesized report with photo evidence, location maps, and repair prioritization.

> Create a safety report for the Blue Hill Ave / Warren St corridor

**Expected:** A corridor-specific report combining crash history, pavement conditions, crosswalk marking quality, active work zones, and 311 complaints. Multi-source evidence for a single decision point.

---

## What You Just Did

- **Searched** 237K+ street photos across Boston and Somerville with natural language (Cyvl)
- **Discovered** and queried 7 city datasets without writing code (Boston CKAN)
- **Connected** visual evidence to operational data across MCP servers
- **Added** demographic context from Census data (Data Commons)
- **Generated** stakeholder-ready reports with photos and citations

This is infrastructure intelligence: AI vision + open data + demographic context, unified through natural language.

---

## Quick Reference

| What | How |
|------|-----|
| Boston imagery | `search_imagery(project_id="8d8f8cd6-...")` |
| Somerville imagery | `search_imagery(project_id="090e18f2-...")` |
| Find CKAN datasets | `search_datasets("topic")` |
| Query CKAN data | `execute_sql("SELECT ... FROM \"resource-id\"")` |
| Boston demographics | `get_observations(variable, "geoId/2507000", "latest")` |
| Neighborhood coordinates | See `reference/boston-spatial.md` |
| Dataset schemas | See `reference/boston-datasets.md` |
| Coverage summary | See `reference/boston-coverage.md` |
