PROJECT_DIR := $(CURDIR)
GODOT      ?= godot4
BUILD_DIR  := $(PROJECT_DIR)/build
APK_DEBUG  := $(BUILD_DIR)/android_debug.apk
APK_RELEASE := $(BUILD_DIR)/android_release.apk
ANDROID_SDK_ROOT := $(or $(ANDROID_SDK_ROOT),$(ANDROID_HOME),$(HOME)/Android/Sdk)
ADB        := $(ANDROID_SDK_ROOT)/platform-tools/adb
PACKAGE    := com.spaceshooter.game

.PHONY: all build_android_debug build_android_release run_android clean generate_scenes lint help

all: build_android_debug

# ------ Build targets ------
build_android_debug: | $(BUILD_DIR)
	@echo "==> Building Android DEBUG APK ..."
	$(GODOT) --headless --export-debug "Android" $(APK_DEBUG)
	@echo "==> Done: $(APK_DEBUG)"

build_android_release: | $(BUILD_DIR)
	@echo "==> Building Android RELEASE APK ..."
	$(GODOT) --headless --export-release "Android" $(APK_RELEASE)
	@echo "==> Done: $(APK_RELEASE)"

$(BUILD_DIR):
	mkdir -p $@

# ------ Deploy ------
run_android: build_android_debug
	@echo "==> Installing APK on connected device ..."
	$(ADB) install -r $(APK_DEBUG)
	@echo "==> Launching $(PACKAGE) ..."
	$(ADB) shell monkey -p $(PACKAGE) 1
	@echo "==> Done."

# ------ Clean ------
clean:
	rm -rf $(BUILD_DIR)
	@echo "Build artifacts removed."

# ------ Scene generation ------
generate_scenes:
	@echo "==> Generating scenes via Python ..."
	python3 $(PROJECT_DIR)/generate_scenes.py
	@echo "==> Scenes regenerated."

# ------ Lint ------
lint:
	@echo "==> Checking GDScript syntax ..."
	@errors=0; \
	for f in $$(find $(PROJECT_DIR) -name '*.gd' -not -path '*/build/*'); do \
		result=$$($(GODOT) --headless --check-only --path $(PROJECT_DIR) "$$f" 2>&1) || true; \
		if [ -n "$$result" ]; then \
			echo "$$result"; \
			errors=$$((errors + 1)); \
		fi; \
	done; \
	if [ $$errors -eq 0 ]; then \
		echo "All scripts pass syntax check."; \
	else \
		echo "$$errors file(s) have issues."; \
	fi
	@echo "==> Checking Python syntax ..."
	python3 -m py_compile $(PROJECT_DIR)/generate_scenes.py
	@echo "Python syntax OK."

help:
	@echo "Targets:"
	@echo "  build_android_debug    Export debug APK"
	@echo "  build_android_release  Export release APK"
	@echo "  run_android            Build debug APK + install + launch"
	@echo "  clean                  Remove build artifacts"
	@echo "  generate_scenes        Re-run Python scene generator"
	@echo "  lint                   GDScript + Python syntax check"
	@echo "  all (default)          build_android_debug"
