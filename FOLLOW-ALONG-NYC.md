# NYC Open Data + AI — A Hands-On Walkthrough

> **Try it yourself.** Copy-paste these prompts into Claude and see the results live. Each section builds on the last, but you can jump to any part that interests you.

---

## Setup

**Desktop:**

1. Open Claude Desktop
2. Open Cowork and scope to the `mcp-demo` repo
3. Start asking questions — the data connections are automatic

**Terminal:**

```bash
cd mcp-demo
claude
```

The **Socrata** (NYC Open Data) and **Data Commons** (census/demographics) servers connect automatically — no login or API key needed.

> **Note:** Street-level photo search (Cyvl) currently covers Boston only. For NYC, we use 311 records and open data as our evidence layer. You'll see both approaches in this workshop.

---

## Part 1: Discover What Exists (10 min)

Use `/explore` to find datasets and see what's in them — no code, no portals, just plain English.

### 1a. Potholes

> What data does NYC have about potholes?

**Expected:** The AI finds the 311 dataset, shows the top complaint types related to potholes, and which neighborhoods report the most.

### 1b. Restaurant inspections

> What restaurant inspection data is available for New York City?

**Expected:** The AI finds the restaurant inspections dataset, shows the distribution of grades (A/B/C), and lists some recent restaurants that received a C grade.

### 1c. Population comparison

> How does New York City's population compare to Boston, Chicago, and Los Angeles?

**Expected:** The AI pulls population figures from the Census via Data Commons and presents them side by side. NYC dwarfs the others.

### 1d. Housing violations

> What kinds of housing violations does NYC track? Show me the most common types.

**Expected:** The AI finds the housing violations dataset and breaks down violation types by frequency.

---

## Part 2: See the Evidence (15 min)

Use `/see` to look at specific records — the closest thing to being on the ground.

### 2a. Manhattan potholes

> Show me the worst pothole complaints in Manhattan this month

**Expected:** Returns recent 311 records with addresses, dates, and complaint details. You'll see the specific streets and intersections.

### 2b. Boston street photos (comparison)

> Search for cracked sidewalks in Dorchester, Boston

**Expected:** The AI uses Cyvl imagery search (Boston has coverage) and returns actual street-level photos with confidence scores. This is what AI-powered civic data looks like with imagery.

> **The takeaway:** The same question, two cities — one with AI imagery, one without. That's where civic AI is heading.

### 2c. Restaurant inspection failures

> Show me restaurants in Queens that failed their most recent health inspection

**Expected:** Returns specific restaurant names, addresses, violation descriptions, and inspection dates from the NYC inspections dataset.

### 2d. Housing violations in the Bronx

> What are the most recent critical housing violations in the Bronx?

**Expected:** Returns violation records with building addresses, violation types, and dates — the kind of evidence tenants and advocates need.

---

## Part 3: Find the Patterns (15 min)

Use `/compare` to connect datasets and normalize across cities — the AI handles the math.

### 3a. Potholes per capita

> Compare pothole complaints in NYC vs Boston per capita

**Expected:** Pulls NYC 311 data via Socrata, Boston 311 via their open data portal, populations via Data Commons, and calculates complaints per 100K residents.

### 3b. Borough-level housing violations

> Which NYC boroughs have the most housing violations relative to their population?

**Expected:** Combines housing violation counts from NYC Open Data with borough population estimates from Data Commons. The Bronx will likely top the list.

### 3c. Cross-dataset correlation

> Do restaurant inspection failures correlate with 311 complaint volume by neighborhood?

**Expected:** Cross-references the restaurant inspections and 311 datasets, grouping by neighborhood to see if areas with more complaints also have more food safety issues.

### 3d. Multi-city comparison

> Compare median household income across NYC, Chicago, Los Angeles, and Seattle

**Expected:** Pulls income data from Data Commons for all four cities and presents them side by side with source citations.

---

## Part 4: Make the Case (15 min)

Use `/report` to turn findings into something you can hand to a decision-maker.

### 4a. Community board brief

> Create a brief on sidewalk safety in East Harlem for Community Board 11. Include 311 complaint data, housing violations nearby, and demographic context.

**Expected:** The AI gathers 311 complaints, housing violations, and census demographics for the area, then generates an HTML report with findings and recommendations.

### 4b. Borough comparison report

> Build a report comparing housing conditions across NYC boroughs. Include violation rates, complaint volumes, and income data.

**Expected:** A formatted report combining operational data (violations, 311) with demographic context (income, population) — the kind of analysis that normally takes a research team days.

---

## What You Just Did

- **Discovered** datasets without visiting a single data portal
- **Compared** data across cities with automatic population normalization
- **Cross-referenced** multiple datasets to find patterns
- **Generated** a stakeholder-ready report in minutes
- All from plain English questions — no code, no spreadsheets, no SQL

---

## Quick Reference

| Resource | Identifier |
|----------|-----------|
| NYC 311 Complaints | `erm2-nwe9` |
| Restaurant Inspections | `43nn-pn8j` |
| Housing Violations | `wvxf-dwi5` |
| NYC (Data Commons) | `geoId/3651000` |
| Boston (Data Commons) | `geoId/2507000` |

**Skills:** `/explore` (find data), `/see` (view evidence), `/compare` (cross-reference), `/report` (generate deliverables)

---

## Going Further

Try other cities — Chicago, San Francisco, Seattle, and LA are all supported:

> What are the most common 311 complaints in Chicago vs NYC?

> Compare crime rates across the five largest US cities

Add Boston imagery to any analysis:

> Search for faded crosswalk markings in Boston and compare with NYC 311 crosswalk complaints

Build your own tools:

> Build me a tool that pulls NYC restaurant inspection data and lets me browse C-grade restaurants by neighborhood on a map

See `reference/socrata-datasets.md` for query patterns and `civic-ai-tools/docs/datasets.md` for the full 5-city dataset directory.
