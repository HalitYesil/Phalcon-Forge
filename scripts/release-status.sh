#!/usr/bin/env bash
set -euo pipefail

root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
checks=(
  "Source policy:bash $root/scripts/check-source-policy.sh"
  "Starter structure:bash $root/scripts/check-starter-structure.sh"
  "Phalcon-first:bash $root/scripts/check-phalcon-first.sh"
  "MCP contracts:bash $root/scripts/check-mcp-contracts.sh"
  "PhalconDocs index:bash $root/scripts/check-phalcondocs-index.sh"
  "MCP smoke:bash $root/scripts/smoke-mcp.sh"
  "Full CI:bash $root/scripts/ci-check.sh"
)

pass=0
total=${#checks[@]}
printf "\nRelease Status (v0.1)\n---------------------\n"
for entry in "${checks[@]}"; do
  name="${entry%%:*}"
  cmd="${entry#*:}"
  if eval "$cmd" >/dev/null 2>&1; then
    printf "%-20s PASS\n" "$name"
    pass=$((pass+1))
  else
    printf "%-20s FAIL\n" "$name"
  fi
done
printf "---------------------\nSummary: %d/%d PASS\n" "$pass" "$total"

[[ $pass -eq $total ]]
