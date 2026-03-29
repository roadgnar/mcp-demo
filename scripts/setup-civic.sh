#!/usr/bin/env bash
# =============================================================================
# setup-civic.sh — Setup Socrata + Data Commons MCP servers (npx/uvx edition)
# =============================================================================
#
# Configures NYC Open Data (Socrata) and Google Data Commons MCP servers
# alongside the existing Boston Open Data MCP.
#
# Usage:
#   ./scripts/setup-civic.sh              # Generate configs from .env.local
#   ./scripts/setup-civic.sh --check      # Preflight only — no changes
#
# What it does:
#   1. Checks prerequisites (Node.js 18+, Python 3+, npx, uvx)
#   2. Reads API keys from .env.local
#   3. Generates .mcp.json and .cursor/mcp.json with npx/uvx servers
#
# No git clone, no npm install, no npm build — npx and uvx handle everything.
# Idempotent: safe to run multiple times.
# =============================================================================

set -euo pipefail

# --- Colors & Formatting ---
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
BOLD='\033[1m'
DIM='\033[2m'
NC='\033[0m'

ok()   { echo -e "  ${GREEN}[OK]${NC} $1"; }
skip() { echo -e "  ${DIM}[--]${NC} $1 ${DIM}(already done)${NC}"; }
warn() { echo -e "  ${YELLOW}[!!]${NC} $1"; }
fail() { echo -e "  ${RED}[FAIL]${NC} $1"; }
step() { echo -e "\n${BOLD}${BLUE}$1${NC}"; }

# --- Paths ---
SCRIPT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
PROJECT_DIR=$(dirname "$SCRIPT_DIR")
ENV_LOCAL="$PROJECT_DIR/.env.local"
ENV_EXAMPLE="$PROJECT_DIR/.env.local.example"
MCP_JSON="$PROJECT_DIR/.mcp.json"
CURSOR_JSON="$PROJECT_DIR/.cursor/mcp.json"

# --- Flags ---
CHECK_ONLY=false
for arg in "$@"; do
  case "$arg" in
    --check) CHECK_ONLY=true ;;
  esac
done

# =============================================================================
# Step 1: Preflight — Check Prerequisites
# =============================================================================

step "Step 1: Checking prerequisites"

MISSING=0

# Node.js 18+
if command -v node &>/dev/null; then
  NODE_VER=$(node -v | sed 's/v//' | cut -d. -f1)
  if [ "$NODE_VER" -ge 18 ]; then
    ok "Node.js $(node -v)"
  else
    fail "Node.js $(node -v) — need 18+"; MISSING=$((MISSING+1))
  fi
else
  fail "Node.js not found"; MISSING=$((MISSING+1))
fi

# npx
if command -v npx &>/dev/null; then
  ok "npx available"
else
  fail "npx not found (comes with Node.js)"; MISSING=$((MISSING+1))
fi

# Python 3+
if command -v python3 &>/dev/null; then
  ok "Python $(python3 --version | awk '{print $2}')"
else
  fail "Python 3 not found"; MISSING=$((MISSING+1))
fi

# uvx (from uv)
if command -v uvx &>/dev/null; then
  ok "uvx available ($(uv --version 2>/dev/null | awk '{print $2}'))"
else
  fail "uvx not found — install uv: https://docs.astral.sh/uv/"; MISSING=$((MISSING+1))
fi

if [ "$MISSING" -gt 0 ]; then
  echo ""
  fail "Missing $MISSING prerequisite(s). Install them and re-run."
  exit 1
fi

if [ "$CHECK_ONLY" = true ]; then
  echo ""
  ok "All prerequisites met."
  exit 0
fi

# =============================================================================
# Step 2: Load API Keys
# =============================================================================

step "Step 2: Loading API keys from .env.local"

SOCRATA_TOKEN=""
DC_KEY=""

if [ -f "$ENV_LOCAL" ]; then
  set +u
  while IFS='=' read -r key value; do
    [[ "$key" =~ ^#.*$ ]] && continue
    [[ -z "$key" ]] && continue
    key=$(echo "$key" | xargs)
    value=$(echo "$value" | xargs)
    case "$key" in
      SOCRATA_APP_TOKEN) SOCRATA_TOKEN="$value" ;;
      DC_API_KEY) DC_KEY="$value" ;;
    esac
  done < "$ENV_LOCAL"
  set -u

  [ -n "$SOCRATA_TOKEN" ] && ok "SOCRATA_APP_TOKEN loaded" || warn "SOCRATA_APP_TOKEN is empty in .env.local"
  [ -n "$DC_KEY" ] && ok "DC_API_KEY loaded" || warn "DC_API_KEY is empty in .env.local"
else
  warn ".env.local not found"
  if [ -f "$ENV_EXAMPLE" ]; then
    echo "  Copying .env.local.example → .env.local"
    cp "$ENV_EXAMPLE" "$ENV_LOCAL"
    warn "Edit .env.local and add your API keys, then re-run this script."
  else
    warn "No .env.local.example found either. Create .env.local manually."
  fi
fi

# =============================================================================
# Step 3: Generate MCP Configurations
# =============================================================================

step "Step 3: Generating MCP configurations"

CONFIG_CONTENT=$(cat << CFGEOF
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
        "SOCRATA_APP_TOKEN": "${SOCRATA_TOKEN}",
        "CACHE_ENABLED": "true",
        "LOG_LEVEL": "info"
      }
    },
    "data-commons": {
      "command": "uvx",
      "args": ["datacommons-mcp", "serve", "stdio"],
      "env": {
        "DC_API_KEY": "${DC_KEY}"
      }
    }
  }
}
CFGEOF
)

# Write .mcp.json (Claude Code)
echo "$CONFIG_CONTENT" > "$MCP_JSON"
ok "Generated .mcp.json (Claude Code)"

# Write .cursor/mcp.json (Cursor) — identical, npx/uvx needs no path differences
mkdir -p "$PROJECT_DIR/.cursor"
echo "$CONFIG_CONTENT" > "$CURSOR_JSON"
ok "Generated .cursor/mcp.json (Cursor)"

# =============================================================================
# Step 4: Summary
# =============================================================================

step "Setup complete!"

echo ""
echo -e "${BOLD}MCP Servers configured:${NC}"
echo -e "  ${GREEN}1.${NC} boston        — Boston Open Data (remote HTTP via mcp-remote)"
echo -e "  ${GREEN}2.${NC} socrata      — NYC Open Data via Socrata (npx, stdio)"
echo -e "  ${GREEN}3.${NC} data-commons — Google Data Commons (uvx, stdio)"
echo ""
echo -e "${BOLD}Generated files:${NC}"
echo -e "  .mcp.json          — Claude Code config"
echo -e "  .cursor/mcp.json   — Cursor config (identical)"
echo ""

# --- API key status ---
if [ -z "$SOCRATA_TOKEN" ] || [ -z "$DC_KEY" ]; then
  echo -e "${YELLOW}${BOLD}Next steps:${NC}"
  echo -e "  1. Edit ${CYAN}.env.local${NC} — add your API keys"
  [ -z "$SOCRATA_TOKEN" ] && echo -e "     SOCRATA_APP_TOKEN  → https://data.cityofnewyork.us/profile/edit/developer_settings"
  [ -z "$DC_KEY" ] && echo -e "     DC_API_KEY          → https://apikeys.datacommons.org/"
  echo -e "  2. Re-run: ${CYAN}./scripts/setup-civic.sh${NC}"
  echo ""
fi

# --- Quick start ---
echo -e "${BOLD}Quick start:${NC}"
echo -e "  Claude Code: ${CYAN}cd $(basename "$PROJECT_DIR") && claude${NC}"
echo -e "  Cursor:      Open this folder in Cursor — servers auto-load"
echo ""
