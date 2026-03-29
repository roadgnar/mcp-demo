# =============================================================================
# setup-civic.ps1 — Setup Socrata + Data Commons MCP servers (Windows/PowerShell)
# =============================================================================
#
# Configures Socrata Open Data and Google Data Commons MCP servers
# alongside the existing Boston Open Data MCP.
#
# Usage:
#   powershell -ExecutionPolicy Bypass -File .\scripts\setup-civic.ps1
#   powershell -ExecutionPolicy Bypass -File .\scripts\setup-civic.ps1 -Check
#
# What it does:
#   1. Checks prerequisites (Node.js 18+, Python 3+, npx, uvx)
#   2. Reads API keys from .env.local
#   3. Generates .mcp.json and .cursor/mcp.json with cmd /c wrappers for npx
#
# No git clone, no npm install, no npm build — npx and uvx handle everything.
# Idempotent: safe to run multiple times.
# =============================================================================

param(
    [switch]$Check
)

$ErrorActionPreference = "Stop"

# --- Color Helper Functions ---

function Write-Ok {
    param([string]$Message)
    Write-Host "  " -NoNewline
    Write-Host "[OK]" -ForegroundColor Green -NoNewline
    Write-Host " $Message"
}

function Write-Warn {
    param([string]$Message)
    Write-Host "  " -NoNewline
    Write-Host "[!!]" -ForegroundColor Yellow -NoNewline
    Write-Host " $Message"
}

function Write-Fail {
    param([string]$Message)
    Write-Host "  " -NoNewline
    Write-Host "[FAIL]" -ForegroundColor Red -NoNewline
    Write-Host " $Message"
}

function Write-Step {
    param([string]$Message)
    Write-Host ""
    Write-Host $Message -ForegroundColor Blue
}

# --- Path Resolution ---

$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Definition
$ProjectDir = Split-Path -Parent $ScriptDir
$EnvLocal = Join-Path $ProjectDir ".env.local"
$EnvExample = Join-Path $ProjectDir ".env.local.example"
$McpJson = Join-Path $ProjectDir ".mcp.json"
$CursorDir = Join-Path $ProjectDir ".cursor"
$CursorJson = Join-Path $CursorDir "mcp.json"

# =============================================================================
# Step 1: Preflight — Check Prerequisites
# =============================================================================

Write-Step "Step 1: Checking prerequisites"

$Missing = 0

# Node.js 18+
$NodeCmd = Get-Command node -ErrorAction SilentlyContinue
if ($NodeCmd) {
    $NodeVersion = (node -v) -replace '^v', ''
    $NodeMajor = [int]($NodeVersion.Split('.')[0])
    if ($NodeMajor -ge 18) {
        Write-Ok "Node.js v$NodeVersion"
    } else {
        Write-Fail "Node.js v$NodeVersion — need 18+"
        $Missing++
    }
} else {
    Write-Fail "Node.js not found"
    $Missing++
}

# npx
$NpxCmd = Get-Command npx -ErrorAction SilentlyContinue
if ($NpxCmd) {
    Write-Ok "npx available"
} else {
    Write-Fail "npx not found (comes with Node.js)"
    $Missing++
}

# Python 3+
$PythonCmd = Get-Command python -ErrorAction SilentlyContinue
if (-not $PythonCmd) {
    $PythonCmd = Get-Command python3 -ErrorAction SilentlyContinue
}
if ($PythonCmd) {
    $PythonVersion = & $PythonCmd.Source --version 2>&1
    Write-Ok "$PythonVersion"
} else {
    Write-Fail "Python 3 not found"
    $Missing++
}

# uvx (from uv)
$UvxCmd = Get-Command uvx -ErrorAction SilentlyContinue
if ($UvxCmd) {
    $UvVersion = ""
    try { $UvVersion = (uv --version 2>&1) -replace '^uv ', '' } catch {}
    if ($UvVersion) {
        Write-Ok "uvx available ($UvVersion)"
    } else {
        Write-Ok "uvx available"
    }
} else {
    Write-Fail "uvx not found — install uv: https://docs.astral.sh/uv/"
    $Missing++
}

if ($Missing -gt 0) {
    Write-Host ""
    Write-Fail "Missing $Missing prerequisite(s). Install them and re-run."
    exit 1
}

if ($Check) {
    Write-Host ""
    Write-Ok "All prerequisites met."
    exit 0
}

# =============================================================================
# Step 2: Load API Keys
# =============================================================================

Write-Step "Step 2: Loading API keys from .env.local"

$SocrataToken = ""
$DcKey = ""

if (Test-Path $EnvLocal) {
    foreach ($line in Get-Content $EnvLocal) {
        $line = $line.Trim()
        if ($line -match '^\s*#' -or $line -eq '') { continue }
        if ($line -match '^([^=]+)=(.*)$') {
            $key = $Matches[1].Trim()
            $value = $Matches[2].Trim()
            switch ($key) {
                'SOCRATA_APP_TOKEN' { $SocrataToken = $value }
                'DC_API_KEY' { $DcKey = $value }
            }
        }
    }

    if ($SocrataToken) { Write-Ok "SOCRATA_APP_TOKEN loaded" } else { Write-Warn "SOCRATA_APP_TOKEN is empty in .env.local" }
    if ($DcKey) { Write-Ok "DC_API_KEY loaded" } else { Write-Warn "DC_API_KEY is empty in .env.local" }
} else {
    Write-Warn ".env.local not found"
    if (Test-Path $EnvExample) {
        Write-Host "  Copying .env.local.example -> .env.local"
        Copy-Item $EnvExample $EnvLocal
        Write-Warn "Edit .env.local and add your API keys, then re-run this script."
    } else {
        Write-Warn "No .env.local.example found either. Create .env.local manually."
    }
}

# =============================================================================
# Step 3: Generate MCP Configurations
# =============================================================================

Write-Step "Step 3: Generating MCP configurations"

$ConfigObject = @{
    mcpServers = [ordered]@{
        boston = [ordered]@{
            command = "cmd"
            args = @("/c", "npx", "-y", "mcp-remote", "https://vgcpuua1ua.execute-api.us-east-1.amazonaws.com/staging/mcp")
        }
        socrata = [ordered]@{
            command = "cmd"
            args = @("/c", "npx", "-y", "socrata-mcp-server", "--stdio")
            env = [ordered]@{
                DEFAULT_DOMAIN = "data.cityofnewyork.us"
                SOCRATA_APP_TOKEN = $SocrataToken
                CACHE_ENABLED = "true"
                LOG_LEVEL = "info"
            }
        }
        "data-commons" = [ordered]@{
            command = "uvx"
            args = @("datacommons-mcp", "serve", "stdio")
            env = [ordered]@{
                DC_API_KEY = $DcKey
            }
        }
    }
}

$ConfigJson = $ConfigObject | ConvertTo-Json -Depth 5

# Write .mcp.json (Claude Code)
$ConfigJson | Out-File -FilePath $McpJson -Encoding utf8
Write-Ok "Generated .mcp.json (Claude Code)"

# Write .cursor/mcp.json (Cursor)
if (-not (Test-Path $CursorDir)) {
    New-Item -ItemType Directory -Path $CursorDir -Force | Out-Null
}
$ConfigJson | Out-File -FilePath $CursorJson -Encoding utf8
Write-Ok "Generated .cursor/mcp.json (Cursor)"

# =============================================================================
# Step 4: Summary
# =============================================================================

Write-Step "Setup complete!"

Write-Host ""
Write-Host "MCP Servers configured:" -ForegroundColor White
Write-Host "  1. boston        — Boston Open Data (remote HTTP via mcp-remote)"
Write-Host "  2. socrata      — Multi-city Open Data via Socrata (npx, stdio)"
Write-Host "  3. data-commons — Google Data Commons (uvx, stdio)"
Write-Host ""
Write-Host "Generated files:" -ForegroundColor White
Write-Host "  .mcp.json          — Claude Code config"
Write-Host "  .cursor/mcp.json   — Cursor config"
Write-Host ""

# --- API key status ---
if (-not $SocrataToken -or -not $DcKey) {
    Write-Host "Next steps:" -ForegroundColor Yellow
    Write-Host "  1. Edit .env.local — add your API keys"
    if (-not $SocrataToken) { Write-Host "     SOCRATA_APP_TOKEN  -> https://data.cityofnewyork.us/profile/edit/developer_settings" }
    if (-not $DcKey) { Write-Host "     DC_API_KEY          -> https://apikeys.datacommons.org/" }
    Write-Host "  2. Re-run: powershell -ExecutionPolicy Bypass -File .\scripts\setup-civic.ps1"
    Write-Host ""
}

# --- Quick start ---
$FolderName = Split-Path $ProjectDir -Leaf
Write-Host "Quick start:" -ForegroundColor White
Write-Host "  Claude Code: cd $FolderName && claude"
Write-Host "  Cursor:      Open this folder in Cursor — servers auto-load"
Write-Host ""
