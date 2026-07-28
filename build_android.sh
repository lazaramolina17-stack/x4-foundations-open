#!/usr/bin/env bash
set -euo pipefail

PROJECT_DIR="$(cd "$(dirname "$0")" && pwd)"
GODOT="${GODOT_BIN:-godot4}"

# ---------- colors ----------
RED='\033[0;31m'; GREEN='\033[0;32m'; YELLOW='\033[1;33m'; CYAN='\033[0;36m'; NC='\033[0m'
info()  { echo -e "${CYAN}[INFO]${NC}  $*"; }
ok()    { echo -e "${GREEN}[OK]${NC}    $*"; }
warn()  { echo -e "${YELLOW}[WARN]${NC}  $*"; }
err()   { echo -e "${RED}[ERROR]${NC} $*"; }

# ---------- 1. check Godot headless ----------
check_godot() {
    if command -v "$GODOT" &>/dev/null; then
        ok "Godot headless found: $(command -v "$GODOT")"
        return 0
    fi
    if command -v godot &>/dev/null; then
        GODOT=godot
        ok "Godot found: $(command -v godot)"
        return 0
    fi
    err "Godot executable not found."
    echo ""
    echo "  Download the Godot 4 headless server from:"
    echo "    https://godotengine.org/download/linux/"
    echo ""
    echo "  Or install via package manager:"
    echo "    sudo apt install godot4-headless        (Debian/Ubuntu)"
    echo "    sudo dnf install godot4-headless-server (Fedora)"
    echo "    sudo pacman -S godot4-headless          (Arch)"
    echo ""
    echo "  Then set the GODOT_BIN env var or ensure 'godot4' is in PATH."
    exit 1
}

# ---------- 2. Android SDK detection ----------
detect_sdk() {
    ANDROID_SDK_ROOT="${ANDROID_SDK_ROOT:-${ANDROID_HOME:-${HOME}/Android/Sdk}}"
    if [ -d "$ANDROID_SDK_ROOT" ]; then
        export ANDROID_SDK_ROOT
        export ANDROID_HOME="$ANDROID_SDK_ROOT"
        info "Android SDK: $ANDROID_SDK_ROOT"
    else
        warn "ANDROID_SDK_ROOT not found at '$ANDROID_SDK_ROOT'"
        warn "Set ANDROID_SDK_ROOT to your Android SDK path and re-run."
    fi
}

# ---------- 3. export template check ----------
check_templates() {
    TEMPLATES_DIR=""
    for candidate in \
        "$HOME/.local/share/godot/export_templates" \
        "$HOME/.godot/export_templates" \
        "/usr/local/share/godot/export_templates" \
        "/usr/share/godot/export_templates"; do
        if [ -d "$candidate" ]; then
            TEMPLATES_DIR="$candidate"
            break
        fi
    done

    if [ -z "$TEMPLATES_DIR" ]; then
        warn "No Godot export templates directory found."
        echo ""
        echo "  Download Android export templates:"
        echo ""
        cat <<DLSCRIPT
mkdir -p ~/.local/share/godot/export_templates
cd /tmp
VERSION=\$($GODOT --version 2>&1 | grep -oP '[\d.]+' | head -1)
wget -q "https://github.com/godotengine/godot/releases/download/\${VERSION}-stable/Godot_v\${VERSION}-stable_export_templates.tpz"
unzip -q "Godot_v\${VERSION}-stable_export_templates.tpz"
mv templates/* ~/.local/share/godot/export_templates/
rm -rf templates "Godot_v\${VERSION}-stable_export_templates.tpz"
echo "Templates installed."
DLSCRIPT
        echo ""
        echo "  Or run: godot4 --headless --export-debug \"Android\"  (will prompt to download)"
        echo ""
        read -rp "Continue anyway? [y/N] " ans
        if [[ ! "$ans" =~ ^[Yy] ]]; then
            exit 1
        fi
    else
        ok "Export templates: $TEMPLATES_DIR"
    fi
}

# ---------- 4. keystore check ----------
ensure_keystore() {
    KEYSTORE="${PROJECT_DIR}/android.keystore"
    if [ ! -f "$KEYSTORE" ]; then
        info "No android.keystore found. Generating a debug keystore..."
        keytool -genkeypair -v -keystore "$KEYSTORE" \
            -alias android -keyalg RSA -keysize 2048 -validity 10000 \
            -storepass android -keypass android \
            -dname "CN=SpaceShooter, OU=Dev, O=SpaceGame, L=Unknown, ST=Unknown, C=XX" 2>/dev/null || {
            warn "keytool not available; create a keystore manually or use Godot's debug keystore."
        }
        if [ -f "$KEYSTORE" ]; then
            ok "Debug keystore created: $KEYSTORE"
        fi
    else
        ok "Keystore found: $KEYSTORE"
    fi
}

# ---------- 5. export ----------
do_export() {
    local mode="$1"  # debug or release
    local preset="Android"

    if [ "$mode" = "release" ]; then
        info "Building Android RELEASE APK ..."
        $GODOT --headless --export-release "$preset" "${PROJECT_DIR}/build/android_release.apk" 2>&1
    else
        info "Building Android DEBUG APK ..."
        $GODOT --headless --export-debug "$preset" "${PROJECT_DIR}/build/android_debug.apk" 2>&1
    fi

    echo ""
    ok "Android ${mode} APK built: ${PROJECT_DIR}/build/android_${mode}.apk"
}

# ---------- main ----------
main() {
    local mode="${1:-debug}"
    mkdir -p "${PROJECT_DIR}/build"

    check_godot
    detect_sdk
    check_templates
    ensure_keystore

    case "$mode" in
        debug|release) do_export "$mode" ;;
        all)
            do_export debug
            do_export release
            ;;
        *)
            echo "Usage: $0 [debug|release|all]"
            exit 1
            ;;
    esac
}

main "$@"
