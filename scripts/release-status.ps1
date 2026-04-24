Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

$root = Resolve-Path (Join-Path $PSScriptRoot "..")
$checks = @(
    @{ Name = "Source policy"; Cmd = "pwsh -NoProfile -File `"$($root)\scripts\check-source-policy.ps1`"" },
    @{ Name = "Starter structure"; Cmd = "pwsh -NoProfile -File `"$($root)\scripts\check-starter-structure.ps1`"" },
    @{ Name = "Phalcon-first"; Cmd = "pwsh -NoProfile -File `"$($root)\scripts\check-phalcon-first.ps1`"" },
    @{ Name = "MCP contracts"; Cmd = "pwsh -NoProfile -File `"$($root)\scripts\check-mcp-contracts.ps1`"" },
    @{ Name = "PhalconDocs index"; Cmd = "pwsh -NoProfile -File `"$($root)\scripts\check-phalcondocs-index.ps1`"" },
    @{ Name = "MCP smoke"; Cmd = "pwsh -NoProfile -File `"$($root)\scripts\smoke-mcp.ps1`"" },
    @{ Name = "Full CI"; Cmd = "pwsh -NoProfile -File `"$($root)\scripts\ci-check.ps1`"" }
)

$results = @()
foreach ($check in $checks) {
    try {
        Invoke-Expression $check.Cmd | Out-Null
        $results += [PSCustomObject]@{
            Check = $check.Name
            Status = "PASS"
        }
    }
    catch {
        $results += [PSCustomObject]@{
            Check = $check.Name
            Status = "FAIL"
        }
    }
}

$passCount = ($results | Where-Object { $_.Status -eq "PASS" }).Count
$total = $results.Count

Write-Host ""
Write-Host "Release Status (v0.1)"
Write-Host "---------------------"
$results | ForEach-Object { Write-Host ("{0,-20} {1}" -f $_.Check, $_.Status) }
Write-Host "---------------------"
Write-Host ("Summary: {0}/{1} PASS" -f $passCount, $total)

if ($passCount -ne $total) {
    exit 1
}
