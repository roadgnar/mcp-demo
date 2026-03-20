---
name: generate-report
description: Generate a PDF infrastructure report with data from both MCPs. Use when the user asks for a report, deliverable, presentation, or PDF.
allowed-tools: mcp__cyvl__*, mcp__claude_ai_Cyvl__*, mcp__claude_ai_Boston_CIO_MCP__*, mcp__boston__*, Write, Read, Bash
argument-hint: [topic, e.g. "pavement safety on Washington St"]
---

# Generate Infrastructure Report

Create an HTML report and convert it to PDF using Chrome's built-in print-to-PDF.

## Prerequisites Check

Run this first:
```bash
google-chrome --version 2>/dev/null || chromium --version 2>/dev/null || echo "NO BROWSER FOUND"
```

- **Chrome/Chromium found** → full PDF generation works
- **Not found** → generate HTML only, user can open in any browser and print to PDF manually

## Workflow

1. **Gather data** from both MCPs:
   - **Crash data** (Boston Open Data): Vision Zero for the target street/area
   - **Pavement data** (Cyvl): list_pavement_scores and/or list_distresses
   - **Imagery URLs** (Cyvl): search_imagery with `output="urls"` for embeddable image links
   - **311 complaints** (Boston Open Data): relevant complaints for the area
   - **Construction** (Boston Open Data): active work zones if relevant

2. **Write an HTML report** with inline CSS — self-contained, no external dependencies:

   ```html
   <!DOCTYPE html>
   <html>
   <head>
     <meta charset="utf-8">
     <style>
       body { font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', sans-serif; max-width: 800px; margin: 40px auto; padding: 0 20px; color: #1a1a1a; }
       h1 { border-bottom: 3px solid #2563eb; padding-bottom: 8px; }
       table { border-collapse: collapse; width: 100%; margin: 16px 0; }
       th, td { border: 1px solid #d1d5db; padding: 8px 12px; text-align: left; }
       th { background: #f3f4f6; }
       .metric { font-size: 2em; font-weight: bold; color: #2563eb; }
       .source { color: #6b7280; font-size: 0.85em; }
       img { max-width: 100%; border-radius: 8px; margin: 8px 0; }
     </style>
   </head>
   <body>
     <!-- Report content here -->
   </body>
   </html>
   ```

3. **Save the HTML** to the output path (e.g., `results/agent-1/report.html`)

4. **Convert to PDF** if Chrome is available:
   ```bash
   google-chrome --headless --disable-gpu --no-sandbox --print-to-pdf=results/agent-1/report.pdf file:///absolute/path/to/report.html
   ```

   If Chrome isn't found, tell the user: "Open the HTML file in any browser and use File → Print → Save as PDF."

## Report Structure

- **Title** — topic, date, "Data from Cyvl MCP + Boston Open Data"
- **Executive Summary** — 2-3 sentences, the headline finding
- **Key Metrics** — big numbers in large font (total crashes, worst PCI score, etc.)
- **Crash Analysis** — data table with mode breakdown (MV, pedestrian, bike)
- **Pavement Condition** — PCI scores, distress types and severity
- **Visual Evidence** — embedded street-level imagery (use image URLs from search_imagery output="urls")
- **311 Complaints** — citizen reports correlated with measured conditions
- **Recommendations** — prioritized repair actions based on combined data
- **Data Sources** — cite which MCP and resource each number came from

## Notes
- Use `output="urls"` for imagery — the URLs embed directly in HTML via `<img>` tags
- Keep reports to 2-4 pages when printed
- If a query fails or times out, note "Data unavailable" and continue
- Every number must cite its source (Cyvl MCP or Boston Open Data)
