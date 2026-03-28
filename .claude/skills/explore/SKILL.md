---
name: explore
description: Discover what civic data exists about any topic. No coding needed — AI finds and summarizes datasets for you.
allowed-tools: mcp__boston__*, mcp__socrata__*, mcp__data-commons__*, mcp__claude_ai_Boston_CIO_MCP__*
argument-hint: [topic, e.g. "potholes", "school safety", "restaurant grades"]
---

# Explore Civic Data

Find datasets about any topic across multiple cities and present them in plain language.

## Workflow

1. **Determine city** from the user's query. Default to NYC for this demo. If ambiguous, ask.

2. **Search for datasets** using the right MCP for the city:
   - NYC, Chicago, SF, Seattle, LA --> socrata `search` tool (domain auto-detected)
   - Boston --> boston `search_datasets` tool
   - Demographics or statistics for any city --> data-commons `search_indicators` with `places` array

3. **Discover columns** before querying. For every dataset found:
   - Socrata: `get_data` with `SELECT * LIMIT 1` to see real column names
   - Boston: `get_schema` on the resource ID
   - Data Commons: columns come from the indicator metadata

4. **Pull 3-5 sample records** from each relevant dataset to show what's actually in it.

5. **Present results in plain English:**
   - "I found [N] datasets about [topic]. Here's what's in them:"
   - Show each dataset with a one-line description and a simple table of sample records
   - Mention how many total records exist and the date range

6. **Offer next steps:** "Want me to dig deeper into any of these?"

## Rules

- NEVER show raw query syntax to the user — no SQL, no SoQL, no API calls
- Always discover columns first (step 3) before writing real queries
- Present data as simple tables or bullet points, not code blocks
- If no results found, suggest 2-3 related topics the user could try instead
- Cite which city's data portal each dataset comes from
- For Data Commons results, always include the source organization (Census, WHO, etc.)
