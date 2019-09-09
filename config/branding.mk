# PhantomCenter
ifeq ($(filter-out OFFICIAL WEEKLY RISE, $(BUILD_TYPE)),)
    PRODUCT_PACKAGES += \
        PhantomCenter
endif

ifneq ($(SIGNING_KEYS),)
    PRODUCT_DEFAULT_DEV_CERTIFICATE := $(SIGNING_KEYS)/releasekey
endif

ifndef BUILD_TYPE
    BUILD_TYPE := COMMUNITY
endif

ifndef BUILD_STATE
    BUILD_STATE := UNKNOWN
endif

PHANTOM_BUILD := croquette
PHANTOM_VERSION := 3.0.0-alpha+1
ifeq ($(USE_TIME_IN_NAME), true)
    ifeq ($(BUILD_TYPE), COMMUNITY)
       PHANTOM_VERSION := $(TARGET_PRODUCT)-$(PLATFORM_VERSION)-$(shell date -u +%Y%m%d_%H%M)
    endif
endif

ifndef PHANTOM_VERSION
    PHANTOM_VERSION := $(TARGET_PRODUCT)-$(PLATFORM_VERSION)-$(shell date -u +%Y%m%d)
endif

CURRENT_DEVICE := $(shell echo "$(TARGET_PRODUCT)" | cut -d'_' -f 2,3)
LIST := $(shell cat vendor/phantom/phantom.devices)

ifeq ($(filter $(CURRENT_DEVICE), $(LIST)), $(CURRENT_DEVICE))
    ifeq ($(filter-out OFFICIAL WEEKLY RISE, $(BUILD_TYPE)),)
        PHANTOM_VERSION := $(PHANTOM_VERSION).$(PHANTOM_BUILD)-v$(PHANTOM_VERSION)
        ifeq ($(BUILD_TYPE), RISE)
          BUILD_STATE := TEST
        endif
        ifeq ($(filter-out EXPERIMENTAL EXPERIMENTS TESTING TEST, $(BUILD_STATE)),)
            PHANTOM_VERSION :=$(PHANTOM_VERSION).RISE
            PRODUCT_SYSTEM_DEFAULT_PROPERTIES += ro.phantom.type=rise
        else
            PHANTOM_VERSION :=$(PHANTOM_VERSION)-$(PHANTOM_BUILD)
            PRODUCT_SYSTEM_DEFAULT_PROPERTIES += ro.phantom.type=$(PHANTOM_BUILD)
        endif
    else
        PHANTOM_VERSION := $(PHANTOM_VERSION).CHIPS-v$(PHANTOM_VERSION).$(BUILD_TYPE)
    endif
else
    ifeq ($(filter-out OFFICIAL WEEKLY, $(BUILD_TYPE)),)
      $(error "Invalid BUILD_TYPE!")
    endif
    PHANTOM_VERSION := $(PHANTOM_VERSION).CHIPS-v$(PHANTOM_VERSION).$(BUILD_TYPE)
endif

export PHANTOM_VERSION
export PHANTOM_BUILD

