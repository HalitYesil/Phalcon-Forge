# Release Notes v0.1.0

## Ozet

`v0.1.0`, Phalcon geliştiricileri icin cross-agent uyumlu bir skill/starter/docs/MCP temelini yayinlar.

## Bu Sürümde Neler Var

- 4 ayri starter-kit senaryosu (`basic`, `invo`, `rest`, `vokuro`)
- Resmi dokuman odakli PhalconDocs index altyapisi
- MCP tool sozlesmeleri + local runtime + smoke test
- Docker runtime ve operasyon runbook'u
- Release ve kalite kontrolleri icin script tabanli CI hatti

## Breaking Change

Bu ilk stabil milestone oldugu icin onceki surumle kirici degisiklik tanimi yoktur.

## Bilinen Sinirlar

- MCP server local runtime seviyesindedir; production deployment kapsam disidir.
- Phalcon API envanteri kademeli olarak genisletilecektir.

## Oncesinde Calistirilmasi Onerilen Komutlar

1. `pwsh ./scripts/release-status.ps1`
2. `pwsh ./scripts/ci-check.ps1`
