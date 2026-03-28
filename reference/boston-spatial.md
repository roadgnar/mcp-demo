# Boston Neighborhoods -- Spatial Reference

## Neighborhood Coordinates

Use these as center points for spatial queries (Cyvl radius filters, CKAN coordinate ranges).

| Neighborhood | Latitude | Longitude |
|-------------|----------|-----------|
| Downtown | 42.356 | -71.057 |
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

## Spatial Query Examples

**Cyvl -- search imagery in a neighborhood:**
```
search_imagery(query="cracked sidewalks", project_id="8d8f8cd6-...", lat=42.300, lon=-71.067, radius_m=500)
```

**Cyvl -- list pavement scores in a neighborhood:**
```json
{
  "project_id": "8d8f8cd6-f25a-470c-88fd-6b0e0ad4d1d7",
  "radius": { "lat": 42.300, "lng": -71.067, "meters": 300 }
}
```

**CKAN -- filter crashes by coordinates (TEXT columns, must CAST):**
```sql
SELECT * FROM "e4bfe397-6bfc-49c5-9367-c879fac7401d"
WHERE CAST(lat AS FLOAT) BETWEEN 42.28 AND 42.32
  AND CAST(long AS FLOAT) BETWEEN -71.09 AND -71.05
```

**CKAN -- 311 complaints by neighborhood name:**
```sql
SELECT case_title, COUNT(*) AS cnt
FROM "1a0b420d-99f1-4887-9851-990b2a5a6e17"
WHERE neighborhood = 'Dorchester'
GROUP BY case_title ORDER BY cnt DESC LIMIT 10
```

## Parameter Format Reminder

- **`search_imagery`**: flat params -- `lat=42.30, lon=-71.067, radius_m=300`
- **`list_*` tools**: nested object -- `radius={"lat": 42.30, "lng": -71.067, "meters": 300}`
- `search_imagery` uses `lon`; `list_*` tools use `lng`
