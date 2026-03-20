# Tool Generation Prompts

Claude Code can build working interactive tools from natural language. This is the "MCP as a platform" capability — showing that an AI agent can create custom applications on demand using the infrastructure data.

## Compliance & Inspection Tools

> Build me an interactive tool that shows ADA ramps from Cyvl imagery one by one. For each image, let me mark it as "compliant" or "non-compliant" with a note. After reviewing all images, generate a summary with the compliance rate.

> Create a sign condition checker — show me stop signs one at a time from imagery, let me rate each as good/damaged/missing, and export results as CSV.

## Triage & Prioritization Tools

> Build a pothole triage tool: pull the top 20 pothole complaints from 311, show me street-level imagery for each location, and let me assign priority (urgent/medium/low). Export the prioritized list.

> Create a repair prioritizer that combines crash data and pavement scores for the 10 worst streets, lets me adjust priorities, and generates a funding request document.

## Field Survey Tools

> Build a tool that lets me do a virtual street survey — show me every image along a specific street, let me tag issues I see (crack, pothole, missing sign, accessibility problem), and compile everything into a survey report.

> Create a before/after comparison tool — given two scan dates for the same street, show side-by-side imagery so I can assess whether repairs were completed.

## Tips

- Tool generation works best when you describe the workflow (input → interaction → output)
- Claude builds these as interactive terminal applications — they work in Claude Code
- The tools use live MCP data — they're not mockups
- Combine with `/generate-report` to turn tool outputs into shareable documents
