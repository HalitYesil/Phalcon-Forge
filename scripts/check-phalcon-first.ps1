Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

$root = Resolve-Path (Join-Path $PSScriptRoot "..")
$starterRoot = Join-Path $root "starter-kits"

if (-not (Test-Path $starterRoot)) {
    throw "starter-kits dizini bulunamadi."
}

$files = Get-ChildItem -Path $starterRoot -Recurse -File -Filter "*.php"
$violations = @()

foreach ($file in $files) {
    $content = Get-Content $file.FullName -Raw
    if ($content -match "filter_var\s*\(") {
        $violations += $file.FullName
    }
}

if ($violations.Count -gt 0) {
    $violations | ForEach-Object { Write-Error "Phalcon-first ihlali (filter_var): $_" }
    exit 1
}

Write-Host "Phalcon-first check passed."
