#
# Copyright (C) 2021-2023 The LineageOS Project
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

# Inherit from the common tree
$(call inherit-product, device/samsung/exynos9820-common/exynos9825.mk)

# Nopenix branding/variant (must be included BEFORE the lineage common
# config inherit, because CR_VERSION is read at version.mk include time).
include $(LOCAL_PATH)/nopenix.mk

# Inherit proprietary files
$(call inherit-product, vendor/samsung/d2s/d2s-vendor.mk)

# Setup dalvik vm configs
$(call inherit-product, frameworks/native/build/phone-xhdpi-6144-dalvik-heap.mk)

# Audio
PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/configs/audio/mixer_paths.xml:$(TARGET_COPY_OUT_VENDOR)/etc/mixer_paths.xml

ifneq ($(NOPENIX_VARIANT),prod)
# TEMPORARY flash-day debug instrumentation (adbd-early + logcat->kmsg)
# Dev line only: prod builds ship no debug hooks (docs/dev-prod.md).
PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/init.debug.rc:$(TARGET_COPY_OUT_SYSTEM)/etc/init/init.debug.rc
endif

# Overlays. NOTE: the Updater channel overlay is appended in nopenix.mk
# (variant-dependent), not here.
DEVICE_PACKAGE_OVERLAYS += \
    $(LOCAL_PATH)/overlay


# Shims
PRODUCT_PACKAGES += \
    libshim_sfpex

# Nopenix flash-day debug (dev line only): ro.debuggable=1 enables adb root
# even when system_server wedges. ro.adb.secure is NOT set here: init loads
# system_ext/build.prop AFTER system/build.prop, so system_ext's
# ro.adb.secure=1 (lineage common.mk) would win. We disable auth via
# WITH_ADB_INSECURE=true in build-start.sh instead, which makes lineage
# emit ro.adb.secure=0 in system_ext itself.
ifneq ($(NOPENIX_VARIANT),prod)
PRODUCT_SYSTEM_PROPERTIES += \
    ro.debuggable=1
endif
