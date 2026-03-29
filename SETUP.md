# Setup Guide

Complete setup instructions for the MCP Demo environment on macOS, Linux, and Windows.

## Prerequisites

| Tool | Required | How to Install |
|------|----------|----------------|
| Node.js 18+ | Yes (Socrata + Boston MCPs) | [nodejs.org](https://nodejs.org/) |
| Python 3.11+ with uv | Yes (Data Commons MCP) | [astral.sh/uv](https://docs.astral.sh/uv/) |
| Claude Code or Cursor | Yes (MCP host) | [claude.ai/install](https://claude.ai/install.sh) |
| Cyvl account | Yes (infrastructure imagery) | Contact your org's Cyvl admin |

## Step 1: Get Your API Keys (All Platforms)

Both API keys below are configured on the **main** branch and work for all city branches.

### Cyvl Account (Required — OAuth, no key to paste)

Cyvl is an enterprise platform for AI-powered infrastructure analysis. There is no self-service signup.

- Contact your organization's Cyvl admin or request access at [cyvl.com/contact](https://www.cyvl.com/contact)
- Once provisioned, you connect via OAuth directly in Claude (no API key needed)
- You need project access to query data — use `list_projects` to see available cities
- This is a one-time setup per device (see Step 4 below)

### Socrata App Token (Recommended — increases rate limits)

1. Create a free account at [data.cityofnewyork.us/signup](https://data.cityofnewyork.us/signup)
2. Go to [Developer Settings](https://data.cityofnewyork.us/profile/edit/developer_settings)
3. Click **"Create New API Key"**
4. Name it anything (e.g., "mcp-demo")
5. Copy the **Key ID** (NOT the Key Secret) — this is your `SOCRATA_APP_TOKEN`

- Free, takes under 5 minutes
- Without it: queries still work but at lower rate limits

### Data Commons API Key (Required for demographics)

1. Go to [apikeys.datacommons.org](https://apikeys.datacommons.org/)
2. Request a key (may require Google sign-in)
3. Copy the **api_key** value — this is your `DC_API_KEY`

- Free, takes under 5 minutes
- Without it: Data Commons MCP won't connect

### Boston CKAN — No key needed

Auto-connects to data.boston.gov. Nothing to configure.

## Step 2: Configure API Keys

```bash
cp .env.local.example .env.local
```

Open `.env.local` in any editor and paste your keys:

```
SOCRATA_APP_TOKEN=your-key-id-here
DC_API_KEY=your-api-key-here
```

See `.env.local.example` for detailed comments on each key.

## Step 3: Run Setup

### macOS / Linux

```bash
chmod +x scripts/setup-civic.sh
./scripts/setup-civic.sh
```

To check prerequisites without making changes:

```bash
./scripts/setup-civic.sh --check
```

### Windows (PowerShell)

```powershell
powershell -ExecutionPolicy Bypass -File .\scripts\setup-civic.ps1
```

To check prerequisites without making changes:

```powershell
powershell -ExecutionPolicy Bypass -File .\scripts\setup-civic.ps1 -Check
```

### What the script does

1. Checks prerequisites (Node.js 18+, Python 3+, npx, uvx)
2. Reads keys from `.env.local`
3. Generates `.mcp.json` (Claude Code) and `.cursor/mcp.json` (Cursor)

The script is idempotent — safe to run multiple times.

## Step 4: Open the Project + Connect Cyvl

### Claude Code

1. Open your terminal
2. Navigate to the mcp-demo repo:
   ```bash
   cd mcp-demo
   ```
3. Launch Claude Code **from inside the repo folder**:
   ```bash
   claude
   ```
4. The Socrata, Data Commons, and Boston CKAN MCPs auto-connect
5. Connect Cyvl (one-time OAuth):
   ```
   /mcp
   ```
   Click **Cyvl** in the list and complete the OAuth login

### Cursor

1. Open the `mcp-demo` folder in Cursor
2. Cursor reads `.cursor/mcp.json` and connects all three servers
3. Connect Cyvl via the MCP settings panel

## Step 5: Verify Everything Works

### Test Cyvl (the star — AI imagery search)

```
Search for "fire hydrants" and show me 3 images
```

**Expected:** Cyvl returns street-level photos with GPS coordinates and confidence scores. If this works, Cyvl is connected and your project access is confirmed.

### Test Socrata (open data)

```
What are the top 5 complaint types in Chicago 311 this week?
```

**Expected:** Returns a ranked list of complaint types with counts from the Chicago Open Data portal.

### Test Data Commons (demographics)

```
What is the population of Boston?
```

**Expected:** Returns ~650,000 (2024 Census) with source citation.

### Test Boston CKAN

```
How many pedestrian crashes has Boston had this year?
```

**Expected:** Returns a count from the Vision Zero crash dataset.

If any test fails, check the [Troubleshooting](#troubleshooting) section below.

## Windows Notes

- **npx requires `cmd /c` wrapper** in MCP configs on Windows — the PowerShell script handles this automatically
- **If MCP servers fail to connect**, verify that Node.js and Python are in your system PATH
- **uvx works directly** on Windows — no wrapper needed

## City Branches

After setup on `main`, switch to a city branch for city-specific demos:

```bash
git checkout boston   # Boston-focused demos
```

City branches add curated examples, datasets, and prompts on top of the base setup. API keys configured on `main` carry over to all branches.

## Troubleshooting

| Problem | Cause | Fix |
|---------|-------|-----|
| `npx: command not found` | Node.js not installed or not in PATH | Install Node.js 18+ from [nodejs.org](https://nodejs.org/) |
| `uvx: command not found` | uv not installed | Install uv: `curl -LsSf https://astral.sh/uv/install.sh \| sh` (macOS/Linux) or `irm https://astral.sh/uv/install.ps1 \| iex` (Windows) |
| Socrata queries return 403 | App token invalid or missing | Verify `SOCRATA_APP_TOKEN` in `.env.local` is the Key ID (not Key Secret) |
| Data Commons won't connect | Missing or invalid API key | Check `DC_API_KEY` in `.env.local`, get a new key at [apikeys.datacommons.org](https://apikeys.datacommons.org/) |
| Cyvl returns auth error | OAuth session expired | Re-authenticate: run `/mcp` and reconnect Cyvl |
| Boston MCP unreachable | Remote server down | Check status; this is a hosted MCP — no local fix |
| MCP servers not loading in Cursor | Config not in `.cursor/mcp.json` | Re-run the setup script to regenerate configs |
| Windows: npx hangs or fails | Missing `cmd /c` wrapper | Use the PowerShell setup script, which adds `cmd /c` automatically |
| `.env.local` not found | Haven't copied the example yet | Run `cp .env.local.example .env.local` and add your keys |
