# macOS
# gmake package 
# iOS
# gmake package PLATFORM=iphoneos SCHEME="'Vencord Web (iOS)'"

PLATFORM 		= macosx
NAME 			= "Vencord\ Web"
NAME_DIR 		= "Vencord Web"
SCHEME 			?= 'Vencord Web (macOS)'
RELEASE 		= Release-$(PLATFORM)
CONFIGURATION 	= Release

APP_TMP         = $(TMPDIR)/$(NAME_DIR)
APP_DIR 	   	= $(APP_TMP)/Build/Products/$(RELEASE)/$(NAME_DIR).app
APP_MAC_DIR 	= $(APP_TMP)/Build/Products/$(CONFIGURATION)/$(NAME_DIR).app

all: package

package:
	@rm -rf $(APP_TMP)
	# change arch stuff blahj blah
	@set -o pipefail; \
		xcodebuild \
		-jobs $(shell sysctl -n hw.ncpu) \
		-project "$(NAME).xcodeproj" \
		-scheme $(SCHEME) \
		-configuration $(CONFIGURATION) \
		-arch arm64 -sdk $(PLATFORM) \
		-derivedDataPath $(APP_TMP) \
		CODE_SIGNING_ALLOWED=NO \
		DSTROOT=$(APP_TMP)/install \
		ALWAYS_EMBED_SWIFT_STANDARD_LIBRARIES=NO

	@ln -sf $(APP_TMP)/Build/Products/ Products
	@mkdir -p packages

ifeq ($(PLATFORM),macosx)
	@cp -a $(APP_MAC_DIR) packages
else
	@mkdir packages/Payload
	@cp -a $(APP_DIR) packages/Payload
	@zip -r9 packages/$(NAME_DIR).ipa packages/Payload
endif
	
clean:
	@rm -rf $(STAGE_DIR)
	@rm -rf packages
	@rm -rf Products
	@rm -rf $(APP_TMP)

.PHONY: all package clean
