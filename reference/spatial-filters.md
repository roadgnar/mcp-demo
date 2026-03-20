# Spatial Filters — Quick Reference

Both MCPs use lat/long coordinates. Here's how to work with locations across them.

## Converting Place Names to Coordinates

Use the Cyvl MCP's `geocode_location` tool:

```
geocode_location("Blue Hill Ave, Boston, MA")
→ lat: 42.295605, lon: -71.087944, bbox: [-71.09, 42.29, -71.08, 42.30]
```

## Cyvl MCP Spatial Filters

All `list_*` tools accept either `radius` or `bbox`:

**Radius (recommended for neighborhoods):**
```json
{
  "radius": {
    "lat": 42.295605,
    "lng": -71.087944,
    "meters": 300
  }
}
```

**Bounding box (for rectangular areas):**
```json
{
  "bbox": [-71.08, 42.29, -71.04, 42.37]
}
```
Format: `[west, south, east, north]`

**Performance tips:**
- Keep radius ≤ 500m for pavement queries
- `assess_infrastructure` works best at ≤ 300m
- Imagery search can handle larger areas — use `bbox` of entire neighborhoods

## Boston CKAN Spatial Filtering

Boston's datasets don't have built-in spatial filters, but most include lat/long columns. Use SQL:

**Crashes near a point (approximate):**
```sql
SELECT * FROM "e4bfe397-..."
WHERE lat::float BETWEEN 42.29 AND 42.30
  AND long::float BETWEEN -71.10 AND -71.08
```

**311 in a neighborhood:**
```sql
SELECT * FROM "1a0b420d-..."
WHERE neighborhood = 'Dorchester'
```

## Joining Across MCPs

The common key is **location**. General approach:

1. Get data from Boston CKAN with lat/long (crashes, 311, work zones)
2. Use those coordinates in Cyvl MCP as `radius` filters
3. Present both datasets together, noting which source each came from

Example flow:
```
Boston CKAN: "Top crash streets" → Blue Hill Ave (42.296, -71.088)
Cyvl MCP: list_distresses(radius={lat:42.296, lng:-71.088, meters:300})
→ Now you have crashes AND pavement distresses for the same location
```

## Boston Neighborhood Approximate Centers

| Neighborhood | Lat | Lon |
|-------------|-----|-----|
| Downtown / Financial District | 42.356 | -71.057 |
| Back Bay | 42.350 | -71.080 |
| South End | 42.341 | -71.072 |
| Beacon Hill | 42.359 | -71.068 |
| North End | 42.365 | -71.054 |
| Dorchester | 42.300 | -71.067 |
| Roxbury | 42.323 | -71.085 |
| Jamaica Plain | 42.310 | -71.115 |
| Allston/Brighton | 42.353 | -71.135 |
| South Boston | 42.338 | -71.044 |
| East Boston | 42.375 | -71.025 |
| Mattapan | 42.277 | -71.094 |
| Hyde Park | 42.255 | -71.125 |
| West Roxbury | 42.280 | -71.160 |
| Roslindale | 42.285 | -71.130 |
| Charlestown | 42.380 | -71.060 |
| Fenway/Kenmore | 42.345 | -71.100 |
