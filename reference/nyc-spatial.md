# NYC Spatial Reference

## Borough Centers

| Borough | Lat | Lon | Notes |
|---------|-----|-----|-------|
| Manhattan | 40.7831 | -73.9712 | Midtown reference point |
| Brooklyn | 40.6782 | -73.9442 | Downtown Brooklyn |
| Queens | 40.7282 | -73.7949 | Geographic center |
| Bronx | 40.8448 | -73.8648 | Central Bronx |
| Staten Island | 40.5795 | -74.1502 | Central SI |

## Queens Neighborhoods (Cyvl Coverage Areas)

| Neighborhood | Lat | Lon | Radius (m) | Cyvl Project |
|-------------|-----|-----|------------|--------------|
| Jackson Heights | 40.7557 | -73.8831 | 800 | `1924f65d-...` |
| Long Island City | 40.7425 | -73.9580 | 800 | `5be713ea-...` |
| Jamaica | 40.7028 | -73.7890 | 1000 | `e57afa42-...` |

## Queens Zip Codes (Common)

| Zip | Neighborhood |
|-----|-------------|
| 11101, 11109 | Long Island City |
| 11372, 11373 | Jackson Heights |
| 11432, 11433, 11434, 11435 | Jamaica |
| 11368, 11369 | East Elmhurst / Corona |
| 11370 | East Elmhurst |

## Socrata Spatial Queries

Use `within_circle()` for location-based filtering on datasets with a `location` column:

```
WHERE within_circle(location, 40.7557, -73.8831, 1000)
```

Parameters: `(location_column, latitude, longitude, radius_in_meters)`

**Jackson Heights example (311):**
```
SELECT complaint_type, COUNT(*) AS cnt
WHERE within_circle(location, 40.7557, -73.8831, 1000)
  AND created_date > '2026-01-01'
GROUP BY complaint_type
ORDER BY cnt DESC
LIMIT 10
```

## Cyvl Spatial Queries

Cyvl `list_*` tools use `radius` (object) or `bbox` (array):

```json
{"radius": {"lat": 40.7557, "lng": -73.8831, "meters": 500}}
```

Cyvl `search_imagery` uses flat parameters:

```
search_imagery(query="...", project_id="1924f65d-...", lat=40.7557, lon=-73.8831, radius_m=500)
```

Note the parameter name difference: `lng` for `list_*` tools, `lon` for `search_imagery`.
