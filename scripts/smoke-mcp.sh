#!/usr/bin/env bash
set -euo pipefail

root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
server="$root/mcp-server/server.php"

[[ -f "$server" ]] || { echo "MCP server bulunamadi: $server" >&2; exit 1; }
command -v php >/dev/null 2>&1 || { echo "php command bulunamadi." >&2; exit 1; }

out="$(php -r '
$server = $argv[1];
$desc = [0 => ["pipe","r"], 1 => ["pipe","w"], 2 => ["pipe","w"]];
$proc = proc_open("php " . escapeshellarg($server), $desc, $pipes);
if (!is_resource($proc)) { fwrite(STDERR, "proc_open failed\n"); exit(1); }
$reqs = [
  ["id"=>"1","tool"=>"get_starter_scenario","arguments"=>["name"=>"rest"]],
  ["id"=>"2","tool"=>"get_methods_by_category","arguments"=>["category"=>"orm","version"=>"5.11"]],
  ["id"=>"3","tool"=>"doctor_runtime","arguments"=>["target"=>"dev","scenario"=>"basic"]],
];
foreach ($reqs as $r) fwrite($pipes[0], json_encode($r) . PHP_EOL);
fclose($pipes[0]);
$lines = [];
while (($line = fgets($pipes[1])) !== false) {
  $line = trim($line);
  if ($line !== "") $lines[] = $line;
}
$stderr = stream_get_contents($pipes[2]);
fclose($pipes[1]); fclose($pipes[2]);
$code = proc_close($proc);
if ($code !== 0) { fwrite(STDERR, "server exited $code: $stderr\n"); exit(2); }
if (count($lines) < 3) { fwrite(STDERR, "expected >=3 responses\n"); exit(3); }
foreach ($lines as $line) {
  $j = json_decode($line, true);
  if (!is_array($j) || isset($j["error"]) || !isset($j["result"])) {
    fwrite(STDERR, "invalid response: $line\n"); exit(4);
  }
}
echo "ok";
' "$server")"

[[ "$out" == "ok" ]] || { echo "MCP smoke failed." >&2; exit 1; }
echo "MCP smoke test passed."
