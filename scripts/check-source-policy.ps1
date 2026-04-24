Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

$root = Resolve-Path (Join-Path $PSScriptRoot "..")
$manifestPath = Join-Path $root "phalcondocs\index\manifest.json"

if (-not (Test-Path $manifestPath)) {
    throw "Manifest bulunamadi: $manifestPath"
}

$manifest = Get-Content $manifestPath -Raw | ConvertFrom-Json

if ($manifest.sourcePolicy.mode -ne "strict_url_only") {
    throw "sourcePolicy.mode strict_url_only olmali."
}
if ($manifest.sourcePolicy.allowInference -ne $false) {
    throw "allowInference false olmali."
}
if ($manifest.sourcePolicy.allowCrossVersionMerge -ne $false) {
    throw "allowCrossVersionMerge false olmali."
}

$requiredVersions = @("5.9", "5.11")
foreach ($v in $requiredVersions) {
    if (-not $manifest.lockedSources.$v) {
        throw "lockedSources icinde $v bulunamadi."
    }
    if (-not $manifest.lockedSources.$v.introduction) {
        throw "$v icin introduction URL eksik."
    }
    if (-not $manifest.lockedSources.$v.localSnapshot) {
        throw "$v icin localSnapshot eksik."
    }
}

Write-Host "Source policy check passed."
