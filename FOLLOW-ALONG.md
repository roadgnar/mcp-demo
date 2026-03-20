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

## Warmup

The first Cyvl MCP call in a session can take 5-10 seconds (cold start). Run one search to warm up the connection:

```
Search for "fire hydrants" in the Boston project. How many did you find?
```

Once this returns, you're good to go. Subsequent calls are fast.

---

## Part 1: Imagery Search — "Search for Anything"

The Cyvl MCP has 237,000 street-level images of Boston, all searchable by natural language. No model was trained for these searches — it works for anything visible in the photos.

### 1a. Find fire hydrants

```
Search for "fire hydrants" in the Boston project. Download three of them to results/fire_hydrants/.
```

This is the highest-confidence query — concrete, well-defined objects return the most reliable results.

### 1b. Find faded crosswalk markings

```
Search for "faded crosswalk markings" in Boston. Download three of them to results/faded_crosswalk_markings/.
```

Safety-critical marking degradation quantified across the entire city.

### 1c. Find cracked sidewalks

```
Search for "cracked sidewalks and damaged curbs" across Boston.  Download three of them to results/cracked_sidewalks/.
```

Boston has no sidewalk condition data — this is the only way to inventory sidewalk conditions at scale.

### 1d. Find construction sites

```
Search for "construction sites with heavy machinery" in Boston. Download three of them to results/construction_sites/.
```

Construction activity visible in street-level photos — independent of the city's permit database. Try removing "with heavy machinery" to see how qualifiers narrow results.

### 1e. Find Blue Bike stations

```
Search for "blue bike docking stations" in the Boston project and tell me show many you found. Download three of them to results/blue_bike_stations/.
```

These stations aren't in any structured dataset — found purely from imagery.

### 1f. The fun one — find dogs

```
Search for "dogs" in the Boston street imagery. Download three of them to results/dogs/.
```

If we can find dogs, we can find anything.

---

## Part 2: Infrastructure Data — Pavement Conditions

Beyond imagery, the Cyvl MCP has structured pavement condition data for every road in Boston.

### 2a. Worst streets downtown

```
Show me the worst pavement conditions near Downtown Crossing in Boston. I want streets with PCI scores below 25.
```

### 2b. Drill into a bad street

```
Get the full pavement detail for the worst inspection from the previous results — show me all the distresses detected and the inspection cell imagery.
```

You'll get a breakdown of every crack, pothole, and weathering instance on a 30-foot section, with annotated mask images.

### 2c. High-severity distresses on Washington St

```
Find high-severity pavement distresses on Washington Street near Melnea Cass Boulevard in Roxbury. What types of damage are most common?
```

> **Tip:** If this times out, reduce the radius or try `search_imagery("damaged road surface")` for the same area instead. (If results seem off, try coordinates 42.333, -71.083.)

---

## Part 3: Boston Open Data — Crash Records

Now let's bring in the city's own data. The Boston Open Data MCP connects to data.boston.gov.

### 3a. Crash statistics by type

```
Using the Boston Open Data MCP, query the Vision Zero crash records. How many crashes are there by mode type (motor vehicle, pedestrian, bike)?
```

### 3b. Most dangerous streets

```
Which streets have the most crashes in Boston? Query Vision Zero crash records grouped by street name.
```

### 3c. Active construction zones

```
Using the Boston Open Data MCP, query the Active Work Zones dataset. Which neighborhoods have the most active construction? And break it down by project category.
```

---

## Part 4: Cross-MCP Analysis — Crashes Meet Pavement

This is where the two MCPs work together. No one has connected these datasets before.

### 4a. Washington St — the most dangerous street

```
Washington Street has the most crashes of any street in Boston. Using the Cyvl MCP, show me the pavement condition and high-severity distresses on Washington Street in Roxbury. Is there a connection between road quality and crashes?
```

### 4b. Blue Hill Ave — the pedestrian story

```
How many pedestrian and bike crashes have occurred on Blue Hill Avenue? Then search Cyvl imagery for "damaged road surface and potholes" near Blue Hill Avenue in Mattapan. Download three of them to results/blue_hill_ave/pedestrian/.
```

### 4c. Visual evidence on Washington St

```
Search Cyvl imagery for "damaged road surface" on Washington Street in Roxbury. Download three of them to results/washington_st/damaged_road_surface/.
```

### 4d. The 311 connection

```
Are there 311 pothole complaints on the same streets that have the most crashes? Query 311 service requests for pothole-related complaints in Dorchester and Roxbury.
```

### 4e. Build a prioritized repair list

```
Based on everything we've found, build me a prioritized repair list for the top 5 most dangerous streets in Boston. Rank by combined crash count and pavement severity. For each street, include: crash count by type, worst PCI score, dominant distress type, and one street-level photo.
```

This turns the analysis into a decision-support tool — the "so what" moment.

---

## Part 5: The Data Gap — Sidewalks

### 5a. Show what exists (and what's missing)

```
Search the Boston Open Data portal for any dataset about sidewalks or curb conditions.
```

You'll find geometry data from 2011 — the city knows WHERE sidewalks are but not what CONDITION they're in.

### 5b. Fill the gap with imagery

```
Since Boston has no sidewalk condition data, use Cyvl imagery search to find "cracked sidewalks and damaged curbs" across the city. Then search for "wheelchair accessible ramp with tactile paving." How many of each did you find?
```

### 5c. Find accessibility obstructions

```
Search for "narrow sidewalk blocked by utility pole" in Boston imagery. Download three of them to results/blocked_sidewalk/.
```

### 5d. Cross with 311 complaints

```
Query 311 service requests for sidewalk-related complaints. How many "Sidewalk Repair" requests are there in the 2026 data?
```

Citizens are reporting damage one at a time with no systematic way to prioritize — imagery search provides that.

---

## Part 6: Deliverable Generation

```
Create a report about infrastructure safety on Washington Street in Boston. Include:
1. Crash statistics from Vision Zero
2. Pavement condition data from Cyvl
3. Street-level imagery showing the damage
4. A prioritized repair recommendation

Format it as a report I could share with the mayor's office.
```

---

## Part 7: Tool Generation — Build a Custom Tool

This is what "MCP as a platform" looks like in practice — an AI agent builds a working tool from a natural language request.

### 7a. ADA Compliance Checker

```
Build me an interactive tool that shows ADA ramps from Cyvl imagery one by one. For each image, let me mark it as "compliant" or "non-compliant" with a note. After reviewing all images, generate a summary report with the compliance rate and a list of non-compliant locations.
```

Claude will build a working interactive tool right in the terminal.

### 7b. Pothole Triage Tool

```
Build me a tool that pulls the top 20 pothole complaints from 311, shows me the street-level imagery for each location, and lets me assign a priority (urgent/medium/low). Export the prioritized list as a CSV.
```

---

## Bonus: Imagery Search Heatmap

See imagery search results rendered geospatially on a map:

1. Go to [cyvl.app](https://cyvl.app/) and log in
2. Navigate to [cyvl.app/heatmap](https://cyvl.app/heatmap)
3. Run a search — the results appear as density clusters across the city

Try the same queries from Part 1 and see them visualized on the map.

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

