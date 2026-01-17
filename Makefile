# Target iOS 16.5 SDK, but allow it to run on iOS 14.0+
TARGET := iphone:clang:16.5:14.0
ARCHS = arm64

# Your Game Name
INSTALL_TARGET_PROCESSES = ACCompanion

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = VRRClient

VRRClient_FILES = Tweak.x
VRRClient_CFLAGS = -fobjc-arc -Wno-deprecated-declarations
# Remove standard frameworks if not needed, simpler is better
VRRClient_FRAMEWORKS = UIKit Foundation

include $(THEOS_MAKE_PATH)/tweak.mk
