param(
    [Parameter(Mandatory = $true)]
    [ValidateSet("5.9", "5.11")]
    [string]$Version
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

$repoUrl = "https://github.com/phalcon/documentation.git"
$branchMap = @{
    "5.9"  = "5.9.x"
    "5.11" = "5.11.x"
}

$root = Resolve-Path (Join-Path $PSScriptRoot "..\..")
$tmpRoot = Join-Path $root ".tmp"
$target = Join-Path $root "phalcondocs\sources\$Version"
$branch = $branchMap[$Version]

if (-not (Test-Path $tmpRoot)) {
    New-Item -ItemType Directory -Path $tmpRoot | Out-Null
}
if (-not (Test-Path $target)) {
    New-Item -ItemType Directory -Path $target | Out-Null
}

$worktree = Join-Path $tmpRoot "documentation-$Version"
if (Test-Path $worktree) {
    Remove-Item -Recurse -Force $worktree
}

Write-Host "Cloning $repoUrl ($branch) ..."
git clone --depth 1 --branch $branch $repoUrl $worktree | Out-Null

# Docs repository layout can evolve. We lock to the generated site URL data.
# This script currently preserves existing snapshot files and writes sync metadata.
$syncMeta = @{
    version = $Version
    branch = $branch
    repository = $repoUrl
    syncedAtUtc = (Get-Date).ToUniversalTime().ToString("o")
} | ConvertTo-Json -Depth 5

$syncMeta | Out-File -Encoding utf8 (Join-Path $target "sync-meta.json")

Write-Host "Sync metadata written: phalcondocs/sources/$Version/sync-meta.json"
Write-Host "Note: introduction snapshot remains URL-locked content."
