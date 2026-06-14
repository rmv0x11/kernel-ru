#!/usr/bin/env bash
# Create the Python venv with the Sphinx toolchain needed to build the docs.
# The kernel's Documentation/sphinx/requirements.txt is unpinned (alabaster, Sphinx,
# pyyaml); the current Sphinx (9.x) builds the v7.0 docs fine on Python >= 3.12.
set -euo pipefail
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
VENV="$ROOT/.venv"

# Prefer a real Python release over the system default (which may be a pre-release).
PY=""
for c in python3.14 python3.13 python3.12 python3; do
  if command -v "$c" >/dev/null 2>&1; then PY="$c"; break; fi
done
[ -n "$PY" ] || { echo "No suitable python3 found" >&2; exit 1; }

if [ ! -d "$VENV" ]; then
  echo "Creating venv at $VENV using $PY ($($PY --version 2>&1))"
  "$PY" -m venv "$VENV"
fi
"$VENV/bin/pip" install --quiet --upgrade pip
"$VENV/bin/pip" install --quiet alabaster Sphinx pyyaml
"$VENV/bin/sphinx-build" --version
echo "venv ready: $VENV"
