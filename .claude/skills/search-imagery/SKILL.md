---
name: search-imagery
description: Search street-level imagery by natural language. Use when the user wants to find objects, scenes, or conditions in street photos.
allowed-tools: mcp__claude_ai_Cyvl__*
argument-hint: [search query, e.g. "bus stops", "cracked sidewalks"]
---

# Search Street-Level Imagery

Search street-level images using natural language via the Cyvl MCP.

**Default Project (NYC — Jackson Heights, Queens):** `1924f65d-01b6-4170-b0b8-ddf6a887b6e5`

For other cities, use `list_projects` to discover available project IDs.

## Workflow

1. Run `search_imagery` with `output="metadata"` first to get a count:
   - query: $ARGUMENTS (or ask the user what to search for)
   - project_id: use the appropriate project ID for the target city
   - page_size: 5

2. Report the result count and average confidence level.

3. Ask: "Want to see the images?" If yes, re-call with same `query` AND `search_id`:
   - query: same query as step 1 (**required even with search_id**)
   - search_id: from step 1
   - output: `image_content`
   - page_size: 3
   - max_width: 400

4. If the user wants to narrow by location, use `geocode_location` first to get coordinates, then add `lat`, `lon`, `radius_m` to the search.

## Tips
- Concrete nouns work best: "fire hydrants" > "red things"
- Confidence >= 80% = reliable; 60-79% = verify visually
- Each result includes `detected_objects`, `pci_score`, `distress_types` metadata
- Result counts fluctuate as the embedding index evolves — use approximate language
