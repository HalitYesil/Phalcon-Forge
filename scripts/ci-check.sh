#!/usr/bin/env bash
set -euo pipefail

root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

bash "$root/scripts/check-agent-drift.sh"
bash "$root/scripts/check-source-policy.sh"
bash "$root/scripts/check-starter-structure.sh"
bash "$root/scripts/check-mcp-contracts.sh"
bash "$root/scripts/check-phalcon-first.sh"
bash "$root/scripts/check-phalcondocs-index.sh"
bash "$root/scripts/smoke-mcp.sh"

echo "CI checks passed."
