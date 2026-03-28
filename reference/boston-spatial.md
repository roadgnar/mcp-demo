# Boston Neighborhoods — Spatial Reference

Approximate center coordinates for Boston's 17 neighborhoods. Use with Cyvl spatial filters and CKAN lat/long queries.

## Neighborhood Centers

| Neighborhood | Lat | Lon | Notes |
|-------------|-----|-----|-------|
| Allston | 42.3539 | -71.1337 | Near Boston University |
| Back Bay | 42.3503 | -71.0810 | Copley Square area |
| Bay Village | 42.3497 | -71.0680 | Small, central |
| Beacon Hill | 42.3588 | -71.0707 | State House area |
| Brighton | 42.3464 | -71.1627 | Western Boston |
| Charlestown | 42.3782 | -71.0602 | North of downtown |
| Chinatown | 42.3513 | -71.0627 | Near downtown |
| Dorchester | 42.2998 | -71.0662 | Largest neighborhood by area |
| East Boston | 42.3702 | -71.0389 | Near Logan Airport |
| Fenway-Kenmore | 42.3467 | -71.0972 | Near Fenway Park |
| Hyde Park | 42.2565 | -71.1241 | Southern Boston |
| Jamaica Plain | 42.3097 | -71.1145 | Southwest Boston |
| Mattapan | 42.2768 | -71.0941 | Southern, near Dorchester |
| Mission Hill | 42.3299 | -71.1063 | Near medical area |
| North End | 42.3647 | -71.0542 | Historic waterfront |
| Roslindale | 42.2835 | -71.1268 | Southwest Boston |
| Roxbury | 42.3152 | -71.0886 | Central-south |
| South Boston | 42.3381 | -71.0476 | Waterfront, Seaport |
| South End | 42.3420 | -71.0710 | Central, near Back Bay |
| West End | 42.3634 | -71.0656 | Near TD Garden |
| West Roxbury | 42.2798 | -71.1581 | Southwestern tip |

## Key Corridors

| Corridor | Neighborhoods | Approximate Bbox |
|----------|--------------|------------------|
| Blue Hill Ave | Dorchester, Roxbury, Mattapan | `[-71.095, 42.270, -71.075, 42.320]` |
| Washington St | Roxbury, South End, Dorchester | `[-71.095, 42.290, -71.065, 42.345]` |
| Commonwealth Ave | Allston, Brighton, Back Bay | `[-71.170, 42.345, -71.070, 42.355]` |
| Dorchester Ave | Dorchester, South Boston | `[-71.065, 42.280, -71.045, 42.345]` |

## Usage

**Cyvl radius query:**
```json
{"radius": {"lat": 42.2998, "lng": -71.0662, "meters": 500}}
```

**CKAN spatial filter:**
```sql
WHERE CAST(lat AS FLOAT) BETWEEN 42.290 AND 42.310
  AND CAST(long AS FLOAT) BETWEEN -71.080 AND -71.050
```

**Cyvl bbox query:**
```json
{"bbox": [-71.095, 42.270, -71.075, 42.320]}
```
