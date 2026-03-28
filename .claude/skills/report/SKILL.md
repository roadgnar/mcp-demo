---
name: report
description: Create a shareable PDF or HTML brief with data, photos, and recommendations. Ready to email to elected officials, community boards, or colleagues.
allowed-tools: mcp__claude_ai_Cyvl__*, mcp__boston__*, mcp__socrata__*, mcp__data-commons__*, mcp__claude_ai_Boston_CIO_MCP__*, Write, Read, Bash
argument-hint: [topic + audience, e.g. "sidewalk safety in East Harlem for Community Board 11", "pothole report for the mayor"]
---

# Report — Shareable Data Briefs

Generate a self-contained HTML report (with optional PDF conversion) tailored to a specific audience.

## Workflow

1. **Parse topic and audience** from user input. If no audience specified, default to "general public."

2. **Gather data** from relevant MCPs (auto-detect city from topic):
   - Boston --> boston MCP + Cyvl imagery (project `8d8f8cd6-f25a-470c-88fd-6b0e0ad4d1d7`)
   - NYC --> socrata MCP + Data Commons for demographic context
   - Cross-city --> both city MCPs + Data Commons for normalization

3. **Write self-contained HTML** with inline CSS. Use this base style:
   ```html
   body { font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', sans-serif; max-width: 800px; margin: 40px auto; padding: 0 20px; color: #1a1a1a; }
   h1 { border-bottom: 3px solid #2563eb; padding-bottom: 8px; }
   table { border-collapse: collapse; width: 100%; margin: 16px 0; }
   th, td { border: 1px solid #d1d5db; padding: 8px 12px; text-align: left; }
   th { background: #f3f4f6; }
   .metric { font-size: 2em; font-weight: bold; color: #2563eb; }
   .source { color: #6b7280; font-size: 0.85em; }
   img { max-width: 100%; border-radius: 8px; margin: 8px 0; }
   ```

4. **Structure by audience:**
   - **Elected officials / Community Board**: Lead with impact numbers + photos + recommendations
   - **Operations / Public Works**: Lead with specific streets, condition scores, repair priorities
   - **Advocacy / community orgs**: Lead with human impact, accessibility gaps, equity data

5. **Convert to PDF** if Chrome/Chromium is available:
   ```bash
   google-chrome --headless --disable-gpu --no-sandbox --print-to-pdf=report.pdf file:///path/to/report.html
   ```
   If not available, tell user: "Open the HTML file in any browser and use File > Print > Save as PDF."

## Report Sections

- **Title** with city, date, and "Data from [sources]"
- **Executive summary** — 2-3 sentences with the headline finding
- **Key metrics** — large-font numbers (use `.metric` class)
- **Data tables** — sortable findings with neighborhood/street detail
- **Photos** — embedded Cyvl imagery via `<img>` tags (use `output="urls"`) or referenced open data
- **Recommendations** — numbered, actionable, specific to the audience
- **Data sources** — cite every MCP and dataset used

## Rules

- Every number must cite its source (which MCP, which dataset)
- Keep reports to 2-4 printed pages
- No external dependencies — everything inline in one HTML file
- If a data source is unavailable, note "Data unavailable" and continue with what you have
- Save HTML to `results/` directory (create if needed)
