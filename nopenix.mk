# Nopenix branding and line-variant configuration.
# Included from device.mk BEFORE vendor/lineage/config/common_full_phone.mk,
# so CR_VERSION must be set here to win over the crDroid default in
# version.mk (patched to `CR_VERSION ?= 12.12` — carry that patch, see hub
# repo patches/).
#
# Variant-specific values (dev vs prod) are switched by NOPENIX_VARIANT,
# which the build wrapper sets per line:
#   dev  -> userdebug + WITH_SU=true + WITH_ADB_INSECURE=true +
#           BUILD_BROKEN_DUP_SYSPROP (set in device tree) + init.debug.rc
#   prod -> user flavor, WITH_SU=false, no WITH_ADB_INSECURE, no debug knobs
#           (init.debug.rc and ro.debuggable gated off in device.mk/BoardConfig)

NOPENIX_VARIANT ?= dev
NOPENIX_VERSION := 13.0

CR_VERSION := $(NOPENIX_VERSION)

PRODUCT_PRODUCT_PROPERTIES += \
    ro.nopenix.variant=$(NOPENIX_VARIANT) \
    ro.nopenix.version=$(NOPENIX_VERSION) \
    ro.lineage.build.version=23.2

# Updater OTA channel: DEVICE_PACKAGE_OVERLAYS must pick the overlay BEFORE
# its value is compiled into the Updater auto-RRO (PRODUCT_ENFORCE_RRO_TARGETS
# =*). Channel-specific overlays live in overlay/updater/<channel>/values/.
ifeq ($(NOPENIX_VARIANT),dev)
DEVICE_PACKAGE_OVERLAYS += $(LOCAL_PATH)/overlay/updater/dev
else
DEVICE_PACKAGE_OVERLAYS += $(LOCAL_PATH)/overlay/updater/prod
endif

$(warning Nopenix: variant=$(NOPENIX_VARIANT) version=$(NOPENIX_VERSION) ota=ota/$(NOPENIX_VARIANT).json)
