#!/usr/bin/env bash
set -euo pipefail

root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
if grep -R --line-number --include="*.php" "filter_var(" "$root/starter-kits" >/dev/null 2>&1; then
  echo "Phalcon-first ihlali: filter_var() kullanimi bulundu." >&2
  grep -R --line-number --include="*.php" "filter_var(" "$root/starter-kits" || true
  exit 1
fi

echo "Phalcon-first check passed."
