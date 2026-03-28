# Spatial Filters — Quick Reference

Both Cyvl and open data MCPs use lat/long coordinates. Here's how to work with locations across them.

## Converting Place Names to Coordinates

Use the Cyvl MCP's `geocode_location` tool:

```
geocode_location("Main Street, Anytown, US")
→ lat: 42.295605, lon: -71.087944, bbox: [-71.09, 42.29, -71.08, 42.30]
```

Works for any address, street, neighborhood, or city name.

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
- Keep radius at 500m or below for pavement queries
- `assess_infrastructure` works best at 300m or below
- Imagery search can handle larger areas — use `bbox` for entire neighborhoods

## Open Data Spatial Filtering

### Boston CKAN (SQL with lat/long columns)
Most Boston datasets include `lat` and `long` as TEXT columns:
```sql
SELECT * FROM "resource-id"
WHERE lat::float BETWEEN 42.29 AND 42.30
  AND long::float BETWEEN -71.10 AND -71.08
```

### Socrata (within_circle)
Socrata datasets with a `location` column support spatial queries:
```
WHERE within_circle(location, 40.78, -73.97, 500)
```
Parameters: `(location_column, latitude, longitude, radius_in_meters)`

## Joining Across MCPs

The common key is **location**. General approach:

1. Get data from open data MCP with lat/long (crashes, 311, permits)
2. Use those coordinates in Cyvl MCP as `radius` filters
3. Present both datasets together, noting which source each came from

Example flow:
```
Open data: "Top crash streets" → Main St (lat, lon)
Cyvl MCP: list_distresses(radius={lat, lng, meters=300})
→ Now you have crashes AND pavement distresses for the same location
```

## City-Specific Coordinates

City branches include neighborhood/borough coordinate tables for quick lookups:
- `git checkout boston` → Boston neighborhood centers (17 neighborhoods)
- `git checkout nyc` → NYC borough centers (5 boroughs)
