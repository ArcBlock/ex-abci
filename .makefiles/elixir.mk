BUILD_VERSION=v$(VERSION)
RELEASE_DIR=$(TOP_DIR)/src/_build/releases

TMP_OTP_PATH=/tmp/esl_otp_$(OTP_VERSION)
TMP_OTP_FILE=$(TMP_OTP_PATH)/otp_$(OTP_VERSION).rpm

build-dev:
	@echo "Building the dev release..."
	@cd src; mix deps.get; mix compile; mix release;
	@cp src/_build/dev/rel/$(BUILD_NAME)/releases/$(VERSION)/$(BUILD_NAME).tar.gz $(RELEASE_DIR)/$(BUILD_NAME)_dev.tgz

build-staging:
	@echo "Building the staging release..."
	@cd src; mix deps.get; MIX_ENV=staging mix compile; MIX_ENV=staging mix release --env=staging;
	@cp src/_build/staging/rel/$(BUILD_NAME)/releases/$(VERSION)/$(BUILD_NAME).tar.gz $(RELEASE_DIR)/$(BUILD_NAME)_staging.tgz

build-prod:
	@echo "Building the production release..."
	@cd src; mix deps.get; MIX_ENV=prod mix compile; MIX_ENV=prod mix release --env=prod;
	@cp src/_build/prod/rel/$(BUILD_NAME)/releases/$(VERSION)/$(BUILD_NAME).tar.gz $(RELEASE_DIR)/$(BUILD_NAME)_prod.tgz

build-version-file:
	@echo "$(BUILD_VERSION)" > $(RELEASE_DIR)/$(BUILD_VERSION)

$(RELEASE_DIR):
	@mkdir -p $@

build-release: $(RELEASE_DIR) download-esl-otp copy-docs build-staging build-prod build-version-file

download-esl-otp: $(TMP_OTP_PATH)
	@curl -o $(TMP_OTP_FILE) "https://packages.erlang-solutions.com/erlang/esl-erlang/FLAVOUR_1_general/esl-erlang_$(OTP_VERSION)-1~centos~7_amd64.rpm"
	@cd $(TMP_OTP_PATH); rpm2cpio $(TMP_OTP_FILE) | cpio -idm

$(TMP_OTP_PATH):
	@mkdir -p $@
