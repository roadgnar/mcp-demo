# NYC Cyvl Coverage

Four projects cover NYC. Three are in Queens (full coverage), one is a partial Manhattan pilot.

| Area | Project ID | Borough | Coverage |
|------|-----------|---------|----------|
| Jackson Heights | `1924f65d-01b6-4170-b0b8-ddf6a887b6e5` | Queens | Full |
| Long Island City (LIC) | `5be713ea-d739-4ecc-876d-ccadbe57c04b` | Queens | Full |
| Jamaica | `e57afa42-1052-4313-a26b-8df6e3154a58` | Queens | Full |
| Manhattan Pilot | `8cb1a9f3-f2ac-4de9-ad00-b8187db3e63f` | Manhattan | **Partial** |

## Demo Guidance

- **Always prefer Queens projects** for demos -- full coverage, reliable results
- Manhattan Pilot has gaps; queries may return sparse or empty results
- Use `list_projects(has_embeddings=true)` to confirm access
- Use `get_project_overview(project_id)` for coverage stats (miles surveyed, asset counts)

## NYC School of Data (nycsod)

These projects were surveyed in collaboration with NYC School of Data. The imagery powers community-driven infrastructure analysis and data literacy workshops.
