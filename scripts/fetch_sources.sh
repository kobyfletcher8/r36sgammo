#!/usr/bin/env bash
set -euo pipefail

DEST="${1:-$PWD/gammaos-r36s}"
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
LOG="$DEST/port-fetch.log"
mkdir -p "$DEST"
exec > >(tee -a "$LOG") 2>&1

echo "== GammaOS Core R36S source fetch =="

echo "Destination: $DEST"

if [[ -e "$DEST/.git" ]]; then
  echo "Existing Git tree detected; refusing to overwrite it."
  echo "Run with a new destination or remove it manually after making a backup."
  exit 2
fi

git clone --branch develop --single-branch https://github.com/TheGammaSqueeze/GammaOSCoreDistribution.git "$DEST"
cd "$DEST"

mkdir -p device/gameconsole kernel/gameconsole

clone_or_update() {
  local url="$1" path="$2" branch="$3"
  if [[ -d "$path/.git" ]]; then
    git -C "$path" fetch --depth=1 origin "$branch"
    git -C "$path" checkout -B "$branch" "origin/$branch"
  else
    rm -rf "$path"
    git clone --depth=1 --branch "$branch" "$url" "$path"
  fi
}

clone_or_update https://github.com/andr36oid/android_device_gameconsole_common.git \
  device/gameconsole/common lineage-18.1
clone_or_update https://github.com/andr36oid/android_device_gameconsole_r36s.git \
  device/gameconsole/r36s lineage-18.1
clone_or_update https://github.com/andr36oid/android_kernel_gameconsole_r36s.git \
  kernel/gameconsole/r36s lineage-18.1

mkdir -p device/gamma/r36s
cp "$SCRIPT_DIR/../device/gamma/r36s/AndroidProducts.mk" device/gamma/r36s/
cp "$SCRIPT_DIR/../device/gamma/r36s/BoardConfig.mk" device/gamma/r36s/
cp "$SCRIPT_DIR/../device/gamma/r36s/gammaos_r36s.mk" device/gamma/r36s/

printf '\nFetched revisions:\n'
printf 'GammaOSCoreDistribution: '; git rev-parse HEAD
printf 'R36S common: '; git -C device/gameconsole/common rev-parse HEAD
printf 'R36S device: '; git -C device/gameconsole/r36s rev-parse HEAD
printf 'R36S kernel: '; git -C kernel/gameconsole/r36s rev-parse HEAD

echo "Fetch complete."
