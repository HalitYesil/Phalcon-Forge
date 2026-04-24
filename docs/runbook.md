# Operasyon Runbook

## Hedef

Sunucu bulma ve kurulum sorunlarini Docker ile standartlastirmak.

## Temel Akis

1. `docker/compose/docker-compose.yml` ile stack'i baslat.
2. DB baglantisini dogrula.
3. Migration/seed adimlarini calistir.
4. Uygulama health endpoint'ini kontrol et.

## Otomasyon Scriptleri

Oncelikli kullanim (Linux/Mac/Windows):

- Docs senkronu: `make docs-sync-59` ve `make docs-sync-511`
- Docs index rebuild: `make docs-build`
- CI local check: `make ci`
- Release status report: `make release-status`
- MCP smoke test: `make smoke-mcp`

PowerShell alternatifleri:

- Docs senkronu: `pwsh ./phalcondocs/scripts/sync-docs.ps1 -Version 5.9`
- Docs senkronu: `pwsh ./phalcondocs/scripts/sync-docs.ps1 -Version 5.11`
- Docs index rebuild: `pwsh ./phalcondocs/scripts/build-index.ps1`
- Cross-agent drift: `pwsh ./scripts/check-agent-drift.ps1`
- MCP contracts check: `pwsh ./scripts/check-mcp-contracts.ps1`
- Phalcon-first check: `pwsh ./scripts/check-phalcon-first.ps1`
- PhalconDocs index check: `pwsh ./scripts/check-phalcondocs-index.ps1`
- MCP smoke test: `pwsh ./scripts/smoke-mcp.ps1`
- CI local check: `pwsh ./scripts/ci-check.ps1`
- Release status report: `pwsh ./scripts/release-status.ps1`
- Basic kit local run: `php -S localhost:8081 -t starter-kits/basic/public`

## Docker Senaryo Kullanimi

- Base stack: `docker compose -f docker/compose/docker-compose.yml up -d`
- Senaryo override ornegi:
  - `docker compose -f docker/compose/docker-compose.yml -f docker/compose/basic/docker-compose.override.yml up -d`
  - `docker compose -f docker/compose/docker-compose.yml -f docker/compose/invo/docker-compose.override.yml up -d`
  - `docker compose -f docker/compose/docker-compose.yml -f docker/compose/rest/docker-compose.override.yml up -d`
  - `docker compose -f docker/compose/docker-compose.yml -f docker/compose/vokuro/docker-compose.override.yml up -d`

## Ariza Durumlari

- PHP extension eksigi: image build kontrolu ve startup check.
- DB baglanti hatasi: servis health + env degerleri kontrolu.
