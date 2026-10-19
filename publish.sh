#!/usr/bin/env bash
# Copy the latest built booklet into this GitHub Pages site and push it.
#   (cd ../graphics/digital-booklet && python3 build.py)   # rebuild first if content changed
#   ./publish.sh            # copy + commit + push
#   NOPUSH=1 ./publish.sh   # copy + commit only
set -euo pipefail
cd "$(dirname "$0")"
SRC=../graphics/digital-booklet

cp "$SRC/out/booklet.pdf" booklet.pdf
cp "$SRC/assets/sgc-logo.svg" "$SRC/assets/sgc-logo-white.svg" "$SRC/assets/network-pattern.svg" .
pdftocairo -png -singlefile -f 1 -l 1 -scale-to-x 510 -scale-to-y -1 booklet.pdf cover

git add -A
if git diff --cached --quiet; then echo "Nothing changed."; exit 0; fi
git commit -q -m "Update booklet ($(date +%F))"
[ "${NOPUSH:-0}" = 1 ] || git push -q
git log --oneline -1
