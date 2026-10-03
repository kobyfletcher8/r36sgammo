$(call inherit-product, device/gameconsole/common/device.mk)
$(call inherit-product, device/gameconsole/r36s/device.mk)

PRODUCT_NAME := gammaos_r36s
PRODUCT_DEVICE := r36s
PRODUCT_MANUFACTURER := GameConsole
PRODUCT_BRAND := GameConsole
PRODUCT_MODEL := GammaOS Core on R36S

TARGET_SCREEN_WIDTH := 640
TARGET_SCREEN_HEIGHT := 480

# GammaOS Core's product-specific applications/tweaks should be inherited
# from the distribution where available. Keep this file minimal during the
# hardware bring-up so Android 13 failures are attributable to the port.

PRODUCT_BUILD_PROP_OVERRIDES += \
    TARGET_DEVICE=r36s \
    PRODUCT_NAME=r36s
