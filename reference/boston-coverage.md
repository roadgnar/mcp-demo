# Boston Cyvl Imagery Coverage

## Active Projects

| Area | Project ID | Coverage |
|------|-----------|----------|
| Boston (full city) | `8d8f8cd6-f25a-470c-88fd-6b0e0ad4d1d7` | 237K+ images, all 17 neighborhoods |
| Somerville | `090e18f2-0002-4a70-90b4-8f073d26294d` | Adjacent city, separate project |

## Notes

- The Boston full-city project covers every neighborhood from Downtown to Hyde Park.
- Somerville is a separate municipality but shares borders with Charlestown and Cambridge.
- Use `list_projects(has_embeddings=true)` to confirm project access.
- Use `get_project_overview(project_id)` for coverage area, miles surveyed, and asset counts.

## Discovery

```
list_projects(has_embeddings=true)
```

Returns all projects with searchable imagery. Both Boston and Somerville have full embeddings enabled.
