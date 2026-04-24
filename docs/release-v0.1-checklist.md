# Release v0.1 Checklist

Bu dokuman, `v0.1` cikarimi icin tamamlanmasi gereken maddeleri ve kabul kriterlerini tanimlar.

## 1) Kaynak ve Politika

- [ ] `docs/source-policy.md` guncel
- [ ] `phalcondocs/index/manifest.json` strict source policy aktif
- [ ] `5.9` ve `5.11` locked source kayitlari dogru
- [ ] `6.0.x` planned olarak isaretli

Kabul kriteri:
- Surum karisimi yok
- `allowInference=false`, `allowCrossVersionMerge=false`

## 2) Starter-Kits

- [ ] `starter-kits/basic` hazir
- [ ] `starter-kits/invo` hazir
- [ ] `starter-kits/rest` hazir
- [ ] `starter-kits/vokuro` hazir
- [ ] Tum senaryolarda `composer.json` mevcut
- [ ] Zorunlu klasorler: `app`, `public`, `config`, `tests`

Kabul kriteri:
- `bash ./scripts/check-starter-structure.sh` veya `pwsh ./scripts/check-starter-structure.ps1` basarili

## 3) Guvenlik Baseline

- [ ] Input sanitize/validate akislari mevcut
- [ ] Security headers kullanimlari mevcut
- [ ] Secrets hardcode degil, `.env`/env akisi var
- [ ] Phalcon-first kurali aktif

Kabul kriteri:
- `bash ./scripts/check-phalcon-first.sh` veya `pwsh ./scripts/check-phalcon-first.ps1` basarili

## 4) MCP Sozlesmeleri ve Runtime

- [ ] Tool input schema'lari tanimli
- [ ] Tool output schema'lari tanimli
- [ ] Tum tool dosyalarinda `outputSchemaPath` var
- [ ] `mcp-server/server.php` local runtime calisiyor
- [ ] MCP smoke test geciyor

Kabul kriteri:
- `bash ./scripts/check-mcp-contracts.sh` veya `pwsh ./scripts/check-mcp-contracts.ps1` basarili
- `bash ./scripts/smoke-mcp.sh` veya `pwsh ./scripts/smoke-mcp.ps1` basarili

## 5) PhalconDocs Index

- [ ] `phalcondocs/index/symbols.json` var
- [ ] `phalcondocs/index/methods-by-category.json` var
- [ ] `phalcondocs/index/scenarios.json` var
- [ ] Build script calisiyor

Kabul kriteri:
- `bash ./phalcondocs/scripts/build-index.sh` veya `pwsh ./phalcondocs/scripts/build-index.ps1` basarili
- `bash ./scripts/check-phalcondocs-index.sh` veya `pwsh ./scripts/check-phalcondocs-index.ps1` basarili

## 6) Docker ve Operasyon

- [ ] `docker/php/Dockerfile` ile Phalcon extension kurulumlu image
- [ ] `docker/compose/docker-compose.yml` env tabanli config
- [ ] Senaryo override dosyalari mevcut (`basic/invo/rest/vokuro`)
- [ ] Runbook komutlari guncel

Kabul kriteri:
- `docker compose` stack baslatma adimlari dokumante

## 7) CI ve Otomasyon

- [ ] `scripts/ci-check.ps1` tum kontrolleri iceriyor
- [ ] GitHub Actions workflow tanimli
- [ ] CI icinde PHP setup adimi var

Kabul kriteri:
- `make ci` veya `pwsh ./scripts/ci-check.ps1` lokalde basarili
- PR CI job basarili

## Release Komutu (Onerilen Sira)

1. `make ci`
2. `make docs-build`
3. `make ci` (tekrar dogrulama)
4. Version bump + changelog guncelleme
5. `v0.1.0` tag

## Otomatik Durum Raporu

- Tum release kontrollerini tek komutta ozetlemek icin:
  - `make release-status` (alternatif: `pwsh ./scripts/release-status.ps1`)

## v0.1 Scope Disi

- Tam uretim seviye MCP deployment
- Tum Phalcon sinif/metod envanterinin eksiksiz doldurulmasi
- 6.0.x aktif index entegrasyonu
