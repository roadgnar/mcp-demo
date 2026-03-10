# Model Evaluation Results

Systematic comparison of LLM performance on civic data queries via the Socrata MCP server.

Evaluation date: 2026-03-10
Methodology: [eval-queries.md](eval-queries.md)
Script: `civic-ai-tools-website/scripts/eval-models.mjs`
Raw data: `civic-ai-tools-website/scripts/eval-results-2026-03-10.json`

---

## Status: PENDING

This document is a template. Results will be populated after running the evaluation script:

```bash
cd civic-ai-tools-website
OPENROUTER_API_KEY=sk-or-... node scripts/eval-models.mjs
```

The eval script tests 15 queries × 5 models = 75 runs, outputting raw results to JSON. Each response then requires manual scoring using the rubric in eval-queries.md.

---

## Results Template

### Summary Table

| Model | Quality Score | Efficiency Score | Overall Score | Avg Tokens | Avg Latency | Recommended? |
|-------|-------------|-----------------|---------------|-----------|-------------|-------------|
| Claude Sonnet 4 | _/5 | _/5 | _/5 | — | — | |
| GPT-4o | _/5 | _/5 | _/5 | — | — | |
| Claude Haiku 4.5 | _/5 | _/5 | _/5 | — | — | |
| GPT-4o Mini | _/5 | _/5 | _/5 | — | — | |
| Gemini 2.0 Flash | _/5 | _/5 | _/5 | — | — | |

### Detailed Scores by Query

_To be filled in after manual review of eval-results JSON._

| Query | Model | Dataset Selection | SoQL Correctness | Guidance Adherence | Interpretation | Cost | Latency |
|-------|-------|-------------------|------------------|--------------------|----------------|------|---------|
| Q1 | Claude Sonnet 4 | | | | | | |
| ... | ... | | | | | | |

### Key Findings

_To be written after scoring._

1. **Recommended default model**: TBD
2. **Recommended budget model**: TBD
3. **Models to add**: TBD
4. **Models to remove**: TBD
5. **Token budget adjustments**: TBD

### Observations

_Notes from manual review:_

- **SoQL generation quality**: Which models generate the cleanest SoQL?
- **Tool use patterns**: Do some models make more tool calls than necessary?
- **Guidance adherence**: Which models follow date range, clarification, and case-sensitivity rules best?
- **Edge case handling**: How do models handle zero results, ambiguous queries, pagination?
- **Cost vs. quality tradeoff**: Is the cheapest model good enough for a public demo?

---

## Changes to Apply

After analysis, update `civic-ai-tools-website/src/lib/mcp/tools.ts`:

1. Reorder models by recommendation
2. Update descriptions to reflect actual performance
3. Adjust `maxTokenBudget` values based on observed usage patterns
4. Add/remove models based on findings

---

*Last updated: 2026-03-10 (template created, awaiting eval run)*
