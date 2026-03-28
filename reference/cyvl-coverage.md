# Cyvl Imagery Coverage Registry

Current status of street-level AI imagery search across cities.

## Coverage Table

| City | Status | Embedded Images | Project ID | Fallback |
|------|--------|----------------|------------|----------|
| Boston | Production | 237K+ | `8d8f8cd6-f25a-470c-88fd-6b0e0ad4d1d7` | N/A |
| NYC | POC Stage 4/8 | 0 (pipeline) | TBD | Socrata 311 (`erm2-nwe9`) |
| Somerville | POC | 0 | TBD | Boston open data |
| Atlanta | POC Stage 4/8 | 0 | TBD | Socrata |
| San Francisco | POC Stage 4/8 | 0 | TBD | Socrata (`data.sfgov.org`) |
| Miami | POC Stage 4/8 | 0 | TBD | Socrata |
| Dallas | POC Stage 4/8 | 0 | TBD | Socrata |
| Indianapolis | POC Stage 4/8 | 0 | TBD | Socrata |

## POC Stages Explained

The pipeline from raw street scans to searchable imagery has 8 stages:

1. Contract signed
2. Scans collected
3. Scans uploaded
4. Images cataloged and descriptions generated
5. Embeddings computed
6. Embeddings indexed for search
7. Quality validation
8. Production release

**Stage 4/8** means scans have been discovered, images cataloged, and descriptions are ready, but the images are NOT yet embedded for semantic search. The `/see` skill cannot return photos until stage 6+.

## How to Check Live Coverage

Call `list_projects(has_embeddings=true)` via the Cyvl MCP. Only projects returned by this call support imagery search.

## Fallback Behavior (used by /see skill)

When a city lacks Cyvl imagery, the skill uses tiered fallbacks:

1. **Socrata 311 data** — many complaint categories include location details and photos (NYC, Chicago, SF, Seattle, LA)
2. **Boston open data** — for Boston-area cities without their own Cyvl project
3. **Data Commons** — demographic context only, no imagery

The fallback is always disclosed to the user — never presented as if it were street-level imagery.
