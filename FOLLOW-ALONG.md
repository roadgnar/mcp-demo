# Boston Infrastructure Intelligence — Follow Along

> **Try it yourself.** Copy-paste these prompts into Claude Code and see the results live. Each section builds on the last — start from the top or jump to any section that interests you.

If you haven't already, clone the repo first — see the [Quick Start in README.md](README.md#quick-start).

---

## Setup (One-Time)

### Step 1: Open the project

```bash
cd mcp-demo
claude
```

The **Boston Open Data MCP** auto-connects via `.mcp.json` — it's public data, no auth needed.

### Step 2: Authenticate the Cyvl MCP

Inside Claude Code, type:

```
/mcp
```

You'll see a list of MCP servers. The Boston server should show as connected. For Cyvl:

1. Click on **"Cyvl"** in the MCP list
2. Follow the OAuth prompt to authenticate with your Cyvl account
3. Once authenticated, the Cyvl MCP shows as connected

This is a **one-time** step. Future sessions remember your authentication.

### Step 3: Verify

```
/mcp
```

You should see both servers connected:

- **boston** — Boston Open Data (CKAN)
- **Cyvl** — Infrastructure data + imagery search

---

## Part 1: Imagery Search — "Search for Anything"

The Cyvl MCP leverages data from hundreds of thousands street-level images of Boston, all searchable by natural language. No model was trained for these searches — it works for anything visible in the photos.

### 1a. Find Bus Stops

```
Search for "bus stop" imagery in the Boston project. Download three of them to results/bus_stops/.
```

This is the highest-confidence query — concrete, well-defined objects return the most reliable results.

### 1b. Find faded crosswalk markings

```
Search for "faded crosswalk markings" imagery in Boston. Download three of them to results/faded_crosswalk_markings/.
```

Safety-critical marking degradation quantified across the entire city.

### 1c. Find cracked sidewalks

```
Search for "cracked sidewalks and damaged curbs" imagery across Boston.  Download three of them to results/cracked_sidewalks/.
```

Boston has no sidewalk condition data — this is the only way to inventory sidewalk conditions at scale.

### 1d. Find construction sites

```
Search for "construction sites with heavy machinery" imagery in Boston. Download three of them to results/construction_sites/.
```

Construction activity visible in street-level photos — independent of the city's permit database. Try removing "with heavy machinery" to see how qualifiers narrow results.

### 1e. Find Blue Bike stations

```
Search for "blue bike docking stations" imagery in the Boston project and tell me show many you found. Download three of them to results/blue_bike_stations/.
```

These stations aren't in any structured dataset — found purely from imagery.

### 1f. The fun one — find dogs

```
Search for "dogs" in the Boston street imagery. Download three of them to results/dogs/.
```

If we can find dogs, we can find anything. (Note that some dogs are obscured by anonymization, for the dog's privacy.)

---

## Part 2: Cross-MCP Analysis — Filling Data Gaps

The Boston Open Data MCP connects to data.boston.gov — hundreds of city datasets on everything from crashes to building permits. But what happens when the data you need doesn't exist?

### 2a. Show what exists (and what's missing)

```
Search the Boston Open Data portal for any dataset about sidewalks or curb conditions.
```

You'll find geometry data from 2011 — the city knows WHERE sidewalks are but not what CONDITION they're in. This is a real gap in the city's data.

### 2b. Fill the gap with imagery

```
Since Boston has no sidewalk condition data, use Cyvl imagery search to find "cracked sidewalks and damaged curbs" across the city. Then search for "wheelchair accessible ramp with tactile paving." How many of each did you find?
```

The city has no structured data on sidewalk conditions — but Cyvl's imagery search just created an inventory from street-level photos. Two data sources, one answer.

### 2c. Find accessibility obstructions

```
Search for "narrow sidewalk blocked by utility pole" in Boston imagery. Download three of them to results/blocked_sidewalk/.
```

ADA compliance issues that no city database tracks, found instantly from imagery.

### 2d. Cross with 311 complaints

```
Query 311 service requests for sidewalk-related complaints. How many "Sidewalk Repair" requests are there in the 2026 data?
```

Citizens are reporting damage one at a time with no systematic way to prioritize — imagery search provides the city-wide view that individual complaints can't.

---

## Part 3: City Intelligence — Crashes Meet Pavement

Now for the real payoff. The city tracks crash records. Cyvl has pavement condition data. Nobody has ever connected the two. What happens when we ask whether bad roads and crashes are correlated?

### 3a. The most dangerous streets

```
Which streets have the most crashes in Boston? Query Vision Zero crash records grouped by street name.
```

### 3b. Washington St — crashes and pavement

```
Washington Street has the most crashes of any street in Boston. Using the Cyvl MCP, show me the pavement condition and high-severity distresses on Washington Street in Roxbury. Is there a connection between road quality and crashes?
```

This is the question nobody could ask before — it requires joining crash data from Boston Open Data with pavement scores from Cyvl.

### 3c. Blue Hill Ave — the pedestrian story

```
How many pedestrian and bike crashes have occurred on Blue Hill Avenue? Then search Cyvl imagery for "damaged road surface and potholes" near Blue Hill Avenue in Mattapan. Download three of them to results/blue_hill_ave/pedestrian/.
```

### 3d. Visual evidence on Washington St

```
Search Cyvl imagery for "damaged road surface" on Washington Street in Roxbury. Download three of them to results/washington_st/damaged_road_surface/.
```

### 3e. The 311 connection

```
Are there 311 pothole complaints on the same streets that have the most crashes? Query 311 service requests for pothole-related complaints in Dorchester and Roxbury.
```

Three independent data sources — crashes, pavement scores, and citizen complaints — all pointing at the same streets.

### 3f. Build a prioritized repair list

```
Based on everything we've found, build me a prioritized repair list for the top 5 most dangerous streets in Boston. Rank by combined crash count and pavement severity. For each street, include: crash count by type, worst PCI score, dominant distress type, and one street-level photo.
```

This turns the analysis into a decision-support tool — the "so what" moment.

---

## Part 4: Deliverable Generation

The budget office doesn't read dashboards — they read reports with photos. Let's turn the crash-pavement correlation into something you can hand to the mayor.

```
Create a PDF report showing the correlation between crash frequency and pavement condition on Washington Street. Search for street-level imagery of the damage, download the photos, and embed them in the report. Include crash data, pavement scores, and a repair recommendation. Save everything to results/washington_report/.
```

The key: Claude searches imagery, downloads real photos, and embeds them in the PDF — a question becomes a budget-justification artifact in two minutes.

---

## Bonus: Imagery Search Heatmap

See imagery search results rendered geospatially on a map:

1. Go to [cyvl.app](https://cyvl.app/) and log in
2. Navigate to [cyvl.app/heatmap](https://cyvl.app/heatmap)
3. Run a search — the results appear as density clusters across the city

Try the same queries from Part 1 and see them visualized on the map.

## Bonus: Tool Generation — Build a Custom Tool

Claude Code can build working interactive tools from a natural language description. You describe the workflow, Claude writes and runs the code. This is what "MCP as a platform" looks like — custom applications built on demand using live infrastructure data.

### ADA Compliance Checker

```
Build me a tool that shows ADA ramps from Cyvl imagery one by one. For each image, let me mark it as "compliant" or "non-compliant" with a note. After reviewing, generate a summary with the compliance rate.
```

### Pothole Triage Tool

```
Build me a tool that pulls pothole complaints from 311, shows street-level imagery for each location, and lets me assign a priority. Export the prioritized list as a CSV.
```

### Sign Condition Inspector

```
Build me a tool that shows stop signs in a neighborhood one by one from imagery. Let me rate each as good, damaged, or missing.
```

See `prompts/tool-generation.md` for more examples.

---

## Explore On Your Own

Try these compound questions that use both MCPs:

```
Which neighborhoods have the worst combination of high crash rates and poor pavement?
```

```
Find streets where the city is actively doing construction. Are those the streets that need it most based on pavement scores?
```

```
Search for "school zones" in imagery, then check the pavement condition and crash history near each one.
```

```
Are there intersections with faded crosswalk markings that also have high pedestrian crash counts?
```

```
Compare construction permits (Active Work Zones) with construction visible in imagery for the South End. Are there sites in imagery with no permits?
```

---

## Quick Reference

### Cyvl MCP — Boston Project

- **Project ID:** `8d8f8cd6-f25a-470c-88fd-6b0e0ad4d1d7`
- **Coverage:** 882 miles, 237K embedded images
- **Tools:** `search_imagery`, `list_pavement_scores`, `list_distresses`, `list_signs`, `assess_infrastructure`

### Boston Open Data — Key Resource IDs


| Dataset             | Resource ID                            |
| ------------------- | -------------------------------------- |
| Vision Zero Crashes | `e4bfe397-6bfc-49c5-9367-c879fac7401d` |
| Active Work Zones   | `36fcf981-e414-4891-93ea-f5905cec46fc` |
| 311 Requests (2026) | `1a0b420d-99f1-4887-9851-990b2a5a6e17` |
| Building Permits    | `6ddcd912-32a0-43df-9908-63574f8c7e77` |


### Tips

- If a Cyvl call returns a 502 error, retry once — transient proxy errors resolve immediately.
- Dense areas may timeout on `list_distresses` — use `search_imagery` as an alternative.
- The first Cyvl call is slow (cold start). After warmup, everything is fast.
- Street names are UPPERCASE in crash data: `'BLUE HILL AVE'` not `'Blue Hill Ave'`.
