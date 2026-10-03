#!/usr/bin/env bash
set -uo pipefail
TREE="${1:-$PWD}"
cd "$TREE"
OUT="gammaos-r36s-android13-audit.txt"
{
  echo "GammaOS Core R36S Android 13 audit"
  echo "UTC: $(date -u +%Y-%m-%dT%H:%M:%SZ)"
  echo
  echo "== Product/device trees =="
  find device/gamma/r36s device/gameconsole/r36s device/gameconsole/common -maxdepth 3 -type f 2>/dev/null | sort || true
  echo
  echo "== Legacy Android 11 fingerprints =="
  grep -RInE 'PLATFORM_VERSION.?11|RP1A\.201005|PRIVATE_BUILD_DESC=.*11 |lineage_r36s' device/gamma/r36s device/gameconsole 2>/dev/null || true
  echo
  echo "== Old Rockchip/vendor assumptions =="
  grep -RInE 'rk3566|rk3568|3566' device/gamma/r36s device/gameconsole kernel/gameconsole/r36s 2>/dev/null || true
  echo
  echo "== R36S architecture/kernel settings =="
  grep -RInE 'TARGET_ARCH|TARGET_KERNEL_SOURCE|TARGET_KERNEL_CONFIG|BOARD_KERNEL|TARGET_BOARD_PLATFORM|TARGET_SOC' \
    device/gamma/r36s device/gameconsole/r36s device/gameconsole/common 2>/dev/null || true
  echo
  echo "== VINTF / SEPolicy =="
  find device/gameconsole/r36s device/gameconsole/common -type f \( -name '*manifest*.xml' -o -name '*matrix*.xml' -o -path '*/sepolicy/*' \) 2>/dev/null | sort || true
  echo
  echo "== GammaOS-specific product candidates =="
  grep -RInE 'GammaOS|gammaos|performance_mode|gammargb|trimui_inputd|daijisho|retroarch' \
    device vendor packages frameworks system 2>/dev/null | head -n 300 || true
} | tee "$OUT"

echo "Audit written to $TREE/$OUT"
