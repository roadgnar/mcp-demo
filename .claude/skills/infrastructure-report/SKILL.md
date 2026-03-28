---
name: infrastructure-report
description: Analyze infrastructure conditions for any supported city — data gathering and synthesis.
allowed-tools: mcp__claude_ai_Cyvl__*, mcp__claude_ai_Boston_CIO_MCP__*, mcp__boston__*, mcp__socrata__*, mcp__data-commons__*, Bash, Write, Read
argument-hint: [topic and area, e.g. "pavement conditions on Main Street"]
---

# Infrastructure Report Generator

Create stakeholder-ready reports combining Cyvl infrastructure data with open data sources. Works for any supported city.

## Workflow

0. **Determine city and available data sources.** Boston → boston MCP. NYC → socrata MCP. Any city → data-commons for demographic context (population, income). Cyvl → use `list_projects` to find the project ID for the target city.

1. **Gather data** from the appropriate MCPs based on the topic:
   - Pavement scores and distresses (Cyvl)
   - Crash records (boston MCP or socrata MCP depending on city)
   - 311 complaints (boston MCP or socrata MCP)
   - Active work zones (boston MCP or socrata MCP)
   - Street-level imagery (Cyvl search)
   - Demographic context — population, income (data-commons MCP)

2. **Structure the report:**
   - Executive summary (1-2 sentences)
   - Key findings with data tables
   - Street-level imagery as visual evidence
   - Cross-source correlations (e.g., crashes + pavement quality)
   - Prioritized recommendations

3. **Format for the audience:**
   - For mayors/elected officials: lead with impact numbers, photos, and recommendations
   - For DPW/operations: lead with specific streets, scores, and repair priorities
   - For budget office: lead with cost implications and ROI

## Quick Reference

**Boston (CKAN):**
| Dataset | Resource ID |
|---------|------------|
| Crashes | `e4bfe397-6bfc-49c5-9367-c879fac7401d` |
| 311 (2026) | `1a0b420d-99f1-4887-9851-990b2a5a6e17` |
| Work Zones | `36fcf981-e414-4891-93ea-f5905cec46fc` |

**NYC (Socrata):**
| Dataset | Dataset ID |
|---------|-----------|
| 311 Requests | `erm2-nwe9` |
| Motor Vehicle Collisions | `h9gi-nx95` |
| Housing Violations | `wvxf-dwi5` |

**Cyvl:**
| City | Project ID |
|------|-----------|
| Boston | `8d8f8cd6-f25a-470c-88fd-6b0e0ad4d1d7` |
