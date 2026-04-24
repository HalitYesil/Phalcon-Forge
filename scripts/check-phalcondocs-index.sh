#!/usr/bin/env bash
set -euo pipefail

root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
required=(
  "phalcondocs/index/manifest.json"
  "phalcondocs/index/symbols.json"
  "phalcondocs/index/methods-by-category.json"
  "phalcondocs/index/scenarios.json"
  "phalcondocs/sources/5.9/introduction.md"
  "phalcondocs/sources/5.11/introduction.md"
)

failed=0
for rel in "${required[@]}"; do
  if [[ ! -f "$root/$rel" ]]; then
    echo "Eksik PhalconDocs dosyasi: $rel" >&2
    failed=1
  fi
done

[[ $failed -eq 0 ]] || exit 1
echo "PhalconDocs index check passed."
