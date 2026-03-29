---
name: see
description: Search street-level photos and civic imagery. Shows real photos of infrastructure conditions, damage, or objects in any supported city.
allowed-tools: mcp__claude_ai_Cyvl__*, mcp__socrata__*, mcp__boston__*, mcp__claude_ai_Boston_CIO_MCP__*
argument-hint: [what to find + where, e.g. "cracked sidewalks in Dorchester", "bus stops near City Hall"]
---

# See — Street-Level Imagery Search

Find and display real photos of infrastructure, conditions, or objects in cities.

## Workflow

1. **Geocode the location:** `geocode_location` to get coordinates and identify the city.

2. **Check Cyvl coverage:** `list_projects(has_embeddings=true)` to see which cities have searchable imagery. See `reference/cyvl-coverage.md` for the current registry.

3. **If the city has Cyvl imagery** (e.g., Boston):
   - `search_imagery(query, project_id, output="metadata")` to get result count
   - Re-call with `output="image_content"`, `page_size=3`, `max_width=400` to show actual photos
   - Present each photo with its location and confidence score

4. **If the city does NOT have Cyvl imagery** (e.g., NYC currently):
   - Be honest: "Street-level AI imagery search isn't available for [city] yet."
   - **NYC fallback:** Search Socrata for 311 complaints near that location — many categories include photos or detailed descriptions of conditions
   - **Boston fallback:** Search Boston open data for related records with location info
   - **Other cities:** Search Socrata on that city's domain for geolocated records

5. **Present results:**
   - Cyvl photos: show image with location, confidence score, and what was detected
   - Fallback data: show complaint/record details with location and date

## Tips for Good Results

- Concrete nouns work best: "fire hydrants", "bus stops", "potholes"
- Add qualifiers for precision: "cracked sidewalks near schools"
- Confidence >= 80% is reliable; 60-79% should be verified visually
- Result counts are approximate — use "over 100" not "exactly 127"

## Rules

- Never hide the fallback — if imagery isn't available, say so clearly
- Keep `page_size` to 3-5 with `image_content` to manage response size
- Use `search_id` from metadata call to paginate — **`query` is always required**, even with `search_id`
- Always state which data source the results came from
