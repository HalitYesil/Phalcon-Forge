#!/usr/bin/env bash
set -euo pipefail

root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
tools_dir="$root/mcp-server/tools"

[[ -d "$tools_dir" ]] || { echo "Tools directory bulunamadi." >&2; exit 1; }

php -r '
$root = $argv[1];
$files = glob($root . "/mcp-server/tools/*.json");
if (!$files) { fwrite(STDERR, "No MCP tool files\n"); exit(1); }
foreach ($files as $file) {
  $j = json_decode(file_get_contents($file), true);
  if (!is_array($j)) { fwrite(STDERR, "Invalid JSON: $file\n"); exit(2); }
  foreach (["name","description","inputSchema","outputSchemaPath"] as $req) {
    if (!array_key_exists($req, $j)) { fwrite(STDERR, "Missing $req: $file\n"); exit(3); }
  }
  if (($j["inputSchema"]["type"] ?? "") !== "object") { fwrite(STDERR, "inputSchema.type invalid: $file\n"); exit(4); }
  foreach (["properties","required","additionalProperties"] as $k) {
    if (!array_key_exists($k, $j["inputSchema"])) { fwrite(STDERR, "inputSchema.$k missing: $file\n"); exit(5); }
  }
  $schema = $root . "/mcp-server/" . $j["outputSchemaPath"];
  if (!file_exists($schema)) { fwrite(STDERR, "Output schema missing: $schema\n"); exit(6); }
  $s = json_decode(file_get_contents($schema), true);
  if (!is_array($s)) { fwrite(STDERR, "Invalid output schema JSON: $schema\n"); exit(7); }
  if (($s["type"] ?? "") !== "object") { fwrite(STDERR, "Output schema type invalid: $schema\n"); exit(8); }
  if (!array_key_exists("required", $s)) { fwrite(STDERR, "Output schema required missing: $schema\n"); exit(9); }
  if (($s["additionalProperties"] ?? null) !== false) { fwrite(STDERR, "Output schema additionalProperties must be false: $schema\n"); exit(10); }
}
' "$root"

echo "MCP contracts check passed."
