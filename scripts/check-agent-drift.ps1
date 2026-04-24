Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

$root = Resolve-Path (Join-Path $PSScriptRoot "..")
$common = Join-Path $root "agents\common\policy.md"
$adapters = @(
    Join-Path $root "agents\adapters\cursor.md",
    Join-Path $root "agents\adapters\claude.md",
    Join-Path $root "agents\adapters\codex.md"
)

if (-not (Test-Path $common)) {
    throw "Missing common policy: $common"
}

$requiredKeywords = @("sanitize", "escape", "Phalcon", "custom")
$failed = $false

foreach ($adapter in $adapters) {
    if (-not (Test-Path $adapter)) {
        Write-Error "Missing adapter file: $adapter"
        $failed = $true
        continue
    }

    $content = Get-Content $adapter -Raw
    foreach ($k in $requiredKeywords) {
        if ($content -notmatch [Regex]::Escape($k)) {
            Write-Error "Adapter drift: '$adapter' missing keyword '$k'"
            $failed = $true
        }
    }
}

if ($failed) {
    exit 1
}

Write-Host "Cross-agent drift check passed."
