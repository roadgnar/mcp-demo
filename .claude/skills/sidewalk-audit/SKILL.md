---
name: sidewalk-audit
description: Audit sidewalk and curb conditions using imagery search. Use when the user asks about sidewalks, curbs, ADA compliance, or pedestrian infrastructure.
allowed-tools: mcp__claude_ai_Cyvl__*, mcp__claude_ai_Boston_CIO_MCP__*, mcp__boston__*
argument-hint: [neighborhood or "citywide"]
---

# Sidewalk & Curb Audit

Most cities lack systematic sidewalk condition data. Cyvl imagery search can fill the gap by detecting damage and accessibility features in street-level photos.

## Workflow

1. **Check what official data exists:** Search the open data portal for sidewalk datasets:
   `search_datasets("sidewalk")`
   - Assess what's available — many cities have geometry (location) data but no condition data.

2. **Search imagery** for sidewalk conditions — adjust queries to the user's focus:
   - `search_imagery("cracked sidewalks and damaged curbs")` — general condition
   - `search_imagery("ADA wheelchair ramps at intersections")` — accessibility inventory
   - `search_imagery("wheelchair accessible ramp with tactile paving")` — compliant ramps
   - `search_imagery("narrow sidewalk blocked by utility pole")` — obstructions
   - `search_imagery("missing curb ramps")` — accessibility gaps

3. **If a specific neighborhood** is requested, use `geocode_location` first, then add spatial filters (`lat`, `lon`, `radius_m`).

4. **Cross-reference with 311 complaints:** Query 311 for sidewalk-related complaints:
   - Legacy 311 (`1a0b420d-99f1-4887-9851-990b2a5a6e17`): filter `case_title ILIKE '%sidewalk%'`
   - Returns: `'Sidewalk Repair (Make Safe)'`, `'Unshoveled Sidewalk'`
   - For pothole complaints: `case_title ILIKE '%pothole%'`
   - **Always use `execute_sql`** — `query_data` filters are broken

5. **Present findings:**
   - Damaged sidewalks found in imagery (count and confidence)
   - ADA ramp inventory from imagery
   - Accessibility obstructions identified
   - 311 complaint volume for sidewalk issues
   - Gap analysis: how do citizen-reported issues compare to what imagery reveals?

## Key Insight
Building a sidewalk inventory manually costs millions. Imagery search generates a preliminary condition inventory from existing street-level photos — today. It can also validate individual repair requests against visual evidence.
