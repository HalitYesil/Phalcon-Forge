#!/usr/bin/env bash
set -euo pipefail

root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
common="$root/agents/common/policy.md"
adapters=(
  "$root/agents/adapters/cursor.md"
  "$root/agents/adapters/claude.md"
  "$root/agents/adapters/codex.md"
)
keywords=("sanitize" "escape" "Phalcon" "custom")

[[ -f "$common" ]] || { echo "Missing common policy: $common" >&2; exit 1; }

failed=0
for adapter in "${adapters[@]}"; do
  [[ -f "$adapter" ]] || { echo "Missing adapter: $adapter" >&2; failed=1; continue; }
  for kw in "${keywords[@]}"; do
    if ! grep -q "$kw" "$adapter"; then
      echo "Adapter drift: $adapter missing keyword '$kw'" >&2
      failed=1
    fi
  done
done

[[ $failed -eq 0 ]] || exit 1
echo "Cross-agent drift check passed."
