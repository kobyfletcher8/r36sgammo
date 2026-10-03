#!/usr/bin/env bash
set -uo pipefail
TREE="${1:-$PWD}"
cd "$TREE"
STAMP="$(date -u +%Y%m%d-%H%M%S)"
OUT="port-failure-$STAMP"
mkdir -p "$OUT"

{
  echo "== source =="
  git rev-parse --show-toplevel 2>/dev/null || true
  git rev-parse HEAD 2>/dev/null || true
  git status --short 2>/dev/null || true
  echo
  echo "== repo revisions =="
  for d in device/gameconsole/common device/gameconsole/r36s kernel/gameconsole/r36s; do
    echo "[$d]"
    git -C "$d" rev-parse HEAD 2>/dev/null || true
  done
  echo
  echo "== product files =="
  sed -n '1,220p' device/gamma/r36s/*.mk 2>/dev/null || true
  echo
  echo "== recent out errors =="
  find out -type f \( -name error.log -o -name '*.log' \) -print0 2>/dev/null | xargs -0 -r tail -n 250 || true
} > "$OUT/state.txt"

find out -type f -name 'error.log' -o -name 'soong.log' 2>/dev/null | while read -r f; do
  cp --parents "$f" "$OUT" 2>/dev/null || true
done

tar -czf "$OUT.tar.gz" "$OUT"
echo "Collected: $OUT.tar.gz"
