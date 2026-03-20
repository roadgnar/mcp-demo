# Cyvl MCP — Tool Reference

Server name: `cyvl` | 19 tools | Endpoint: `i3.cyvl.dev`

## Discovery

| Tool | Purpose |
|------|---------|
| `list_projects` | Find projects, get `project_id`. Use `has_embeddings=true` for imagery-searchable projects. |
| `geocode_location` | Convert place name → lat/lon + bbox. Call first when users mention locations by name. |
| `get_project_overview` | Project-wide statistics (no spatial filter needed). |

## Imagery Search

| Tool | Purpose |
|------|---------|
| `search_imagery` | Natural language search over street-level image embeddings. The headline feature. |

### `search_imagery` Parameters

| Parameter | Type | Notes |
|-----------|------|-------|
| `query` | string | Natural language — "bus stops", "cracked sidewalks" |
| `project_id` | string | Always provide for performance |
| `output` | enum | `metadata` (fast, default), `urls` (download links), `image_content` (inline photos) |
| `page_size` | int | 1-200. Use 3-5 with `image_content` for token efficiency |
| `max_width` | int | Pixel width for `image_content`. Use 400 for demos |
| `lat`, `lon`, `radius_m` | float | Optional spatial filter |
| `bbox` | array | `[west, south, east, north]` alternative to radius |
| `search_id`, `page` | string, int | Pagination — reuse `search_id` from previous response |
| `min_score` | float | Confidence threshold (default 0.4) |

### Workflow
```
1. search_imagery(query, output="metadata")  → get count + search_id
2. search_imagery(search_id=X, output="image_content", page_size=3, max_width=400)  → view photos
3. search_imagery(search_id=X, page=2, output="image_content")  → next page
```

## Infrastructure Queries

All require `project_id` + spatial filter (`bbox` or `radius`).

| Tool | Data | Key Filters |
|------|------|-------------|
| `list_pavement_scores` | PCI scores per 30ft inspection cell | `score_min`, `score_max`, `label` (Failed…Excellent) |
| `list_pavement_segments` | Aggregated segment scores | Same as above |
| `list_distresses` | Individual distresses (cracks, potholes) | `distress_type`, `severity` (low/medium/high) |
| `list_signs` | Traffic signs (MUTCD coded) | MUTCD code filters |
| `list_above_ground_assets` | Fire hydrants, poles, etc. | Asset type filters |
| `list_markings` | Road striping and markings | Marking type filters |
| `list_inspection_cells` | Inspection cell imagery | — |

## Detail / Drill-Down

| Tool | Purpose |
|------|---------|
| `get_pavement_score_detail` | Full detail for one inspection: score + all distresses + imagery |
| `get_sign` | Single sign detail |
| `get_above_ground_asset` | Single asset detail |
| `get_asset` | Generic asset detail by ID |
| `get_asset_imagery` | Get imagery for a specific asset |
| `get_marking` | Single marking detail |

## Composite

| Tool | Purpose |
|------|---------|
| `assess_infrastructure` | One-call assessment: geocode + spatial query + PCI distribution + asset inventory. Keep radius ≤ 300m. |
| `query_infrastructure` | Cross-layer spatial query |

## Spatial Filter Format

**Radius:**
```json
{"lat": 42.36, "lng": -71.06, "meters": 300}
```

**Bounding box:**
```json
[-71.08, 42.34, -71.04, 42.37]  // [west, south, east, north]
```

## PCI Score Scale

| Score | Label | Meaning |
|-------|-------|---------|
| 86-100 | Excellent / Very Good | No or minimal distress |
| 71-85 | Good | Low distress, routine maintenance |
| 56-70 | Satisfactory / Fair | Moderate distress, preservation needed |
| 41-55 | Poor | Significant distress, rehabilitation needed |
| 26-40 | Very Poor | Extensive distress |
| 11-25 | Serious | Severe structural failure |
| 0-10 | Failed | Needs immediate reconstruction |
