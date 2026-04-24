Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

$root = Resolve-Path (Join-Path $PSScriptRoot "..")
$toolsDir = Join-Path $root "mcp-server\tools"

if (-not (Test-Path $toolsDir)) {
    throw "Tools directory bulunamadi: $toolsDir"
}

$toolFiles = Get-ChildItem -Path $toolsDir -Filter "*.json" -File
if ($toolFiles.Count -eq 0) {
    throw "mcp-server/tools altinda tool dosyasi bulunamadi."
}

$failed = $false
foreach ($file in $toolFiles) {
    $tool = Get-Content $file.FullName -Raw | ConvertFrom-Json

    if (-not ($tool.PSObject.Properties.Name -contains "name") -or [string]::IsNullOrWhiteSpace([string]$tool.name)) {
        Write-Error "Eksik veya bos name: $($file.Name)"
        $failed = $true
    }

    if (-not ($tool.PSObject.Properties.Name -contains "description") -or [string]::IsNullOrWhiteSpace([string]$tool.description)) {
        Write-Error "Eksik veya bos description: $($file.Name)"
        $failed = $true
    }

    if (-not ($tool.PSObject.Properties.Name -contains "inputSchema")) {
        Write-Error "Eksik inputSchema: $($file.Name)"
        $failed = $true
        continue
    }

    $inputSchemaProps = $tool.inputSchema.PSObject.Properties.Name
    if (-not ($inputSchemaProps -contains "type") -or $tool.inputSchema.type -ne "object") {
        Write-Error "inputSchema.type object olmali: $($file.Name)"
        $failed = $true
    }
    if (-not ($inputSchemaProps -contains "properties")) {
        Write-Error "inputSchema.properties eksik: $($file.Name)"
        $failed = $true
    }
    if (-not ($inputSchemaProps -contains "required")) {
        Write-Error "inputSchema.required eksik: $($file.Name)"
        $failed = $true
    }
    if (-not ($inputSchemaProps -contains "additionalProperties")) {
        Write-Error "inputSchema.additionalProperties eksik: $($file.Name)"
        $failed = $true
    }

    if (-not ($tool.PSObject.Properties.Name -contains "outputSchemaPath")) {
        Write-Error "Eksik outputSchemaPath: $($file.Name)"
        $failed = $true
        continue
    }

    $schemaPath = Join-Path (Join-Path $root "mcp-server") $tool.outputSchemaPath
    if (-not (Test-Path $schemaPath)) {
        Write-Error "Output schema bulunamadi: $($file.Name) -> $($tool.outputSchemaPath)"
        $failed = $true
        continue
    }

    $schema = Get-Content $schemaPath -Raw | ConvertFrom-Json
    $schemaProps = $schema.PSObject.Properties.Name

    if (-not ($schemaProps -contains "type") -or $schema.type -ne "object") {
        Write-Error "Output schema type object olmali: $($tool.outputSchemaPath)"
        $failed = $true
    }
    if (-not ($schemaProps -contains "required")) {
        Write-Error "Output schema required alani eksik: $($tool.outputSchemaPath)"
        $failed = $true
    }
    if (-not ($schemaProps -contains "additionalProperties") -or $schema.additionalProperties -ne $false) {
        Write-Error "Output schema additionalProperties false olmali: $($tool.outputSchemaPath)"
        $failed = $true
    }
}

if ($failed) {
    exit 1
}

Write-Host "MCP contracts check passed."
