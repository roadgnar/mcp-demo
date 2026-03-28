# Civic AI Tools — Setup Guide

Add NYC Open Data (Socrata) and Google Data Commons MCP servers to this workspace, alongside the existing Boston Open Data MCP.

## What You Get

After setup, you have **three MCP servers** available in Claude Code, Cursor, and Claude Desktop:

| Server | Data Source | Transport | Auth |
|--------|------------|-----------|------|
| `boston` | Boston Open Data (data.boston.gov, CKAN) | Remote HTTP | None |
| `socrata` | NYC Open Data + 4 other cities (Socrata) | Local stdio | Optional `SOCRATA_APP_TOKEN` |
| `data-commons` | Google Data Commons (Census, UN, WHO, CDC) | Local stdio | Required `DC_API_KEY` |

This means you can compare civic data across Boston, NYC, Chicago, SF, Seattle, and LA in a single conversation, plus pull in demographic/statistical data from Data Commons for any US location.

## Prerequisites

| Tool | Version | Check | Install |
|------|---------|-------|---------|
| Node.js | 18+ | `node -v` | [nodejs.org](https://nodejs.org/) |
| npm | 8+ | `npm -v` | Comes with Node.js |
| Python | 3.11+ | `python3 --version` | [python.org](https://python.org/) |
| git | any | `git --version` | `apt install git` / `brew install git` |
| uv | any (recommended) | `uv --version` | `curl -LsSf https://astral.sh/uv/install.sh \| sh` |

> **Note**: `uv` is optional but recommended. The setup script falls back to `pip3` if `uv` isn't available.

## Quick Start

```bash
# 1. Get your API keys (free, takes 2 minutes)
#    Socrata:      https://data.cityofnewyork.us/profile/edit/developer_settings
#    Data Commons: https://apikeys.datacommons.org/

# 2. Add keys to .env.local
cp .env.local.example .env.local
# Edit .env.local — paste your keys

# 3. Run setup
./scripts/setup-civic.sh

# 4. Use it
claude                    # Claude Code
# or open in Cursor       # Cursor auto-loads .cursor/mcp.json
```

## What the Setup Script Does

The script is **idempotent** — safe to run multiple times. It skips steps already completed.

### Step 1: Check Prerequisites

Verifies Node.js 18+, npm, git, Python 3.11+, and uv/pip3 are installed. Exits with clear error messages if anything is missing.

### Step 2: Clone & Build Socrata MCP Server

```
.mcp-servers/
└── socrata-mcp-server/      ← Cloned from GitHub
    ├── src/                  ← TypeScript source
    ├── dist/
    │   └── index.js          ← Built entry point (what MCP runs)
    └── node_modules/         ← Dependencies
```

- Shallow-clones [npstorey/socrata-mcp-server](https://github.com/npstorey/socrata-mcp-server)
- Runs `npm install` + `npm run build` to compile TypeScript
- Result: `.mcp-servers/socrata-mcp-server/dist/index.js`

### Step 3: Install Data Commons MCP

- Installs `datacommons-mcp` Python package via `uv tool install` (preferred) or `pip3 install`
- Verifies the `datacommons-mcp` command is available in `$PATH`
- Result: executable at `~/.local/bin/datacommons-mcp` (typical)

### Step 4: Load API Keys

Reads `SOCRATA_APP_TOKEN` and `DC_API_KEY` from `.env.local`. Warns if either is missing.

### Step 5: Generate MCP Configurations

Creates two config files with API keys and paths baked in:

| File | For | Path Type |
|------|-----|-----------|
| `.mcp.json` | Claude Code | Relative (runs from project dir) |
| `.cursor/mcp.json` | Cursor | Absolute (Cursor requirement) |

Both files are **gitignored** because they contain API keys.

### Step 6: Print Summary

Shows status of all three servers, lists generated files, and prints the Claude Desktop config snippet for manual addition.

## Platform-Specific Setup

### Claude Code (CLI)

Automatic. After running `setup-civic.sh`:

```bash
cd mcp-demo
claude
```

Claude Code reads `.mcp.json` from the project root. All three servers connect automatically. Permissions are pre-approved in `.claude/settings.json`.

### Cursor

Automatic. After running `setup-civic.sh`:

1. Open the `mcp-demo` folder in Cursor
2. Cursor reads `.cursor/mcp.json` and connects all three servers
3. Use Composer or Chat to query data

**Important**: Cursor requires **absolute paths**. The setup script handles this — don't edit `.cursor/mcp.json` paths manually.

### Claude Desktop

Manual. Claude Desktop uses a single global config file, not per-project configs.

**Config file location:**

| OS | Path |
|----|------|
| Linux | `~/.config/Claude/claude_desktop_config.json` |
| macOS | `~/Library/Application Support/Claude/claude_desktop_config.json` |
| Windows | `%APPDATA%\Claude\claude_desktop_config.json` |

**Steps:**

1. Run `./scripts/setup-civic.sh` — the script prints the exact JSON to add
2. Open the config file
3. Merge the `socrata` and `data-commons` entries into your existing `mcpServers` object
4. **Fully quit Claude Desktop** (not just close the window)
5. Reopen Claude Desktop

**Example merged config (Linux):**

```json
{
  "mcpServers": {
    "boston": {
      "command": "npx",
      "args": ["-y", "mcp-remote", "https://vgcpuua1ua.execute-api.us-east-1.amazonaws.com/staging/mcp"]
    },
    "socrata": {
      "command": "node",
      "args": ["/home/phi/Documents/GitHub/mcp-demo/.mcp-servers/socrata-mcp-server/dist/index.js", "--stdio"],
      "env": {
        "DEFAULT_DOMAIN": "data.cityofnewyork.us",
        "SOCRATA_APP_TOKEN": "your-token-here",
        "CACHE_ENABLED": "true",
        "LOG_LEVEL": "info"
      }
    },
    "data-commons": {
      "command": "/home/phi/.local/bin/datacommons-mcp",
      "args": ["serve", "--skip-api-key-validation", "stdio"],
      "env": {
        "DC_API_KEY": "your-key-here"
      }
    }
  }
}
```

**Notes:**
- All paths must be **absolute** (no `./`, no `${workspaceFolder}`)
- API keys are literal values — Claude Desktop has no env var interpolation
- The `boston` server uses `mcp-remote` (HTTP); `socrata` and `data-commons` are local processes (stdio)
- Remote MCP servers added via Settings > Integrations are separate from this config

## API Keys

Both keys are **free** and **low-risk** (public data APIs). They can be revoked and regenerated at any time.

### Socrata App Token (Optional)

- **What it does**: Increases rate limits for NYC Open Data queries. Without it, queries still work but at lower rate limits.
- **Get it**: [NYC Open Data Developer Settings](https://data.cityofnewyork.us/profile/edit/developer_settings) (requires free account)
- **The value you need**: The "Key ID" (not the "Key Secret")

### Data Commons API Key (Required)

- **What it does**: Enables the Data Commons MCP server. Without it, Data Commons won't work.
- **Get it**: [Data Commons API Keys](https://apikeys.datacommons.org/)
- **The value you need**: The "api_key" value (not the "secret")

### Security

- These are public data API keys, not credentials for private systems
- `.env.local` is gitignored — keys never get committed
- Generated `.mcp.json` and `.cursor/mcp.json` are also gitignored (they contain baked-in keys)
- AI tools in the workspace can read `.env.local` — this is fine for public data keys
- If concerned, add to `.claude/settings.local.json`: `{"permissions": {"deny": ["Read(.env.local)"]}}`

## File Structure (After Setup)

```
mcp-demo/
├── .mcp.json                       ← Generated (gitignored) — Claude Code
├── .cursor/mcp.json                ← Generated (gitignored) — Cursor
├── .env.local                      ← Your API keys (gitignored)
├── .env.local.example              ← Template (committed)
├── .mcp-servers/                   ← Built MCP server (gitignored)
│   └── socrata-mcp-server/
│       └── dist/index.js
├── scripts/
│   └── setup-civic.sh              ← This setup script
├── docs/
│   └── civic-ai-setup.md           ← This document
├── .claude/settings.json           ← Permissions (includes socrata + data-commons)
├── CLAUDE.md                       ← Tool guide (includes Socrata + Data Commons sections)
└── ... (existing mcp-demo files)
```

## Script Options

```bash
./scripts/setup-civic.sh              # Full setup (interactive)
./scripts/setup-civic.sh --check      # Preflight only — verify prerequisites, no changes
./scripts/setup-civic.sh --force      # Re-clone and rebuild from scratch
```

## Troubleshooting

| Problem | Fix |
|---------|-----|
| `datacommons-mcp: command not found` | Run `export PATH="$HOME/.local/bin:$PATH"` then re-run setup |
| Cursor MCP "connection failed" | Check `.cursor/mcp.json` has absolute paths. Re-run setup. |
| `npm run build` fails | Check Node.js version (`node -v`). Need 18+. |
| Socrata queries return 429 | Add `SOCRATA_APP_TOKEN` to `.env.local` and re-run setup |
| Data Commons returns auth error | Check `DC_API_KEY` is set in `.env.local`. Re-run setup. |
| Claude Desktop MCP not showing | Full quit + reopen (not just close window). Check JSON syntax (no trailing commas). |
| `git clone` fails (firewall) | Download socrata-mcp-server ZIP manually into `.mcp-servers/` |

## Socrata MCP — Tool Reference

### Tools

| Tool | Purpose |
|------|---------|
| `search` | Find datasets by keyword or search within a dataset |
| `fetch` | Retrieve full dataset metadata or records |
| `get_data` | Execute SoQL queries — the primary query tool |

### Supported Domains

| Domain | City | Support |
|--------|------|---------|
| `data.cityofnewyork.us` | NYC | Full (default) |
| `data.cityofchicago.org` | Chicago | Full |
| `data.sfgov.org` | San Francisco | Limited — search may return NYC data |
| `data.seattle.gov` | Seattle | Full |
| `data.lacity.org` | Los Angeles | Query-only — only `get_data` works |

### Key NYC Datasets

| Dataset | ID | Notes |
|---------|-----|-------|
| 311 Service Requests | `erm2-nwe9` | ~10k records/day — always add date filter |
| Restaurant Inspections | `43nn-pn8j` | Grades, violations, cuisine types |
| Housing Violations | `wvxf-dwi5` | ~500-1k records/day |

### SoQL Query Patterns

```sql
-- Basic query with date filter
SELECT complaint_type, COUNT(*) as cnt
WHERE created_date >= '2026-01-01T00:00:00'
GROUP BY complaint_type
ORDER BY cnt DESC
LIMIT 10

-- Text filtering (case-sensitive — use upper())
SELECT * WHERE upper(borough) LIKE '%MANHATTAN%'

-- Spatial query
SELECT * WHERE within_circle(location, 42.36, -71.06, 500)
```

**Critical**: Always run `SELECT * LIMIT 1` on unfamiliar datasets first to discover column names. SoQL is case-sensitive — use `upper()` + `LIKE`, not `ILIKE`, for aggregations.

## Data Commons MCP — Tool Reference

### Tools

| Tool | Purpose |
|------|---------|
| `search_entities` | Find geographic entities (cities, states, countries) |
| `get_statistics` | Retrieve statistical data for entities and variables |

### Key DCIDs (Data Commons IDs)

| Location | DCID |
|----------|------|
| NYC | `geoId/3651000` |
| Los Angeles | `geoId/0644000` |
| Chicago | `geoId/1714000` |
| Boston | `geoId/2507000` |
| San Francisco | `geoId/0667000` |
| Seattle | `geoId/5363000` |

### Common Variables

| Variable | What it measures |
|----------|-----------------|
| `Count_Person` | Population |
| `Median_Income_Person` | Median income |
| `Count_HousingUnit` | Housing units |
| `Count_CriminalActivities_CombinedCrime` | Crime count |
| `UnemploymentRate_Person` | Unemployment rate |

## Example Queries (After Setup)

Try these in Claude Code, Cursor, or Claude Desktop:

**NYC Open Data (Socrata):**
> "What are the top 10 complaint types in NYC 311 this month?"

> "Show me restaurant inspection grades in Manhattan for the last 30 days"

**Data Commons:**
> "Compare the population of NYC, Boston, and Chicago over the last 10 years"

> "What's the median income in Boston vs NYC?"

**Cross-source:**
> "How does NYC's 311 complaint volume compare to Boston's, adjusted for population?"
