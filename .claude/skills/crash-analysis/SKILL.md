---
name: crash-analysis
description: Analyze car crash data from Vision Zero and correlate with pavement conditions. Use when the user asks about crashes, dangerous streets, or road safety.
allowed-tools: mcp__cyvl__*, mcp__claude_ai_Cyvl__*, mcp__claude_ai_Boston_CIO_MCP__*, mcp__boston__*
argument-hint: [street name or neighborhood, e.g. "Blue Hill Ave", "Dorchester"]
---

# Crash + Pavement Analysis

Cross-MCP analysis: Vision Zero crash records (Boston Open Data) + pavement distresses (Cyvl).

## Data Sources

- **Crashes:** Resource `e4bfe397-6bfc-49c5-9367-c879fac7401d` (Vision Zero)
  - Fields: `dispatch_ts`, `mode_type` (mv/ped/bike), `street`, `lat`, `long`
- **Pavement:** Cyvl MCP — use the appropriate project ID for the target city

## Workflow

1. **Get crash data** for the target area:
   ```sql
   SELECT street, mode_type, count(*) as crashes
   FROM "e4bfe397-6bfc-49c5-9367-c879fac7401d"
   WHERE street = 'TARGET STREET'
   GROUP BY street, mode_type ORDER BY crashes DESC
   ```
   Replace `TARGET STREET` with the uppercase street name from the user's query.

2. **Geocode** the target street: `geocode_location("TARGET STREET, Boston, MA")`
   - Note: geocoding can resolve to unexpected ends of long streets. If results seem off, try adding a cross street or neighborhood for precision.

3. **Get pavement distresses** at that location:
   `list_distresses(project_id, radius={lat, lng, meters=200}, severity="high")`
   - If this times out (common on dense urban corridors), reduce radius to 100m or fall back to `search_imagery`.
   - Alternative: `list_pavement_scores(project_id, radius=..., score_max=25)` is 5-7x faster and identifies the worst-condition road segments.

4. **Search imagery** for visual evidence:
   `search_imagery("damaged road surface", lat, lon, radius_m=300, output="metadata")`

5. **Present findings** side by side:
   - Crash count by type (MV, pedestrian, bike)
   - Pavement distress types and severity
   - Visual evidence from imagery
   - Whether there's a correlation between crash locations and poor pavement

## SQL Gotchas
- Street names are UPPERCASE in crash data: `'BLUE HILL AVE'` not `'Blue Hill Ave'`
- Use `left(dispatch_ts, 4)` for year — `EXTRACT()` is blocked
- lat/long are text type — cast with `::float` for math
