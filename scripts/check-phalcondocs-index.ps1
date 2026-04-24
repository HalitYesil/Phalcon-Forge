Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

$root = Resolve-Path (Join-Path $PSScriptRoot "..")
$requiredFiles = @(
    "phalcondocs/index/manifest.json",
    "phalcondocs/index/symbols.json",
    "phalcondocs/index/methods-by-category.json",
    "phalcondocs/index/scenarios.json",
    "phalcondocs/sources/5.9/introduction.md",
    "phalcondocs/sources/5.11/introduction.md"
)

$failed = $false
foreach ($relative in $requiredFiles) {
    $full = Join-Path $root $relative
    if (-not (Test-Path $full)) {
        Write-Error "Eksik PhalconDocs dosyasi: $relative"
        $failed = $true
    }
}

if ($failed) { exit 1 }
Write-Host "PhalconDocs index check passed."
