#
# Copyright 2014 The Android Open-Source Project
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

# Adjust the dalvik heap to be appropriate for a tablet.
$(call inherit-product-if-exists,frameworks/native/build/tablet-10in-xhdpi-2048-dalvik-heap.mk)

ifeq ($(TARGET_PREBUILT_KERNEL),)
LOCAL_KERNEL := device/linaro/dragonboard410c-kernel/kernel
else
LOCAL_KERNEL := $(TARGET_PREBUILT_KERNEL)
endif


PRODUCT_COPY_FILES += $(call add-to-product-copy-files-if-exists,\
			$(LOCAL_PATH)/root/fstab.db410c:root/fstab.db410c \
			$(LOCAL_PATH)/root/init.db410c.rc:root/init.db410c.rc \
			$(LOCAL_PATH)/db410c_monkey_blacklist:data/db410c_monkey_blacklist)

PRODUCT_COPY_FILES += $(LOCAL_KERNEL):kernel \

# Set custom settings
DEVICE_PACKAGE_OVERLAYS := device/linaro/db410c/overlay

# Add openssh support for remote debugging and job submission
# PRODUCT_PACKAGES += ssh sftp scp sshd ssh-keygen sshd_config start-ssh

# Build and run only ART
PRODUCT_RUNTIMES := runtime_libart_default

# Build libion for new double-buffering HDLCD driver
# PRODUCT_PACKAGES += libion

# Build gatord daemon for DS-5/Streamline
PRODUCT_PACKAGES += gatord

# Build libGLES_android for Juno
PRODUCT_PACKAGES += libGLES_android

# Include ION tests
#PRODUCT_PACKAGES += iontest \
#                    ion-unit-tests

# Set zygote config
PRODUCT_DEFAULT_PROPERTY_OVERRIDES += ro.zygote=zygote64_32
PRODUCT_COPY_FILES += system/core/rootdir/init.zygote64_32.rc:root/init.zygote64_32.rc

# Copy hardware config file(s)
PRODUCT_COPY_FILES += $(call add-to-product-copy-files-if-exists,\
                        device/linaro/build/android.hardware.screen.xml:system/etc/permissions/android.hardware.screen.xml )

PRODUCT_COPY_FILES +=   frameworks/native/data/etc/android.hardware.ethernet.xml:system/etc/permissions/android.hardware.ethernet.xml \
                        frameworks/native/data/etc/android.software.app_widgets.xml:system/etc/permissions/android.software.app_widgets.xml \
                        frameworks/native/data/etc/android.software.backup.xml:system/etc/permissions/android.software.backup.xml \
                        frameworks/native/data/etc/android.hardware.usb.accessory.xml:system/etc/permissions/android.hardware.usb.accessory.xml

# firmware distributed separately, copy these files from your device and
# use ADRENO_FIRMWARE=path/to/firmware/directory on the make cmdline:
PRODUCT_COPY_FILES += \
        $(ADRENO_FIRMWARE)/a300_pfp.fw:root/lib/firmware/a300_pfp.fw \
        $(ADRENO_FIRMWARE)/a300_pm4.fw:root/lib/firmware/a300_pm4.fw \

$(call inherit-product-if-exists, device/linaro/build/common-device.mk)