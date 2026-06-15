#!/usr/bin/env bash
# Verify that the current translation builds cleanly: apply the heading fixer, run a
# full (incremental) build, and report any warning NOT present in the English baseline
# fingerprint (scripts/baseline-warnings.txt) -- those are translation regressions.
#
# Exit 0 and "clean" => safe to deploy. Exit 1 => regressions or build failure listed.
set -euo pipefail
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
LOG="$ROOT/build/verify.log"
BASE="$ROOT/scripts/baseline-warnings.txt"
VENV="$ROOT/.venv"

# 1. Apply the deterministic RST fixers to all translated files:
#    - fix_headings.py: lengthen section-title underlines (stdlib only);
#    - fix_lists.py: insert the blank line RST needs between a multi-line paragraph
#      and an indented list (docutils-driven, so run with the venv's python).
if find "$ROOT/ru/Documentation" -name '*.rst' -print -quit | grep -q .; then
  PYBIN="python3"; [ -x "$VENV/bin/python" ] && PYBIN="$VENV/bin/python"
  find "$ROOT/ru/Documentation" -name '*.rst' -print0 \
    | xargs -0 python3 "$ROOT/scripts/fix_headings.py" >/dev/null || true
  find "$ROOT/ru/Documentation" -name '*.rst' -print0 \
    | xargs -0 "$PYBIN" "$ROOT/scripts/fix_lists.py" >/dev/null || true
fi

# 2. Full incremental build (re-reads only changed docs; ~fast with warm doctree).
if ! "$ROOT/scripts/build.sh" >"$LOG" 2>&1; then
  echo "=== BUILD FAILED — last 40 lines of $LOG ==="
  tail -40 "$LOG"
  exit 1
fi

# 3. Normalize warnings (strip abs path + line numbers) and diff against baseline.
norm() { grep -E "WARNING|ERROR" "$1" | sed -E "s#^.*/build/linux/##; s/:[0-9]+//g" | sort -u; }
new="$(comm -13 "$BASE" <(norm "$LOG") || true)"

if [ -n "$new" ]; then
  echo "=== NEW warnings introduced by translation (fix these) ==="
  echo "$new"
  exit 1
fi
echo "=== Clean: no new warnings vs English baseline ($(wc -l < "$BASE" | tr -d ' ') baseline entries) ==="
echo "Output: $ROOT/build/linux/output/index.html"
