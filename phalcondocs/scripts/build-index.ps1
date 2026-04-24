Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

$root = Resolve-Path (Join-Path $PSScriptRoot "..\..")
$manifestPath = Join-Path $root "phalcondocs\index\manifest.json"
$symbolsPath = Join-Path $root "phalcondocs\index\symbols.json"

if (-not (Test-Path $manifestPath)) {
    throw "Manifest bulunamadi: $manifestPath"
}

$manifest = Get-Content $manifestPath -Raw | ConvertFrom-Json

$result = @{
    sourcePolicy = @{
        strictUrlOnly = $true
        allowInference = $false
        allowCrossVersionMerge = $false
    }
    versions = @{}
}

foreach ($v in @("5.9", "5.11")) {
    $versionEntry = $manifest.lockedSources.$v
    if ($null -eq $versionEntry) {
        continue
    }

    $result.versions[$v] = @{
        sourceUrl = $versionEntry.introduction
        repositoryBranch = $versionEntry.branch
        symbols = @(
            @{
                name = "Phalcon"
                type = "namespace"
                note = "Derived from locked introduction source only."
            }
        )
    }
}

$json = $result | ConvertTo-Json -Depth 10
$json | Out-File -Encoding utf8 $symbolsPath
Write-Host "Index rebuilt: phalcondocs/index/symbols.json"
