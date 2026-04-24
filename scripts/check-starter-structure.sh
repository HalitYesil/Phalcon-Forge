#!/usr/bin/env bash
set -euo pipefail

root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
starter="$root/starter-kits"
scenarios=(basic invo rest vokuro)
required=(app public config tests composer.json)

[[ -d "$starter" ]] || { echo "starter-kits dizini bulunamadi." >&2; exit 1; }

failed=0
for s in "${scenarios[@]}"; do
  for item in "${required[@]}"; do
    if [[ ! -e "$starter/$s/$item" ]]; then
      echo "Eksik: starter-kits/$s/$item" >&2
      failed=1
    fi
  done
done

[[ $failed -eq 0 ]] || exit 1
echo "Starter structure check passed."
