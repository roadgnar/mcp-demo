# Infrastructure Intelligence -- Hands-On Demo

**Use AI to see, explore, and analyze civic infrastructure data.**

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

For city-specific datasets, neighborhoods, and resource IDs, check the city branches:
- `git checkout boston` -- Boston walkthrough with CKAN datasets
- `git checkout nyc` -- NYC walkthrough with Socrata datasets

---

## Part 1: See Your City

Cyvl has indexed over 237,000 street-level images, all searchable by natural language. No model was trained for these queries -- it works for anything visible in the photos. This is the opening act.

> Search for fire hydrants

**Expected:** Thousands of results across the full image set. The AI returns metadata first (count, locations, confidence scores), then downloads sample photos on request. A concrete noun like "fire hydrant" returns the highest confidence.

> Show me cracked sidewalks near intersections

**Expected:** The AI finds sidewalk damage with confidence scores and GPS coordinates. No city maintains a sidewalk condition database -- this is the only way to inventory damage at scale.

> Find faded crosswalk markings

**Expected:** Crosswalk markings with fading severity assessment. Safety-critical marking degradation that no spreadsheet tracks, quantified across hundreds of miles.

> Search for bus stops with benches

**Expected:** Precise object detection across street photos -- benches, shelters, signage. The search generalizes to any visible feature without retraining.

> Find construction equipment near roadways

**Expected:** Active construction activity visible in photos, independent of any permit database. Compare what imagery shows to what the city officially tracks.

Cyvl sees things that no city dataset contains. This is infrastructure intelligence from AI vision -- not from a spreadsheet.

---

## Part 2: Explore the Data

Use `/explore` to discover what open data exists -- no portal browsing, no dataset IDs, just plain English.

> What data does this city have about 311 complaints?

**Expected:** The AI searches the relevant open data portal (Socrata, CKAN, or both) and returns matching datasets with descriptions, record counts, and column names. You see what exists without visiting a single website.

> Show me population trends for the 5 largest US cities

**Expected:** Data Commons returns population time series from the Census Bureau for NYC, LA, Chicago, Houston, and Phoenix. Sourced data with citations -- not estimates.

> What restaurant inspection data is available?

**Expected:** The AI finds inspection datasets on the relevant Socrata portal, shows grade distributions (A/B/C), and surfaces recent failures. Works for any city with a Socrata-powered data portal.

> What kinds of housing or building violations are tracked?

**Expected:** The AI discovers violation datasets, breaks down violation types by frequency, and shows the most common categories. The specifics depend on the city, but the discovery pattern is the same everywhere.

Open data portals have thousands of datasets. AI helps you find the right one without knowing the dataset ID, the column names, or the query language.

---

## Part 3: Find the Patterns

Use `/compare` to connect what Cyvl sees to what open data shows -- cross-MCP analysis that no single source can provide.

> Do crashes happen where pavement is worst?

**Expected:** The AI pulls crash records from open data, pavement condition scores from Cyvl, and cross-references by location. Streets with the worst pavement scores correlate with higher crash frequency. Two independent data sources, one finding.

> Compare 311 complaint patterns between two cities

**Expected:** The AI queries both cities' 311 data, normalizes complaint volumes by population using Data Commons, and presents a per-capita comparison. Apples-to-apples across different-sized cities.

> Do sidewalk complaints match what imagery shows?

**Expected:** 311 sidewalk repair requests versus Cyvl sidewalk damage imagery -- a gap analysis. Citizens report damage one at a time; imagery search provides the city-wide view. The gaps reveal where residents have stopped reporting.

> Compare median household income across the 5 largest US cities

**Expected:** Data Commons returns Census-sourced income data for each city, presented side by side with source citations. Demographic context for any infrastructure analysis.

AI imagery + open data + demographics = connections no single source reveals.

---

## Part 4: Make the Case

Use `/report` to turn analysis into a deliverable you can hand to a decision-maker.

> Create a brief on road conditions for the public works director

**Expected:** The AI gathers pavement scores, crash data, 311 complaints, and street-level photos, then generates an HTML report with findings, data tables, embedded images, and prioritized recommendations. Sources cited throughout.

> Build a report comparing infrastructure complaints across two cities

**Expected:** A formatted document combining operational data (311, violations) with demographic context (income, population) -- the kind of analysis that normally takes a research team days.

From question to shareable deliverable in minutes -- with photos, data, and citations.

---

## What You Just Did

- **Searched** 237K street photos with natural language (Cyvl)
- **Discovered** datasets across multiple portals without writing code (Socrata, CKAN)
- **Connected** visual evidence to operational data across MCP servers
- **Generated** a stakeholder-ready report with photos and citations

This is infrastructure intelligence: AI vision + open data + demographic context, unified through natural language.

---

## City-Specific Demos

For walkthroughs with neighborhood-level prompts, specific dataset IDs, and local context:

- **Boston:** `git checkout boston` -- see FOLLOW-ALONG-BOSTON.md
- **NYC:** `git checkout nyc` -- see FOLLOW-ALONG-NYC.md

---

## Quick Reference

| What | How |
|------|-----|
| Discover Cyvl cities | `list_projects(has_embeddings=true)` |
| Find datasets | `/explore` -- searches portals by keyword |
| View street imagery | `/see` -- searches and downloads photos |
| Cross-reference sources | `/compare` -- joins data across MCPs |
| Generate deliverables | `/report` -- produces HTML/PDF with citations |
| Imagery coverage | See `reference/cyvl-coverage.md` |
| Dataset directory | See `civic-ai-tools/docs/datasets.md` |
