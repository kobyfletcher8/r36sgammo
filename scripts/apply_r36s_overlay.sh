#!/usr/bin/env bash
set -euo pipefail
TREE="${1:-$PWD}"
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

cd "$TREE"
if [[ ! -f build/envsetup.sh ]]; then
  echo "Not an Android source tree: $TREE"
  exit 2
fi

mkdir -p device/gamma/r36s
cp "$SCRIPT_DIR/../device/gamma/r36s/"*.mk device/gamma/r36s/

# Ensure the Android tree sees the new product directory.
# Android product discovery normally scans AndroidProducts.mk under device/*/*.
# No global build-file edits are made here.

cat > .gammaos_r36s_port_state <<STATE
GAMMAOS_R36S_PORT=1
TREE=$TREE
CREATED=$(date -u +%Y-%m-%dT%H:%M:%SZ)
STATE

echo "R36S overlay installed."
