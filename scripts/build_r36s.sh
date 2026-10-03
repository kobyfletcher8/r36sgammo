#!/usr/bin/env bash
set -u
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
TREE="${1:-$PWD}"
cd "$TREE"
STAMP="$(date -u +%Y%m%d-%H%M%S)"
LOG="build-r36s-$STAMP.log"

exec > >(tee -a "$LOG") 2>&1

echo "== GammaOS Core R36S build =="
echo "Tree: $TREE"

echo "== Environment =="
uname -a
java -version 2>&1 || true

if [[ ! -f build/envsetup.sh ]]; then
  echo "Missing build/envsetup.sh"
  exit 2
fi

# Keep the proven R36S hardware repos visible and fail early if missing.
for p in device/gameconsole/common device/gameconsole/r36s kernel/gameconsole/r36s device/gamma/r36s; do
  if [[ ! -e "$p" ]]; then
    echo "Missing required path: $p"
    exit 3
  fi
done

source build/envsetup.sh

# Product discovery check.
if ! lunch gammaos_r36s-userdebug; then
  echo "PRODUCT PARSE FAILED"
  exit 10
fi

set -o pipefail
{
  echo "== build variables =="
  get_build_var TARGET_PRODUCT || true
  get_build_var TARGET_ARCH || true
  get_build_var TARGET_BOARD_PLATFORM || true
  get_build_var TARGET_SOC || true
  get_build_var TARGET_KERNEL_SOURCE || true
  echo
  echo "== bootstrap =="
  m nothing
  echo
  echo "== system image =="
  m systemimage
  echo
  echo "== boot image =="
  m bootimage
} 2>&1 | tee -a "$LOG"
RC=${PIPESTATUS[0]}

if [[ $RC -ne 0 ]]; then
  echo "Build failed with rc=$RC"
  echo "Running failure collector..."
  "$SCRIPT_DIR/collect_failure.sh" "$TREE" 2>/dev/null || true
  exit $RC
fi

echo "Build stages completed. No flashing was attempted."
