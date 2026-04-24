Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

$root = Resolve-Path (Join-Path $PSScriptRoot "..")

Write-Host "Running cross-agent drift check..."
pwsh -NoProfile -File (Join-Path $root "scripts\check-agent-drift.ps1")

Write-Host "Running source policy check..."
pwsh -NoProfile -File (Join-Path $root "scripts\check-source-policy.ps1")

Write-Host "Running starter structure check..."
pwsh -NoProfile -File (Join-Path $root "scripts\check-starter-structure.ps1")

Write-Host "Running MCP contracts check..."
pwsh -NoProfile -File (Join-Path $root "scripts\check-mcp-contracts.ps1")

Write-Host "Running Phalcon-first check..."
pwsh -NoProfile -File (Join-Path $root "scripts\check-phalcon-first.ps1")

Write-Host "Running PhalconDocs index check..."
pwsh -NoProfile -File (Join-Path $root "scripts\check-phalcondocs-index.ps1")

Write-Host "Running MCP smoke test..."
pwsh -NoProfile -File (Join-Path $root "scripts\smoke-mcp.ps1")

Write-Host "CI checks passed."
