# Sidewalk & Curb Management Prompts

Boston has old sidewalk geometry data (2011) but NO condition assessment. Cyvl's imagery search fills this gap — you can inventory sidewalk conditions from existing street-level photos.

## Sidewalk Condition Assessment

> Does Boston have a sidewalk dataset? If not, use Cyvl imagery search to find cracked sidewalks across the city.

> Search for "damaged sidewalks with trip hazards" in Dorchester. How many did you find?

> Find sidewalks with tree root damage — trees pushing up through the concrete.

## ADA Compliance

> Search for "ADA ramps and curb cuts" in Downtown Boston. Show me images.

> Find intersections that appear to be missing curb ramps.

> Search for "wheelchair ramps in poor condition" — broken or non-standard ramps.

## Curb Inventory

> Search for "loading zones" in the Back Bay area.

> Find "bike lane markings near intersections" — are there conflicts between bike lanes and loading zones?

> Search for "fire hydrant blocked by parked cars" — curb access issues.

## Accessibility Obstructions

> Search for "narrow sidewalk blocked by utility pole" in Boston. Show me 3 images.

(High confidence — utility poles are concrete objects that photograph well. Expect many results.)

> Search for "wheelchair accessible ramp with tactile paving" across Boston.

(Specific compound queries like this often outperform generic terms like "ADA ramps".)

## Cross-Source Sidewalk Analysis

> Search 311 for sidewalk-related complaints. Then use Cyvl imagery to show visual evidence of the reported problems.

(The legacy 311 dataset includes `'Sidewalk Repair (Make Safe)'` and `'Unshoveled Sidewalk'` in the `case_title` field — filter with `case_title ILIKE '%sidewalk%'`. Always use `execute_sql`, not `query_data`.)

> Find neighborhoods with the most sidewalk 311 complaints but no corresponding repair work orders.

## Tips

- Sidewalk imagery is captured as part of street-level scans — sidewalks are visible in the foreground of most images
- Compound queries like "cracked sidewalks and damaged curbs" return high-confidence results across Boston
- Specific ADA queries ("wheelchair accessible ramp with tactile paving") outperform generic ones ("ADA ramps")
- Combine with 311 data: filter `case_title ILIKE '%sidewalk%'` to find condition-related complaints (always use `execute_sql`)
- Boston HAS "Sidewalk Centerline" and "Sidewalk Inventory" datasets but they're from 2011 with geometry only — frame the gap as "location data exists, condition data doesn't"
