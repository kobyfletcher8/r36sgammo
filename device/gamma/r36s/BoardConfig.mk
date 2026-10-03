# Initial R36S RK3326 GammaOS Core product glue.
# Hardware details intentionally remain in device/gameconsole/r36s and
# device/gameconsole/common from the known-good R36S Android tree.

TARGET_ARCH := arm64
TARGET_ARCH_VARIANT := armv8-a
TARGET_CPU_ABI := arm64-v8a
TARGET_CPU_VARIANT := cortex-a53

TARGET_BOARD_PLATFORM := rk3328
TARGET_BOOTLOADER_BOARD_NAME := rk3326
TARGET_SOC := rk3326

TARGET_SCREEN_WIDTH := 640
TARGET_SCREEN_HEIGHT := 480

# Keep the proven R36S kernel source; do not use an RK3566 kernel.
TARGET_KERNEL_SOURCE := kernel/gameconsole/r36s
TARGET_KERNEL_ARCH := arm64

# These are deliberately placeholders until the Android 13 build identifies
# the exact R36S boot-image requirements. The existing R36S device tree remains
# the authoritative source for its boot/DTB packaging.
BOARD_KERNEL_IMAGE_NAME := Image

# Product-specific VINTF/SEPolicy additions should be made only after the
# first Android 13 build exposes concrete requirements.
