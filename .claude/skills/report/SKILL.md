---
name: report
description: Create a shareable HTML brief with data, photos, and recommendations. DO NOT generate Python or JavaScript scripts — write the HTML directly.
allowed-tools: mcp__claude_ai_Cyvl__*, mcp__boston__*, mcp__socrata__*, mcp__data-commons__*, mcp__claude_ai_Boston_CIO_MCP__*, Write, Read, Bash
argument-hint: [topic + audience, e.g. "sidewalk safety in Jackson Heights for CB3", "pothole report for the mayor"]
---

# Report — Shareable Data Briefs

Generate a self-contained HTML report by writing it directly with the Write tool. No scripts.

## CRITICAL RULES

- **DO NOT** create .py, .js, .ts, or any script files to generate the report
- **DO NOT** use reportlab, jinja2, puppeteer, or any templating library
- **DO** write the final HTML directly using the Write tool — one file, complete
- **DO** embed all CSS inline in a `<style>` tag — no external stylesheets
- **DO** use `<img src="URL">` for Cyvl imagery — get URLs via `search_imagery(output="urls")`
- **DO** save to `results/` directory

## Step-by-Step Workflow

### Step 1: Gather Data

Run these MCP calls and save the results mentally. Do NOT write intermediate files.

**Cyvl imagery** (if available for the city):
```
search_imagery(query="[topic]", project_id="[id]", output="urls", page_size=5)
```
Save the `image_url` values from the response. These are direct URLs you can put in `<img>` tags.

**Open data** (pick the right MCP for the city):
- Boston: `execute_sql("SELECT ... FROM \"resource-id\" WHERE ... LIMIT 20")`
- NYC/other: `get_data(dataset_id="...", select="...", where="...", limit="20")`

**Demographics** (if relevant):
```
get_observations(variable_dcid="Count_Person", place_dcid="geoId/...", date="latest")
```

### Step 2: Write the HTML

Use the Write tool to create `results/report.html` (or a topic-specific name).

Use this EXACT template structure — fill in the data you gathered:

```html
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>[TOPIC] — [CITY] Infrastructure Brief</title>
<style>
* { box-sizing: border-box; margin: 0; padding: 0; }
body { font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', system-ui, sans-serif; max-width: 900px; margin: 0 auto; padding: 40px 24px; color: #1a1a2e; line-height: 1.6; }
header { border-bottom: 4px solid #2563eb; padding-bottom: 16px; margin-bottom: 32px; }
header h1 { font-size: 1.8em; color: #1a1a2e; }
header .subtitle { color: #6b7280; font-size: 0.95em; margin-top: 4px; }
.summary { background: #f0f4ff; border-left: 4px solid #2563eb; padding: 16px 20px; margin: 24px 0; border-radius: 0 8px 8px 0; }
.metrics { display: flex; gap: 16px; flex-wrap: wrap; margin: 24px 0; }
.metric-card { flex: 1; min-width: 180px; background: #fff; border: 1px solid #e5e7eb; border-radius: 12px; padding: 20px; text-align: center; }
.metric-card .number { font-size: 2.2em; font-weight: 700; color: #2563eb; }
.metric-card .label { font-size: 0.85em; color: #6b7280; margin-top: 4px; }
h2 { font-size: 1.3em; margin: 32px 0 12px; color: #1a1a2e; border-bottom: 1px solid #e5e7eb; padding-bottom: 8px; }
table { width: 100%; border-collapse: collapse; margin: 16px 0; font-size: 0.9em; }
th { background: #f9fafb; text-align: left; padding: 10px 12px; border: 1px solid #e5e7eb; font-weight: 600; }
td { padding: 10px 12px; border: 1px solid #e5e7eb; }
tr:nth-child(even) { background: #f9fafb; }
.photo-grid { display: grid; grid-template-columns: repeat(auto-fit, minmax(250px, 1fr)); gap: 12px; margin: 16px 0; }
.photo-grid img { width: 100%; height: 200px; object-fit: cover; border-radius: 8px; border: 1px solid #e5e7eb; }
.photo-grid .caption { font-size: 0.8em; color: #6b7280; margin-top: 4px; }
.recommendation { background: #fefce8; border-left: 4px solid #eab308; padding: 12px 16px; margin: 8px 0; border-radius: 0 8px 8px 0; }
.sources { font-size: 0.85em; color: #6b7280; margin-top: 32px; border-top: 1px solid #e5e7eb; padding-top: 16px; }
.sources li { margin: 4px 0; }
@media print { body { padding: 20px; } .metric-card { break-inside: avoid; } }
</style>
</head>
<body>

<header>
  <h1>[TOPIC]</h1>
  <div class="subtitle">[CITY] | [DATE] | Data from Cyvl + [Open Data Source] + Data Commons</div>
</header>

<div class="summary">
  <strong>Key Finding:</strong> [2-3 sentence executive summary with the headline number]
</div>

<div class="metrics">
  <div class="metric-card">
    <div class="number">[NUMBER]</div>
    <div class="label">[What this measures]</div>
  </div>
  <div class="metric-card">
    <div class="number">[NUMBER]</div>
    <div class="label">[What this measures]</div>
  </div>
  <div class="metric-card">
    <div class="number">[NUMBER]</div>
    <div class="label">[What this measures]</div>
  </div>
</div>

<h2>Visual Evidence</h2>
<div class="photo-grid">
  <div>
    <img src="[CYVL_IMAGE_URL_1]" alt="[description]">
    <div class="caption">[Location] | Confidence: [X]%</div>
  </div>
  <div>
    <img src="[CYVL_IMAGE_URL_2]" alt="[description]">
    <div class="caption">[Location] | Confidence: [X]%</div>
  </div>
  <div>
    <img src="[CYVL_IMAGE_URL_3]" alt="[description]">
    <div class="caption">[Location] | Confidence: [X]%</div>
  </div>
</div>

<h2>Data Analysis</h2>
<table>
  <thead><tr><th>[Column 1]</th><th>[Column 2]</th><th>[Column 3]</th></tr></thead>
  <tbody>
    <tr><td>[data]</td><td>[data]</td><td>[data]</td></tr>
    <!-- Add rows as needed -->
  </tbody>
</table>

<h2>Recommendations</h2>
<div class="recommendation"><strong>1.</strong> [Specific, actionable recommendation with supporting data]</div>
<div class="recommendation"><strong>2.</strong> [Second recommendation]</div>
<div class="recommendation"><strong>3.</strong> [Third recommendation]</div>

<div class="sources">
  <strong>Data Sources</strong>
  <ul>
    <li>[Source 1]: [MCP name], dataset [ID], queried [date]</li>
    <li>[Source 2]: [MCP name], dataset [ID], queried [date]</li>
  </ul>
</div>

</body>
</html>
```

### Step 3: Save and Report

1. Write the complete HTML to `results/[topic-slug]/report.html` using the Write tool
2. Tell the user the file path
3. Optionally convert to PDF if Chrome is available:
   ```bash
   google-chrome --headless --disable-gpu --no-sandbox --print-to-pdf=results/[topic-slug]/report.pdf file:///absolute/path/to/results/[topic-slug]/report.html
   ```
4. If no Chrome: "Open the HTML file in your browser to view or print to PDF."

## Adapting the Template

- **More metrics?** Add more `<div class="metric-card">` blocks
- **No photos?** Remove the photo-grid section entirely
- **More data tables?** Add more `<h2>` + `<table>` sections
- **Different audience?** Reorder sections:
  - Elected officials: Summary → Metrics → Photos → Recommendations (top)
  - Operations: Data tables → Metrics → Recommendations → Photos
  - Advocacy: Summary → Photos → Equity data → Recommendations

## Image URL Workflow

Cyvl imagery URLs come from `search_imagery(query="...", output="urls")`. Each result has an `image_url` field.

**Important:** `query` is always required, even when paginating with `search_id`. Example:
```
search_imagery(query="potholes", project_id="...", output="urls", page_size=5)
search_imagery(query="potholes", search_id="abc123", output="urls", page=2)  # query still required
```

Example response:
```json
{"results": [{"image_url": "https://cdn.cyvl.ai/...", "confidence": 0.87, "lat": 42.30, "lon": -71.08}]}
```

Put those URLs directly in `<img src="...">` tags. They are publicly accessible CDN URLs.

If no Cyvl imagery is available for the city, skip the photo section and note it in the report.

## What NOT to Do

- DO NOT create a Python script that generates HTML
- DO NOT create a JavaScript/Node.js script
- DO NOT use any template engine (jinja2, handlebars, etc.)
- DO NOT fetch images and base64-encode them
- DO NOT write intermediate JSON data files
- The Write tool can write the entire HTML file in one shot — use it
