.PHONY: help ci release-status docs-build docs-sync-59 docs-sync-511 smoke-mcp

help:
	@echo "Phalcon Forge - Make targets"
	@echo "  make ci             -> tum kalite kontrolleri"
	@echo "  make release-status -> release readiness ozeti"
	@echo "  make docs-build     -> phalcondocs symbols index uretimi"
	@echo "  make docs-sync-59   -> docs repo 5.9.x sync metadata"
	@echo "  make docs-sync-511  -> docs repo 5.11.x sync metadata"
	@echo "  make smoke-mcp      -> mcp runtime smoke test"

ci:
	@bash scripts/ci-check.sh

release-status:
	@bash scripts/release-status.sh

docs-build:
	@bash phalcondocs/scripts/build-index.sh

docs-sync-59:
	@bash phalcondocs/scripts/sync-docs.sh 5.9

docs-sync-511:
	@bash phalcondocs/scripts/sync-docs.sh 5.11

smoke-mcp:
	@bash scripts/smoke-mcp.sh
