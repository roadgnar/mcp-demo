---
name: crash-analysis
description: Analyze crash data and correlate with pavement conditions. Works for Boston (Vision Zero) and other cities.
allowed-tools: mcp__claude_ai_Cyvl__*, mcp__claude_ai_Boston_CIO_MCP__*, mcp__boston__*, mcp__socrata__*, mcp__data-commons__*
argument-hint: [street name or neighborhood, e.g. "Blue Hill Ave", "Dorchester"]
---

# Crash + Pavement Analysis

Cross-MCP analysis: crash records + pavement distresses (Cyvl). Supports Boston (CKAN), NYC (Socrata), and other cities.

## Workflow

0. **Determine city.** Boston → use boston MCP. NYC → use socrata MCP. Use data-commons for demographic context (population, income) in any city.

1. **Get crash data** for the target area:
   - **Boston:** `execute_sql` against the Vision Zero crash dataset (see Quick Reference).
     ```sql
     SELECT street, mode_type, count(*) as crashes
     FROM "RESOURCE_ID"
     WHERE street = 'TARGET STREET'
     GROUP BY street, mode_type ORDER BY crashes DESC
     ```
   - **NYC:** `get_data` with SoQL against the Motor Vehicle Collisions dataset (see Quick Reference).
   Replace `TARGET STREET` with the uppercase street name from the user's query.

2. **Geocode** the target street: `geocode_location("TARGET STREET, CITY, STATE")`
   - Use the target city, not hardcoded Boston.
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
- Boston: Use `left(dispatch_ts, 4)` for year — `EXTRACT()` is blocked
- Boston: lat/long are text type — cast with `::float` for math
- NYC SoQL: use `upper()` for case-insensitive matching, not `ILIKE`

## Quick Reference

**Boston (CKAN):**
| Dataset | Resource ID |
|---------|------------|
| Vision Zero Crashes | `e4bfe397-6bfc-49c5-9367-c879fac7401d` |
| Vision Zero Fatalities | `92f18923-d4ec-4c17-9405-4e0da63e1d6c` |

**NYC (Socrata):**
| Dataset | Dataset ID |
|---------|-----------|
| Motor Vehicle Collisions | `h9gi-nx95` |
| Traffic Volume Counts | `btm5-ppia` |
