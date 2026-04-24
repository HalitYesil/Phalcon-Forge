Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

$root = Resolve-Path (Join-Path $PSScriptRoot "..")
$serverPath = Join-Path $root "mcp-server\server.php"

if (-not (Test-Path $serverPath)) {
    throw "MCP server bulunamadi: $serverPath"
}

$phpCmd = Get-Command php -ErrorAction SilentlyContinue
if ($null -eq $phpCmd) {
    throw "php command bulunamadi. MCP smoke test icin PHP gereklidir."
}

$psi = New-Object System.Diagnostics.ProcessStartInfo
$psi.FileName = $phpCmd.Path
$psi.Arguments = "`"$serverPath`""
$psi.RedirectStandardInput = $true
$psi.RedirectStandardOutput = $true
$psi.RedirectStandardError = $true
$psi.UseShellExecute = $false
$psi.CreateNoWindow = $true

$process = New-Object System.Diagnostics.Process
$process.StartInfo = $psi
[void]$process.Start()

try {
    $requests = @(
        '{"id":"1","tool":"get_starter_scenario","arguments":{"name":"rest"}}',
        '{"id":"2","tool":"get_methods_by_category","arguments":{"category":"orm","version":"5.11"}}',
        '{"id":"3","tool":"doctor_runtime","arguments":{"target":"dev","scenario":"basic"}}'
    )

    foreach ($req in $requests) {
        $process.StandardInput.WriteLine($req)
    }
    $process.StandardInput.Close()

    $outputLines = @()
    while (-not $process.StandardOutput.EndOfStream) {
        $line = $process.StandardOutput.ReadLine()
        if (-not [string]::IsNullOrWhiteSpace($line)) {
            $outputLines += $line
        }
    }

    $stderr = $process.StandardError.ReadToEnd()
    $process.WaitForExit()

    if ($process.ExitCode -ne 0) {
        throw "MCP server exit code: $($process.ExitCode). stderr: $stderr"
    }

    if ($outputLines.Count -lt 3) {
        throw "Beklenen 3 MCP cevabi alinmadi. Alinan: $($outputLines.Count)"
    }

    foreach ($line in $outputLines) {
        $decoded = $line | ConvertFrom-Json
        if ($decoded.PSObject.Properties.Name -contains "error") {
            throw "MCP response error: $($decoded.error)"
        }
        if (-not ($decoded.PSObject.Properties.Name -contains "result")) {
            throw "MCP response result alani eksik."
        }
    }
}
finally {
    if (-not $process.HasExited) {
        $process.Kill()
    }
    $process.Dispose()
}

Write-Host "MCP smoke test passed."
