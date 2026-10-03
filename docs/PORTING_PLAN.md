# R36S GammaOS Core Port Plan

## 1. Source baseline

Use `GammaOSCoreDistribution` `develop` as the Android 13/GammaOS system baseline. Keep all existing GammaOS framework/system changes intact.

Use the R36S-specific repositories as hardware sources:

- `device/gameconsole/common`
- `device/gameconsole/r36s`
- `kernel/gameconsole/r36s`

The current R36S product definition is 640x480 and identifies the product as `lineage_r36s`; its source inherits the common and R36S device layers. The existing kernel repository is on the `lineage-18.1` branch and is the R36S kernel source.

## 2. Product layer

The first overlay adds a separate product namespace:

`gammaos_r36s`

This avoids overwriting the existing `lineage_r36s` product until a successful build proves the Android 13 port is viable.

## 3. Android 13 compatibility sweep

Expect build failures in these categories:

1. Device makefiles using variables that changed between Android 11 and Android 13.
2. SELinux rules that refer to obsolete types/domains.
3. HIDL/VINTF declarations that have changed or disappeared.
4. Legacy Rockchip display/audio/Wi-Fi components that were built for the Android 11 vendor interface.
5. Kernel module ABI/build integration differences.
6. Partition/AVB/vbmeta assumptions inherited from the older R36S image layout.

The audit script identifies references but does not silently rewrite them.

## 4. Kernel strategy

Start with the proven R36S kernel. Do not replace it with an RK3566 kernel.

The kernel source is the most hardware-sensitive part of the port. Kernel build success is not enough; the resulting Image/DTB must still match the R36S boot chain and panel DTS.

## 5. Vendor strategy

Do not use GammaOS RK3566 vendor files as the R36S vendor image. Reuse only system-side GammaOS modifications that do not depend on RK3566-specific HALs.

If Android 13 rejects the existing Android 11 vendor stack, the build log must be used to determine whether the blocker is:

- VINTF mismatch,
- VNDK/API incompatibility,
- missing HAL service,
- SELinux policy,
- linker/namespace issue, or
- kernel interface mismatch.

## 6. Build gates

### Gate A — product parse
`lunch gammaos_r36s-userdebug` must succeed.

### Gate B — Soong/product generation
`m nothing` (or the closest target supported by the tree) must complete.

### Gate C — system image
Build `systemimage` successfully.

### Gate D — boot artifacts
Build the R36S kernel/DTB and a boot image without changing the known-good partition layout.

### Gate E — device boot
Test with a backup SD card and retain the original image.

### Gate F — graphics/input/audio/storage
Validate display, keys, analog controls, audio, battery, Wi-Fi/BT and SD storage.

### Gate G — GammaOS features
Only after hardware is stable, enable the GammaOS-specific performance/QS/launcher integrations one group at a time.

## 7. Aggressive mode

This port kit is aggressive in *build iteration* but conservative about irreversible flashing. Every script writes timestamped logs and records the Git revisions used. Flashing remains a separate manual step.
