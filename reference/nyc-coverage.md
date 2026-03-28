# NYC Cyvl Coverage

## Active Projects

| Area | Project ID | Status |
|------|-----------|--------|
| Jackson Heights, Queens | `1924f65d-01b6-4170-b0b8-ddf6a887b6e5` | Full coverage |
| Long Island City, Queens | `5be713ea-d739-4ecc-876d-ccadbe57c04b` | Full coverage |
| Jamaica, Queens | `e57afa42-1052-4313-a26b-8df6e3154a58` | Full coverage |
| Manhattan Pilot | `8cb1a9f3-f2ac-4de9-ad00-b8187db3e63f` | Partial coverage |

All projects are under the **nycsod** organization in Cyvl.

## Demo Recommendations

**Use Queens for demos.** Jackson Heights, LIC, and Jamaica have full coverage with imagery embeddings, pavement scores, and distress data. All three are in the same borough, making cross-neighborhood comparisons easy.

**Manhattan Pilot is partial.** Use it as a bonus comparison (Queens vs Manhattan) but do not rely on it as a primary demo area. Coverage gaps will produce sparse results for some queries.

## Discovery

Use `list_projects(has_embeddings=true)` to confirm project access.
Use `get_project_overview(project_id)` for coverage area, miles surveyed, and asset counts.
