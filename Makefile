# We use 'latest' so it grabs the SDK we just downloaded
TARGET := iphone:clang:latest:14.0
INSTALL_TARGET_PROCESSES = ACCompanion

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = VRRClient

VRRClient_FILES = Tweak.x
VRRClient_CFLAGS = -fobjc-arc -Wno-deprecated-declarations
VRRClient_FRAMEWORKS = UIKit Foundation

include $(THEOS_MAKE_PATH)/tweak.mk
