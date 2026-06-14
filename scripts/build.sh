#!/usr/bin/env bash
# Build the Russian Linux kernel documentation site.
#
# Strategy (overlay): clone torvalds/linux at the pinned tag for the build inputs
# Sphinx needs (custom extensions, scripts, MAINTAINERS, and the C/H sources that
# kernel-doc directives extract from), then overlay our translated .rst files from
# ru/Documentation/ on top of the kernel's Documentation/ tree. Files we have not
# translated yet remain English, so the site always builds and becomes progressively
# Russian. Finally run the kernel's own sphinx-build-wrapper with language=ru.
#
# Usage:
#   scripts/build.sh                 # build the whole tree (SPHINXDIRS=".")
#   scripts/build.sh process mm      # build only these top-level sections (fast)
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
# shellcheck disable=SC1091
source "$ROOT/KERNEL_PIN"

BUILD="$ROOT/build"
LINUX="$BUILD/linux"
VENV="$ROOT/.venv"
OVERLAY="$ROOT/ru/Documentation"

# 1. Toolchain
[ -x "$VENV/bin/sphinx-build" ] || "$ROOT/scripts/setup-venv.sh"

# 2. Pinned kernel checkout (shallow). Re-clone if the pin changed.
need_clone=1
if [ -d "$LINUX/.git" ]; then
  cur="$(git -C "$LINUX" rev-parse HEAD 2>/dev/null || true)"
  [ "$cur" = "$KERNEL_SHA" ] && need_clone=0
fi
if [ "$need_clone" = 1 ]; then
  echo ">> Cloning $KERNEL_REPO @ $KERNEL_TAG (shallow)"
  rm -rf "$LINUX"
  git clone --depth 1 --branch "$KERNEL_TAG" --single-branch "$KERNEL_REPO" "$LINUX"
fi

# 3. Overlay translated docs (no --delete: untranslated files stay English).
echo ">> Overlaying translated docs from $OVERLAY"
mkdir -p "$OVERLAY"
rsync -a "$OVERLAY/" "$LINUX/Documentation/"

# 4. Build with the kernel's own wrapper, forcing Russian UI + search.
cd "$LINUX"
export PATH="$VENV/bin:$PATH"
export srctree="."
export KERNELVERSION="$KERNEL_TAG" KERNELRELEASE="$KERNEL_TAG"
export LC_ALL="${LC_ALL:-en_US.UTF-8}"
export SPHINXOPTS="${SPHINXOPTS:-} -D language=ru"

if [ "$#" -gt 0 ]; then
  SPHINXDIRS="$*"
else
  SPHINXDIRS="."
fi

echo ">> Building htmldocs (SPHINXDIRS=\"$SPHINXDIRS\")"
python tools/docs/sphinx-build-wrapper htmldocs --sphinxdirs $SPHINXDIRS --builddir output -j auto

echo ">> Done. HTML output under: $LINUX/output/"
