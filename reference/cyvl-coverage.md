# Cyvl Imagery Coverage

## Active Projects

### Boston Metro

| Area | Project ID |
|------|-----------|
| Boston (full city, 237K+ images) | `8d8f8cd6-f25a-470c-88fd-6b0e0ad4d1d7` |
| Somerville | `090e18f2-0002-4a70-90b4-8f073d26294d` |

### NYC

| Area | Project ID |
|------|-----------|
| Jackson Heights, Queens | `1924f65d-01b6-4170-b0b8-ddf6a887b6e5` |
| Long Island City, Queens | `5be713ea-d739-4ecc-876d-ccadbe57c04b` |
| Jamaica, Queens | `e57afa42-1052-4313-a26b-8df6e3154a58` |
| Manhattan Pilot (partial) | `8cb1a9f3-f2ac-4de9-ad00-b8187db3e63f` |

**Note:** Manhattan Pilot has partial coverage. For demos, prefer Jackson Heights, LIC, or Jamaica.

## Discovery

Use `list_projects(has_embeddings=true)` to find projects with searchable imagery.
Use `get_project_overview(project_id)` for coverage area, miles surveyed, and asset counts.

## City Branches

- `boston` branch: Boston metro coverage + Somerville
- `nyc` branch: Queens + Manhattan Pilot coverage
