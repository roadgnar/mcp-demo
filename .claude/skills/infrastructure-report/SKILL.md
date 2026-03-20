---
name: infrastructure-report
description: Analyze infrastructure conditions for a specific area — data gathering and synthesis, no file output. Use when the user asks to analyze, assess, or investigate conditions.
allowed-tools: mcp__claude_ai_Cyvl__*, mcp__claude_ai_Boston_CIO_MCP__*, mcp__boston__*, Bash, Write, Read
argument-hint: [topic and area, e.g. "pavement conditions on Main Street"]
---

# Infrastructure Report Generator

Create stakeholder-ready reports combining Cyvl infrastructure data with open data sources.

## Workflow

1. **Gather data** from both MCPs based on the topic:
   - Pavement scores and distresses (Cyvl)
   - Crash records (Boston CKAN Vision Zero)
   - 311 complaints (Boston CKAN)
   - Active work zones (Boston CKAN)
   - Street-level imagery (Cyvl search)

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

## Key Resource IDs (Boston)
- Crashes: `e4bfe397-6bfc-49c5-9367-c879fac7401d`
- 311 (2026): `1a0b420d-99f1-4887-9851-990b2a5a6e17`
- Work zones: `36fcf981-e414-4891-93ea-f5905cec46fc`
- Cyvl project: `8d8f8cd6-f25a-470c-88fd-6b0e0ad4d1d7`
