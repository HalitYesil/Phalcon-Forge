#!/usr/bin/env bash
set -euo pipefail

root="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
manifest="$root/phalcondocs/index/manifest.json"
symbols="$root/phalcondocs/index/symbols.json"

[[ -f "$manifest" ]] || { echo "Manifest bulunamadi: $manifest" >&2; exit 1; }

php -r '
$manifest = json_decode(file_get_contents($argv[1]), true);
if (!is_array($manifest)) { fwrite(STDERR, "Invalid manifest\n"); exit(1); }
$result = [
  "sourcePolicy" => [
    "strictUrlOnly" => true,
    "allowInference" => false,
    "allowCrossVersionMerge" => false
  ],
  "versions" => []
];
foreach (["5.9", "5.11"] as $v) {
  $e = $manifest["lockedSources"][$v] ?? null;
  if (!is_array($e)) { continue; }
  $result["versions"][$v] = [
    "sourceUrl" => $e["introduction"] ?? "",
    "repositoryBranch" => $e["branch"] ?? "",
    "symbols" => [[
      "name" => "Phalcon",
      "type" => "namespace",
      "note" => "Derived from locked introduction source only."
    ]]
  ];
}
file_put_contents($argv[2], json_encode($result, JSON_PRETTY_PRINT | JSON_UNESCAPED_SLASHES) . PHP_EOL);
' "$manifest" "$symbols"

echo "Index rebuilt: phalcondocs/index/symbols.json"
