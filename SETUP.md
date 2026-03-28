# Setup Guide

Complete setup instructions for the MCP Demo environment on macOS, Linux, and Windows.

## Prerequisites

| Tool | Required | How to Install |
|------|----------|----------------|
| Node.js 18+ | Yes (Socrata + Boston MCPs) | [nodejs.org](https://nodejs.org/) |
| Python 3.11+ with uv | Yes (Data Commons MCP) | [astral.sh/uv](https://docs.astral.sh/uv/) |
| Claude Desktop or Claude Code | Yes (MCP host) | [claude.ai/download](https://claude.ai/download) |
| Cyvl account | Yes (infrastructure imagery) | Contact your org's Cyvl admin |

## Step 1: Get Your API Keys (All Platforms)

Both API keys below are configured on the **main** branch and work for all city branches (boston, nyc, etc.).

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
4. Prints a Claude Desktop config snippet for manual addition

The script is idempotent — safe to run multiple times.

## Step 4: Connect Cyvl MCP

Cyvl uses OAuth authentication, so it connects separately from the API-key-based servers.

- **Claude Desktop:** Open the MCP connectors panel, search "Cyvl", click Connect, and complete the OAuth login
- **Claude Code:** Run `/mcp`, click Cyvl, and complete the OAuth flow

This is a one-time step per device. After connecting, Cyvl stays authenticated across sessions.

## Step 5: Verify

Open Claude and try:

```
Search for "fire hydrants" and show me 3 images
```

- If Cyvl returns street-level imagery, the Cyvl connection is working
- If open data queries return results, Socrata and Data Commons are connected

You can also test individual servers:

```
What datasets are available on data.boston.gov about permits?
```

```
What is the population of New York City?
```

## Claude Desktop Config (Manual)

If you prefer to configure Claude Desktop manually instead of using the setup script, add the server definitions to your config file:

| Platform | Config path |
|----------|-------------|
| macOS | `~/Library/Application Support/Claude/claude_desktop_config.json` |
| Windows | `%APPDATA%\Claude\claude_desktop_config.json` |
| Linux | `~/.config/Claude/claude_desktop_config.json` |

Add the following to the `mcpServers` object in your config file (merge with any existing servers):

**macOS / Linux:**

```json
{
  "mcpServers": {
    "boston": {
      "command": "npx",
      "args": ["-y", "mcp-remote", "https://vgcpuua1ua.execute-api.us-east-1.amazonaws.com/staging/mcp"]
    },
    "socrata": {
      "command": "npx",
      "args": ["-y", "socrata-mcp-server", "--stdio"],
      "env": {
        "DEFAULT_DOMAIN": "data.cityofnewyork.us",
        "SOCRATA_APP_TOKEN": "YOUR_TOKEN_HERE",
        "CACHE_ENABLED": "true",
        "LOG_LEVEL": "info"
      }
    },
    "data-commons": {
      "command": "uvx",
      "args": ["datacommons-mcp", "serve", "stdio"],
      "env": {
        "DC_API_KEY": "YOUR_KEY_HERE"
      }
    }
  }
}
```

**Windows:** Use `cmd /c` wrappers for npx commands:

```json
{
  "mcpServers": {
    "boston": {
      "command": "cmd",
      "args": ["/c", "npx", "-y", "mcp-remote", "https://vgcpuua1ua.execute-api.us-east-1.amazonaws.com/staging/mcp"]
    },
    "socrata": {
      "command": "cmd",
      "args": ["/c", "npx", "-y", "socrata-mcp-server", "--stdio"],
      "env": {
        "DEFAULT_DOMAIN": "data.cityofnewyork.us",
        "SOCRATA_APP_TOKEN": "YOUR_TOKEN_HERE",
        "CACHE_ENABLED": "true",
        "LOG_LEVEL": "info"
      }
    },
    "data-commons": {
      "command": "uvx",
      "args": ["datacommons-mcp", "serve", "stdio"],
      "env": {
        "DC_API_KEY": "YOUR_KEY_HERE"
      }
    }
  }
}
```

Then restart Claude Desktop (full quit and reopen).

## Windows Notes

- **npx requires `cmd /c` wrapper** in MCP configs on Windows — the PowerShell script handles this automatically
- **MSIX (Microsoft Store) Claude Desktop** may use a different config path under `%LOCALAPPDATA%\Packages\...\LocalCache\Roaming\Claude\`
- **If MCP servers fail to connect**, verify that Node.js and Python are in your system PATH
- **uvx works directly** on Windows — no wrapper needed

## City Branches

After setup on `main`, switch to a city branch for city-specific demos:

```bash
git checkout boston   # Boston-focused demos
git checkout nyc     # NYC-focused demos
```

City branches add curated examples, datasets, and prompts on top of the base setup. API keys configured on `main` carry over to all branches.

## Troubleshooting

| Problem | Cause | Fix |
|---------|-------|-----|
| `npx: command not found` | Node.js not installed or not in PATH | Install Node.js 18+ from [nodejs.org](https://nodejs.org/) |
| `uvx: command not found` | uv not installed | Install uv: `curl -LsSf https://astral.sh/uv/install.sh \| sh` (macOS/Linux) or `irm https://astral.sh/uv/install.ps1 \| iex` (Windows) |
| Socrata queries return 403 | App token invalid or missing | Verify `SOCRATA_APP_TOKEN` in `.env.local` is the Key ID (not Key Secret) |
| Data Commons won't connect | Missing or invalid API key | Check `DC_API_KEY` in `.env.local`, get a new key at [apikeys.datacommons.org](https://apikeys.datacommons.org/) |
| Cyvl returns auth error | OAuth session expired | Re-authenticate: run `/mcp` in Claude Code and reconnect Cyvl |
| Boston MCP unreachable | Remote server down | Check status; this is a hosted MCP — no local fix |
| MCP servers not loading in Cursor | Config not in `.cursor/mcp.json` | Re-run the setup script to regenerate configs |
| Windows: npx hangs or fails | Missing `cmd /c` wrapper | Use the PowerShell setup script, which adds `cmd /c` automatically |
| MSIX Claude Desktop can't find config | Different config path for Store apps | Check `%LOCALAPPDATA%\Packages\` for the Claude data directory |
| `.env.local` not found | Haven't copied the example yet | Run `cp .env.local.example .env.local` and add your keys |
