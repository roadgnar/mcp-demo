# Boston Branch Setup

This branch adds Boston-specific demos, datasets, and prompts on top of the base environment. Follow [SETUP.md](SETUP.md) first — API keys and MCP server configuration carry over from `main`.

## Boston Cyvl Projects

| Area | Project ID | Coverage |
|------|-----------|----------|
| Boston (full city) | `8d8f8cd6-f25a-470c-88fd-6b0e0ad4d1d7` | 237K+ street-level images |
| Somerville | `090e18f2-0002-4a70-90b4-8f073d26294d` | Adjacent city |

Use `list_projects(has_embeddings=true)` to confirm access. Both projects support natural language imagery search.

## Boston CKAN (No Key Needed)

The Boston Open Data MCP (`boston`) connects to data.boston.gov automatically. No API key required. See `reference/boston-datasets.md` for the full dataset directory with resource IDs.

## Data Commons DCID

Boston's Data Commons identifier: `geoId/2507000`

Use with `get_observations(variable_dcid, "geoId/2507000", "latest")` for population, income, housing, and other Census-sourced statistics.

## Verification

### Option A: Claude Desktop (Cowork)

1. Open Claude Desktop
2. Start a **Cowork** session scoped to the **mcp-demo** repo
3. Verify scope — you should see `CLAUDE.md` referenced in the session
4. Open the **MCP connectors** panel (plug icon)
5. Confirm **Socrata**, **Data Commons**, and **Boston CKAN** are connected
6. Connect **Cyvl** via OAuth if not already connected

### Option B: Claude Code (Terminal)

```bash
cd mcp-demo
claude
```

Run `/mcp` to verify all four servers are connected. Connect Cyvl via OAuth if needed.

### Test Prompts

**Cyvl imagery:**

> Search for fire hydrants in Boston and show me 3 images

**Expected:** Street-level photos with GPS coordinates and confidence scores from the Boston project (`8d8f8cd6`).

**Boston CKAN:**

> How many pedestrian crashes has Boston had this year?

**Expected:** A count from the Vision Zero crash dataset (`e4bfe397`), filtered to `mode_type = 'ped'`.

**Data Commons:**

> What is the population of Boston?

**Expected:** ~650K (Census) with source citation, using DCID `geoId/2507000`.

**Cross-MCP:**

> Show me pavement conditions and crash data near Blue Hill Ave in Dorchester

**Expected:** Cyvl returns pavement scores and distress data; Boston CKAN returns crash records filtered by street name `'BLUE HILL AVE'`. Both sources cited independently.

## Branch Contents

| File | Purpose |
|------|---------|
| `EXAMPLES-BOSTON.md` | 4-part guided demo with prompts and expected results |
| `reference/boston-coverage.md` | Project and MCP coverage summary |
| `reference/boston-datasets.md` | 7 CKAN datasets with resource IDs and schemas |
| `reference/boston-spatial.md` | 17 neighborhood coordinates for spatial queries |
| `prompts/boston-infrastructure.md` | Boston-specific infrastructure analysis prompts |

## Troubleshooting

| Problem | Fix |
|---------|-----|
| Cyvl returns no Boston results | Verify project access with `list_projects` — you need `8d8f8cd6` in the list |
| Boston CKAN SQL errors | Always call `get_schema` before querying — column names are case-sensitive |
| Crash queries return empty | Street names are UPPERCASE (`'BLUE HILL AVE'`), lat/long are TEXT (must CAST) |
| 311 pothole data missing | Only in legacy dataset (`1a0b420d`), not the new system (`254adca6`) |
