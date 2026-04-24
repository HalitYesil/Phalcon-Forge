# Changelog

Bu dosya projedeki onemli degisiklikleri tutar.

## [0.1.0] - 2026-04-23

### Added

- Monorepo iskeleti: `skill`, `starter-kits`, `phalcondocs`, `mcp-server`, `docker`, `agents`, `docs`
- Dört starter-kit senaryosu:
  - `basic` (minimal)
  - `invo` (domain odakli)
  - `rest` (API-first)
  - `vokuro` (auth/session)
- Cross-agent yorege katmani: `agents/common` + `agents/adapters`
- PhalconDocs strict source policy (5.9 / 5.11 URL lock, no inference, no cross-version merge)
- MCP tool input/output sozlesmeleri ve local runtime (`mcp-server/server.php`)
- Docker tabanli calisma katmani (Phalcon extension kurulumlu PHP image)
- CI ve kalite scriptleri:
  - `check-agent-drift`
  - `check-source-policy`
  - `check-starter-structure`
  - `check-mcp-contracts`
  - `check-phalcon-first`
  - `check-phalcondocs-index`
  - `smoke-mcp`
  - `ci-check`
  - `release-status`

### Security

- Input sanitize/validate ve security headers baseline'i starter-kitlerde uygulandi.
- Secretlerin env uzerinden yonetimi icin `.env.example` eklendi.

### Docs

- Senaryo secim matrisi, runbook, source policy ve release checklist dokumanlari eklendi.
