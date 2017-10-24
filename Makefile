export THEOS_DEVICE_IP=localhost
export THEOS_DEVICE_PORT=2222

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = GoblinPassive
GoblinPassive_FILES = Tweak.xm OMNIAuctionLogic.m

include $(THEOS_MAKE_PATH)/tweak.mk

after-install::
	install.exec "killall -9 Armory"
