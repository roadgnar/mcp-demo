# MCP Demo — Boston Infrastructure Intelligence

Explore Boston's infrastructure through two MCP servers working together in Claude Code. Search 237K street-level images by natural language, query crash records, 311 complaints, pavement conditions, and construction data — then combine them for insights no single source can provide.

## Prerequisites

- **Claude account**: Pro, Max, Teams, or Enterprise (free plan does not include Claude Code)
- **Claude Code**: Installed and authenticated (see [Install Claude Code](#install-claude-code) below)

## Install Claude Code

### macOS (13.0+)

```bash
# Recommended (auto-updates)
curl -fsSL https://claude.ai/install.sh | bash

# Or via Homebrew (manual updates)
brew install --cask claude-code
```

### Linux (Ubuntu 20.04+ / Debian 10+)

```bash
curl -fsSL https://claude.ai/install.sh | bash
```

### Windows (10 1809+)

**Prerequisite:** Install [Git for Windows](https://git-scm.com/downloads/win) first.

```powershell
# PowerShell
irm https://claude.ai/install.ps1 | iex

# Or via WinGet
winget install Anthropic.ClaudeCode
```

### WSL

Install inside your WSL distro using the Linux command above.

### Verify

```bash
claude --version
```

### First-time authentication

Run `claude` — a browser window opens for OAuth login. Log in with your Claude account.

## Quick Start

```bash
# 1. Clone the repo
git clone <repo-url>
cd mcp-demo

# 2. Open Claude Code
claude

# 3. Connect the Cyvl MCP (one-time)
/mcp
# Click "Cyvl" → follow the OAuth prompt → authenticate
```

The **Boston Open Data MCP** auto-connects via `.mcp.json` — no auth needed (public data).

Once both servers show as connected, you're ready:

```
Search for "fire hydrants" in Boston and show me 3 images
```

## What's In This Repo

| File | Purpose | When It's Used |
|------|---------|---------------|
| `CLAUDE.md` | General-purpose tool guide — describes both MCPs, datasets, SQL gotchas, spatial queries, error handling | Auto-loaded every session |
| `.mcp.json` | Connects the Boston Open Data MCP automatically | Auto-loaded every session |
| `.claude/settings.json` | Pre-approves MCP tool permissions (no popups) | Auto-loaded every session |
| `.claude/skills/` | 5 reusable workflows invoked via `/` commands | On demand |
| `FOLLOW-ALONG.md` | Step-by-step demo walkthrough with copy-paste prompts and expected results | Read when running the demo |
| `prompts/` | Prompt recipe collections organized by use case | Reference |
| `reference/` | Tool docs, dataset schemas, spatial filter examples, neighborhood coordinates | Reference |

### The separation

- **`CLAUDE.md`** teaches Claude how to use the tools. It's general-purpose — works for any infrastructure question, not just the demo script.
- **`FOLLOW-ALONG.md`** is the demo walkthrough. It has specific prompts, expected result counts, and notes about what to look for. Follow it step by step.
- **Skills** are reusable workflows. Type `/` in Claude Code to see them.

## Available Skills

| Skill | What It Does |
|-------|-------------|
| `/search-imagery` | Search street-level photos by natural language |
| `/crash-analysis` | Cross-MCP crash + pavement correlation |
| `/sidewalk-audit` | Inventory sidewalks/curbs from imagery |
| `/infrastructure-report` | Generate stakeholder-ready reports |
| `/explore-dataset` | Browse and query Boston open data |

## Running the Demo

Open `FOLLOW-ALONG.md` and work through it section by section. Each part has:
- A prompt you can copy-paste into Claude Code
- Expected results so you know what to look for
- Notes on what makes the result interesting

The demo covers:
1. **Imagery Search** — find fire hydrants, crosswalk markings, construction sites, dogs
2. **Pavement Conditions** — worst streets downtown, distress details
3. **Crash Records** — most dangerous streets, mode breakdowns
4. **Cross-MCP Analysis** — crashes + pavement together
5. **Sidewalk Data Gap** — no condition data exists; imagery fills it
6. **Deliverable Generation** — turn analysis into a report

### Pre-demo warmup

The first Cyvl MCP call in a session can take 5-10 seconds (cold start). Run one search before presenting:

```
Search for "fire hydrants" in the Boston project. How many did you find?
```

Subsequent calls are fast.

## Example Prompts

Beyond the demo script, try anything:

```
What are the most dangerous intersections in Boston?
```

```
Does Boston have a sidewalk condition dataset? If not, find cracked sidewalks from imagery.
```

```
Compare construction activity between South End and Dorchester.
```

```
Make me a report about pavement conditions on Washington Street with street-level photos.
```

See `prompts/` for more organized by use case.

## Troubleshooting

| Problem | Fix |
|---------|-----|
| Cyvl MCP not connected | Run `/mcp` inside Claude Code, click Cyvl, complete OAuth |
| Boston MCP not connected | Check `.mcp.json` is present. Run `/mcp` to verify. Ensure `npx` is available (comes with Node.js). |
| 502 Bad Gateway on Cyvl call | Retry once — these are transient proxy errors that resolve immediately |
| `list_distresses` times out | Reduce radius to 100m, or use `search_imagery` instead (never times out) |
| SQL column name error | Column names are case-sensitive on some datasets. Always check schema first. |
| No results from 311 pothole query | Use the legacy 311 dataset (`1a0b420d-...`), not the New System one |

## Repo Structure

```
mcp-demo/
├── CLAUDE.md                          # Auto-loaded: tool guide for both MCPs
├── .mcp.json                          # Auto-loaded: Boston Open Data MCP connection
├── .claude/
│   ├── settings.json                  # Auto-loaded: pre-approved permissions
│   └── skills/
│       ├── search-imagery/SKILL.md    # /search-imagery
│       ├── crash-analysis/SKILL.md    # /crash-analysis
│       ├── sidewalk-audit/SKILL.md    # /sidewalk-audit
│       ├── infrastructure-report/SKILL.md
│       └── explore-dataset/SKILL.md   # /explore-dataset
├── FOLLOW-ALONG.md                    # Step-by-step demo walkthrough
├── prompts/                           # Prompt recipe collections
│   ├── imagery-search.md
│   ├── cross-mcp-analysis.md
│   ├── sidewalk-curb.md
│   ├── construction.md
│   └── deliverables.md
└── reference/                         # Quick-reference docs
    ├── cyvl-mcp-tools.md
    ├── boston-datasets.md
    └── spatial-filters.md
```

## Resources

- [Claude Code Setup Guide](https://code.claude.com/docs/en/setup)
- [Claude Code MCP Docs](https://code.claude.com/docs/en/mcp)
- [Cyvl MCP Documentation](https://i3.cyvl.dev/docs)
- [Boston Open Data Portal](https://data.boston.gov)
- [MCP Best Practices (Anthropic)](https://www.anthropic.com/engineering/writing-tools-for-agents)
