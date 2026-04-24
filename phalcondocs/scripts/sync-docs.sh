#!/usr/bin/env bash
set -euo pipefail

version="${1:-}"
if [[ "$version" != "5.9" && "$version" != "5.11" ]]; then
  echo "Kullanim: $0 <5.9|5.11>" >&2
  exit 1
fi

root="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
repo_url="https://github.com/phalcon/documentation.git"
branch="5.9.x"
[[ "$version" == "5.11" ]] && branch="5.11.x"

tmp="$root/.tmp"
target="$root/phalcondocs/sources/$version"
worktree="$tmp/documentation-$version"

mkdir -p "$tmp" "$target"
rm -rf "$worktree"

git clone --depth 1 --branch "$branch" "$repo_url" "$worktree" >/dev/null 2>&1 || {
  echo "Clone basarisiz: $repo_url $branch" >&2
  exit 1
}

php -r '
$meta = [
  "version" => $argv[1],
  "branch" => $argv[2],
  "repository" => $argv[3],
  "syncedAtUtc" => gmdate("c")
];
file_put_contents($argv[4], json_encode($meta, JSON_PRETTY_PRINT | JSON_UNESCAPED_SLASHES) . PHP_EOL);
' "$version" "$branch" "$repo_url" "$target/sync-meta.json"

echo "Sync metadata written: phalcondocs/sources/$version/sync-meta.json"
