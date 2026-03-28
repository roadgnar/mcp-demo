# Imagery Search Prompts

Natural language search over 237K street-level images. No pre-trained model needed — works for any object visible in the imagery.

## Basic Object Search

> Search for fire hydrants in Queens — how many can you find? Show me 3 images.

(High confidence — concrete, well-defined objects like hydrants return the most reliable results.)

> Find all blue bike docking stations

(Good confidence — distinctive objects with clear visual features.)

> Show me fire hydrants near Jackson Heights

## Ad-Hoc Discovery (Things NOT in Structured Data)

> Search for construction sites with heavy machinery

> Find dumpsters on residential streets

> Show me art murals and street art in Queens

> Find food trucks

## Infrastructure Conditions

> Search for cracked sidewalks and damaged curbs

> Find roads with visible potholes

> Show me faded crosswalk markings

> Find missing or damaged guardrails

## Compound Queries (Object + Location + Condition)

> Search for cracked sidewalks near schools in Jamaica, Queens

> Find damaged road surfaces near intersections with high pedestrian traffic

> Show me bus stops that appear to be in poor condition

## Fun / Memorable (Great for Live Demos)

> Find dogs in Queens

(High volume, fun reaction — but confidence is moderate since dogs are varied and small in frame.)

> Search for graffiti in Queens

(Surprising results — abstract concepts like graffiti work better than expected.)

> Find American flags

(Crowd-pleasing — distinct visual object with strong color signal.)

## Tips

- **Start with `output="metadata"`** to see how many results you get, then switch to `output="image_content"` with `page_size=3` to view photos
- **Concrete nouns** work best: "fire hydrants" > "red things"
- **Add qualifiers** for precision: "cracked sidewalks near schools" > "bad sidewalks"
- **Confidence >= 80%** = high reliability; **60-79%** = verify visually
- **Use spatial filters** (lat/lon + radius_m) to narrow to a neighborhood
- Results include `detected_objects`, `pci_score`, and `distress_types` metadata alongside imagery
