---
name: sidewalk-audit
description: Audit sidewalk and curb conditions using imagery and city data. Works for any city with Cyvl imagery.
allowed-tools: mcp__claude_ai_Cyvl__*, mcp__claude_ai_Boston_CIO_MCP__*, mcp__boston__*, mcp__socrata__*, mcp__data-commons__*
argument-hint: [neighborhood or "citywide"]
---

# Sidewalk & Curb Audit

Most cities lack systematic sidewalk condition data. Cyvl imagery search can fill the gap by detecting damage and accessibility features in street-level photos.

## Workflow

1. **Check what official data exists:** Search the open data portal for sidewalk datasets:
   - Boston: `search_datasets("sidewalk")`
   - NYC/other Socrata cities: `search(query="sidewalk", domain="...")`
   - Assess what's available — many cities have geometry (location) data but no condition data.

2. **Search imagery** for sidewalk conditions — adjust queries to the user's focus:
   - `search_imagery("cracked sidewalks and damaged curbs")` — general condition
   - `search_imagery("ADA wheelchair ramps at intersections")` — accessibility inventory
   - `search_imagery("wheelchair accessible ramp with tactile paving")` — compliant ramps
   - `search_imagery("narrow sidewalk blocked by utility pole")` — obstructions
   - `search_imagery("missing curb ramps")` — accessibility gaps

3. **If a specific neighborhood** is requested, use `geocode_location` first, then add spatial filters (`lat`, `lon`, `radius_m`).

4. **Cross-reference with 311 complaints:**
   - **Boston:** `execute_sql` against the legacy 311 dataset. Filter `case_title ILIKE '%sidewalk%'`.
   - **NYC:** `get_data` with SoQL against the 311 dataset. Filter `upper(complaint_type) LIKE '%SIDEWALK%'`.
   - Returns sidewalk repair requests, unshoveled sidewalk complaints, etc.
   - For pothole complaints: filter on `'%pothole%'` (Boston) or `'%POTHOLE%'` (NYC).

5. **Present findings:**
   - Damaged sidewalks found in imagery (count and confidence)
   - ADA ramp inventory from imagery
   - Accessibility obstructions identified
   - 311 complaint volume for sidewalk issues
   - Gap analysis: how do citizen-reported issues compare to what imagery reveals?

## Key Insight
Building a sidewalk inventory manually costs millions. Imagery search generates a preliminary condition inventory from existing street-level photos — today. It can also validate individual repair requests against visual evidence.

## Quick Reference

**Boston (CKAN):**
| Dataset | Resource ID |
|---------|------------|
| 311 (2026) | `1a0b420d-99f1-4887-9851-990b2a5a6e17` |
| 311 (New System) | `254adca6-64ab-4c5c-9fc0-a6da622be185` |

**NYC (Socrata):**
| Dataset | Dataset ID |
|---------|-----------|
| 311 Requests | `erm2-nwe9` |
