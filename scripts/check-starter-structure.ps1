Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

$root = Resolve-Path (Join-Path $PSScriptRoot "..")
$starterRoot = Join-Path $root "starter-kits"
$scenarios = @("basic", "invo", "rest", "vokuro")
$required = @("app", "public", "config", "tests")

if (-not (Test-Path $starterRoot)) {
    throw "starter-kits dizini bulunamadi."
}

$failed = $false
foreach ($scenario in $scenarios) {
    $scenarioPath = Join-Path $starterRoot $scenario
    if (-not (Test-Path $scenarioPath)) {
        Write-Error "Eksik scenario: $scenario"
        $failed = $true
        continue
    }

    $composer = Join-Path $scenarioPath "composer.json"
    if (-not (Test-Path $composer)) {
        Write-Error "Eksik composer.json: $scenario"
        $failed = $true
    }

    foreach ($folder in $required) {
        $dir = Join-Path $scenarioPath $folder
        if (-not (Test-Path $dir)) {
            Write-Error "Eksik klasor: $scenario/$folder"
            $failed = $true
        }
    }
}

if ($failed) {
    exit 1
}

Write-Host "Starter structure check passed."
