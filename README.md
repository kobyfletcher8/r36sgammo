# GammaOS Core → R36S (RK3326) Port Kit

This is a **porting overlay/harness**, not a prebuilt ROM. It uses the public GammaOSCoreDistribution `develop` tree as the Android 13/GammaOS source and keeps the R36S hardware implementation separate.

## Target

- Device: Anbernic/R36S class handheld
- SoC: Rockchip RK3326
- CPU arch: arm64 / AArch64
- Display: 640x480
- Existing hardware source: andr36oid R36S LineageOS 18.1 device/common/kernel trees
- GammaOS base: GammaOSCoreDistribution `develop`

## Important architecture decision

Do **not** transplant an RK3566 vendor tree onto the R36S. GammaOS Core currently targets Android 13 TV and has established RK3566/A133P device support, while the R36S hardware support is a separate RK3326 LineageOS tree. The port therefore keeps the R36S kernel/device/vendor pieces and ports the GammaOS system/product layer on top.

The first milestone is to make a clean `gammaos_r36s-userdebug` product parse and build. The second is kernel/vendor bring-up. The third is boot/image packaging and device testing.

## What this package contains

- `scripts/fetch_sources.sh` — obtains the GammaOS source and R36S hardware repositories.
- `scripts/apply_r36s_overlay.sh` — installs the initial R36S product overlay.
- `scripts/audit_android13.sh` — audits the tree for common Android-13 port blockers.
- `scripts/build_r36s.sh` — performs a staged build with detailed logs.
- `scripts/collect_failure.sh` — captures the useful build/configuration state after a failure.
- `device/gamma/r36s/*` — hardware-neutral product glue; it intentionally does not replace the R36S's existing hardware repos.
- `docs/PORTING_PLAN.md` — detailed port sequence and stop/go gates.
- `local_manifests/r36s.xml` — a reference manifest fragment if you prefer repo-managed projects.

## Usage

```bash
./scripts/fetch_sources.sh /work/gammaos-r36s
cd /work/gammaos-r36s
/path/to/this-kit/scripts/apply_r36s_overlay.sh .
/path/to/this-kit/scripts/audit_android13.sh .
/path/to/this-kit/scripts/build_r36s.sh .
```

The scripts are intentionally verbose and stop before destructive image flashing. **Do not flash anything until a device boot test succeeds with your known-good R36S images and you have backups.**

## Source references

GammaOS Core Distribution:
https://github.com/TheGammaSqueeze/GammaOSCoreDistribution

R36S device tree:
https://github.com/andr36oid/android_device_gameconsole_r36s/tree/lineage-18.1

R36S common device tree:
https://github.com/andr36oid/android_device_gameconsole_common/tree/lineage-18.1

R36S kernel:
https://github.com/andr36oid/android_kernel_gameconsole_r36s/tree/lineage-18.1
