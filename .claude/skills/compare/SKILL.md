---
name: compare
description: Find connections between civic problems — do crashes happen where pavement is worst? Do complaints match what imagery shows? Compare data across cities.
allowed-tools: mcp__claude_ai_Cyvl__*, mcp__boston__*, mcp__socrata__*, mcp__data-commons__*, mcp__claude_ai_Boston_CIO_MCP__*
argument-hint: [what to compare, e.g. "crashes vs pavement quality", "NYC vs Boston 311 complaints", "pothole complaints vs actual road damage"]
---

# Compare — Cross-Source and Cross-City Analysis

Find connections between different civic datasets or compare the same metric across cities.

## Two Supported Patterns

### Pattern A: Same City, Two Data Types
Examples: crashes + pavement quality, 311 complaints + street imagery, housing violations + demographics

**Workflow:**
1. Identify the two data sources needed
2. Query each source independently
3. Join results by coordinates (within ~200m) or by neighborhood/area name
4. Present side-by-side with a "what this means" summary

### Pattern B: Same Topic, Two Cities
Examples: NYC vs Boston 311 volume, population trends, restaurant inspection rates

**Workflow:**
1. Query each city's MCP for the same metric
2. Use Data Commons `get_observations` for population to normalize per-capita
3. Present a comparison table with raw numbers AND per-capita rates
4. Note differences in how each city collects/categorizes the data

## Supported Comparisons (not exhaustive)

- Crashes and bad pavement: Cyvl pavement scores + Boston crash data
- 311 complaints and actual conditions: Socrata/Boston 311 + Cyvl imagery
- NYC vs Boston on any metric: Socrata + Boston open data + Data Commons
- Housing violations and demographics: Socrata housing data + Data Commons income/population
- Complaints over time vs construction activity: 311 data + work zone permits

## Presenting Results

Always include these three sections:

1. **Side-by-side data** — table or paired bullet points showing both sources
2. **The connection** — one paragraph on what the correlation suggests in plain language
3. **Caveats** — correlation is not causation, note any data gaps (date ranges differ, categories don't map perfectly, coverage area mismatch)

## Rules

- Always normalize cross-city comparisons by population (use Data Commons `Count_Person`)
- Discover columns before querying — never assume column names
- When joining by location, state the matching radius used
- Cite every number's source: which MCP and which dataset
- If one data source is empty or unavailable, present what you have and note the gap
