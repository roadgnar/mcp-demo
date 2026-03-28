# NYC Spatial Reference

## Borough Centers

| Borough | Lat | Lon |
|---------|-----|-----|
| Manhattan | 40.7831 | -73.9712 |
| Brooklyn | 40.6782 | -73.9442 |
| Queens | 40.7282 | -73.7949 |
| Bronx | 40.8448 | -73.8648 |
| Staten Island | 40.5795 | -74.1502 |

## Queens Neighborhood Centers (Cyvl Coverage)

| Neighborhood | Lat | Lon | Cyvl Project ID |
|-------------|-----|-----|-----------------|
| Jackson Heights | 40.7557 | -73.8831 | `1924f65d-01b6-4170-b0b8-ddf6a887b6e5` |
| Long Island City | 40.7425 | -73.9235 | `5be713ea-d739-4ecc-876d-ccadbe57c04b` |
| Jamaica | 40.7029 | -73.7898 | `e57afa42-1052-4313-a26b-8df6e3154a58` |

## Cyvl Spatial Queries

Use `radius` for neighborhood-level queries (recommended):

```json
{
  "radius": {
    "lat": 40.7557,
    "lng": -73.8831,
    "meters": 500
  }
}
```

## Socrata within_circle() Queries

For datasets with `latitude` and `longitude` columns, use SoQL spatial filtering:

**311 complaints near Jackson Heights:**
```
SELECT complaint_type, count(*) as cnt
WHERE within_circle(location, 40.7557, -73.8831, 1000)
  AND created_date > '2026-01-01'
GROUP BY complaint_type ORDER BY cnt DESC LIMIT 10
```

**311 complaints near LIC:**
```
SELECT complaint_type, count(*) as cnt
WHERE within_circle(location, 40.7425, -73.9235, 1000)
  AND created_date > '2026-01-01'
GROUP BY complaint_type ORDER BY cnt DESC LIMIT 10
```

**311 complaints near Jamaica:**
```
SELECT complaint_type, count(*) as cnt
WHERE within_circle(location, 40.7029, -73.7898, 1000)
  AND created_date > '2026-01-01'
GROUP BY complaint_type ORDER BY cnt DESC LIMIT 10
```

**Note:** `within_circle()` takes `(location_column, lat, lon, radius_in_meters)`. The `location` column must be a Socrata Point type -- not all datasets have it. For datasets with separate `latitude`/`longitude` text columns, filter with `BETWEEN` instead.
