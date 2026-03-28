# Infrastructure Intelligence -- Boston Demo

**Neighborhood-level prompts for Boston's streets, sidewalks, and open data.**

> This walkthrough uses Boston-specific datasets, neighborhoods, and resource IDs. For the general demo, see `EXAMPLES.md`.

---

## Setup

**Desktop:** Open Claude Desktop, start a Cowork session scoped to the `mcp-demo` repo.

**Terminal:**

```bash
cd mcp-demo
claude
```

The **Boston Open Data** (CKAN) and **Data Commons** MCP servers connect automatically -- no keys needed.

The **Cyvl** MCP requires a one-time OAuth login. Run `/mcp` inside Claude Code, click Cyvl, and follow the prompt. Future sessions remember your auth.

**Cyvl project:** Boston full city (`8d8f8cd6-f25a-470c-88fd-6b0e0ad4d1d7`) covers 237K+ street-level images across all 17 neighborhoods.

---

## Part 1: See Boston's Streets

Cyvl has indexed every street in Boston. Search by natural language -- no model was trained for these queries.

> Search for fire hydrants in Boston

**Expected:** Thousands of results across the full 237K image set. The AI returns metadata first (count, locations, confidence scores), then downloads sample photos on request.

> Show me cracked sidewalks in Dorchester

**Expected:** Sidewalk damage concentrated in Dorchester's residential streets. GPS coordinates let you map every crack -- no city maintains this inventory any other way.

> Find faded crosswalk markings in Roxbury

**Expected:** Crosswalk markings near Blue Hill Ave and Warren Street with fading severity. Safety-critical marking degradation that no spreadsheet tracks.

> Search for pavement conditions near Blue Hill Ave

**Expected:** Pavement distress visible in street-level imagery along one of Boston's most-driven corridors. Use `list_pavement_scores` with a radius filter for numeric condition data.

> Find construction equipment near roadways in the South End

**Expected:** Active construction activity visible in photos, independent of any permit database. Compare what imagery shows to what the city officially tracks in work zone data.

Cyvl sees things no city dataset contains. This is infrastructure intelligence from AI vision.

---

## Part 2: Explore Boston's Data

Boston's open data lives on data.boston.gov (CKAN). Use the Boston MCP to query it directly.

> How many crashes happened on Blue Hill Ave in the last 3 years?

**Expected:** The AI queries Vision Zero crash data (`e4bfe397`), filtering by `street = 'BLUE HILL AVE'`. Returns crash counts by year and mode (pedestrian, bike, motor vehicle). Street names are UPPERCASE in this dataset.

> Show me 311 pothole complaints in Dorchester

**Expected:** The AI queries legacy 311 data (`1a0b420d`), filtering on `case_title ILIKE '%pothole%'` and `neighborhood = 'Dorchester'`. Pothole data is only in the legacy 311 dataset -- the new system does not carry these categories.

> What active work zones are there in Boston right now?

**Expected:** The AI queries active work zones (`36fcf981`). Note: this dataset uses PascalCase columns (`"Street"`, `"Neighborhood"`, `"Status"`) -- the AI must double-quote them in SQL.

> Show me building permits issued near Downtown this year

**Expected:** Building permits (`6ddcd912`) filtered by date. Permits dataset covers 2009 to present.

> What safety concerns have been reported in Roxbury?

**Expected:** Community-reported safety concerns (`42c33f05`) in Roxbury -- citizen observations that complement official crash data.

> What's Boston's population and median income?

**Expected:** Data Commons returns Census data for Boston (DCID: `geoId/2507000`). Population, median income, housing units -- demographic context for any infrastructure analysis.

---

## Part 3: Cross-MCP Analysis

Connect what Cyvl sees to what Boston's open data shows. Two independent sources, one picture.

> Do crashes on Washington Street correlate with pavement conditions?

**Expected:** The AI pulls crash records from Vision Zero (filtering `street = 'WASHINGTON ST'`), then queries Cyvl for pavement scores along Washington Street using `list_pavement_scores` with a radius filter. Poor pavement segments align with crash clusters.

> Compare sidewalk damage imagery to 311 complaints in Dorchester

**Expected:** Cyvl imagery search for "cracked sidewalks in Dorchester" versus 311 sidewalk repair requests filtered to Dorchester. The gap between what imagery finds and what residents report reveals where people have stopped calling.

> Are there crashes near active work zones?

**Expected:** Work zone locations from CKAN crossed with crash data filtered by coordinates. Construction areas with crash clusters are candidates for safety interventions.

> How does Blue Hill Ave crash frequency compare to the rest of the city?

**Expected:** Per-street crash counts from Vision Zero, with Blue Hill Ave highlighted. Add pavement scores from Cyvl to see if road conditions contribute to the pattern.

AI imagery + open data + demographics = connections no single source reveals.

---

## Part 4: Make the Case

Turn analysis into a deliverable for decision-makers.

> Create a Washington Street infrastructure assessment for the city council

**Expected:** The AI gathers pavement scores from Cyvl, crash data from Vision Zero, 311 complaints, active work zones, and street-level photos along Washington Street. Generates an HTML report with:
- Pavement condition summary with worst segments highlighted
- Crash data by year and mode (pedestrian, bike, motor vehicle)
- 311 complaint trends (potholes, sidewalks, street lights)
- Embedded street-level photos of damage
- Prioritized recommendations with cost context

From question to shareable deliverable in minutes -- with photos, data, and citations.

> Build a Dorchester sidewalk conditions brief

**Expected:** Sidewalk damage from imagery, 311 sidewalk complaints, and demographic context from Data Commons -- combined into a neighborhood-level assessment.

> Compare crash corridors: Blue Hill Ave vs Washington St vs Mass Ave

**Expected:** Side-by-side crash counts, pavement conditions, and 311 complaint volumes for Boston's three most-analyzed corridors.

---

## What You Just Did

- **Searched** 237K Boston street photos by neighborhood and condition (Cyvl)
- **Queried** Vision Zero crashes, 311 complaints, work zones, and permits (Boston CKAN)
- **Connected** visual evidence to operational data across MCP servers
- **Generated** a council-ready report with photos, data tables, and citations

This is infrastructure intelligence: AI vision + open data + demographic context, unified through natural language.

---

## Quick Reference

| Resource | ID |
|----------|----|
| Cyvl -- Boston (full city) | `8d8f8cd6-f25a-470c-88fd-6b0e0ad4d1d7` |
| Cyvl -- Somerville | `090e18f2-0002-4a70-90b4-8f073d26294d` |
| Vision Zero Crashes | `e4bfe397-6bfc-49c5-9367-c879fac7401d` |
| Vision Zero Fatalities | `92f18923-d4ec-4c17-9405-4e0da63e1d6c` |
| Active Work Zones | `36fcf981-e414-4891-93ea-f5905cec46fc` |
| Building Permits | `6ddcd912-32a0-43df-9908-63574f8c7e77` |
| 311 Requests (Legacy, 2026) | `1a0b420d-99f1-4887-9851-990b2a5a6e17` |
| 311 Requests (New System) | `254adca6-64ab-4c5c-9fc0-a6da622be185` |
| Safety Concerns | `42c33f05-2572-404e-9782-38d755f0f069` |
| Data Commons -- Boston | `geoId/2507000` |
