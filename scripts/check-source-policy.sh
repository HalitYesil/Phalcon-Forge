#!/usr/bin/env bash
set -euo pipefail

root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
manifest="$root/phalcondocs/index/manifest.json"

[[ -f "$manifest" ]] || { echo "Manifest bulunamadi: $manifest" >&2; exit 1; }

php -r '
$m = json_decode(file_get_contents($argv[1]), true);
if (!is_array($m)) { fwrite(STDERR, "Invalid manifest JSON\n"); exit(1); }
if (($m["sourcePolicy"]["mode"] ?? "") !== "strict_url_only") exit(2);
if (($m["sourcePolicy"]["allowInference"] ?? true) !== false) exit(3);
if (($m["sourcePolicy"]["allowCrossVersionMerge"] ?? true) !== false) exit(4);
foreach (["5.9","5.11"] as $v) {
  if (!isset($m["lockedSources"][$v]["introduction"], $m["lockedSources"][$v]["localSnapshot"])) exit(5);
}
' "$manifest" || { echo "Source policy check failed." >&2; exit 1; }

echo "Source policy check passed."
