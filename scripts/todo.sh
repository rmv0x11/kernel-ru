#!/usr/bin/env bash
# List Documentation .rst files not yet translated: present in the pinned kernel
# (git, so unaffected by the build overlay) but absent from ru/Documentation/,
# excluding the upstream translations/ tree. This is the durable source of truth
# for "what is left", so the project can be resumed at any time with no saved list.
#
# Usage:
#   scripts/todo.sh                # print remaining count (stderr) + all paths
#   scripts/todo.sh 150 json       # emit a JSON array of the next 150 paths
#   scripts/todo.sh | sed 's#/.*##' | sort | uniq -c | sort -rn   # by section
set -euo pipefail
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
LINUX="$ROOT/build/linux"

git -C "$LINUX" ls-files Documentation \
  | grep '\.rst$' \
  | sed 's#^Documentation/##' \
  | grep -v '^translations/' \
  | sort -u > /tmp/_all_rst.txt

( cd "$ROOT/ru/Documentation" 2>/dev/null && find . -name '*.rst' | sed 's#^\./##' | sort -u ) \
  > /tmp/_done_rst.txt || : > /tmp/_done_rst.txt

comm -23 /tmp/_all_rst.txt /tmp/_done_rst.txt > /tmp/_todo_rst.txt
n=$(wc -l < /tmp/_todo_rst.txt | tr -d ' ')

if [ "${2:-}" = "json" ]; then
  head -n "${1:-100}" /tmp/_todo_rst.txt \
    | python3 -c "import sys,json;print(json.dumps([l.strip() for l in sys.stdin if l.strip()]))"
else
  echo "Remaining untranslated: $n  (translated: $(wc -l < /tmp/_done_rst.txt | tr -d ' ') / $(wc -l < /tmp/_all_rst.txt | tr -d ' '))" >&2
  cat /tmp/_todo_rst.txt
fi
