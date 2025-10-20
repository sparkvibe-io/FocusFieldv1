#!/usr/bin/env bash
set -euo pipefail

# Helper script to run Focus Field on a tablet AVD.
# Creates / launches an Android tablet emulator if needed, then runs flutter with desired defines.
# Usage: ./scripts/run_tablet.sh [--prod] [--rc-key=KEY]
#   --prod              : production mode (requires API key via env or --rc-key)
#   --rc-key=XYZ        : explicitly supply RevenueCat public API key (implies --prod)
# Default (no args) runs with mock subscriptions enabled.

AVD_NAME=${AVD_NAME:-pixel_tablet_api34}
SYSTEM_IMAGE="system-images;android-34;google_apis;arm64-v8a"

MODE="dev"
RC_KEY="${REVENUECAT_API_KEY:-}"

# Detect Java early (required by avdmanager). We'll try common bundled locations if not on PATH.
ensure_java() {
  # If user provided JAVA_HOME explicitly, respect it.
  if [[ -n "${JAVA_HOME:-}" && -x "${JAVA_HOME}/bin/java" ]]; then
    export PATH="${JAVA_HOME}/bin:$PATH"; return 0; fi
  if command -v java >/dev/null 2>&1; then return 0; fi
  # Attempt macOS system helper (works if any JDK installed via pkg or brew)
  if command -v /usr/libexec/java_home >/dev/null 2>&1; then
    local sys_home
    if sys_home=$(/usr/libexec/java_home -v 17 2>/dev/null); then
      export JAVA_HOME="$sys_home"; export PATH="$JAVA_HOME/bin:$PATH"; return 0
    elif sys_home=$(/usr/libexec/java_home 2>/dev/null); then
      export JAVA_HOME="$sys_home"; export PATH="$JAVA_HOME/bin:$PATH"; return 0
    fi
  fi
  # Android Studio bundled JBR
  local candidates=(
    "/Applications/Android Studio.app/Contents/jbr/Contents/Home"
    "/Applications/Android Studio.app/Contents/jre/Contents/Home"
    "$HOME/Library/Java/JavaVirtualMachines/temurin-17.jdk/Contents/Home"
    "$HOME/Library/Java/JavaVirtualMachines/temurin-21.jdk/Contents/Home"
    "$HOME/.sdkman/candidates/java/current"
  )
  for c in "${candidates[@]}"; do
    if [[ -d "$c" && -x "$c/bin/java" ]]; then
      export JAVA_HOME="$c"; export PATH="$JAVA_HOME/bin:$PATH"; return 0
    fi
  done
  # Last resort: look for any detected Gradle caches referencing jdk-17 inside Android Studio
  local as_cache="$HOME/Library/Application Support/Google/AndroidStudio2024.1/jbr"
  if [[ -d "$as_cache" && -x "$as_cache/bin/java" ]]; then
    export JAVA_HOME="$as_cache"; export PATH="$JAVA_HOME/bin:$PATH"; return 0
  fi
  echo "::error::Java runtime not found. Install an OpenJDK (Temurin 17 recommended)." >&2
  echo "Homebrew:   brew install --cask temurin17" >&2
  echo "SDKMAN:     curl -s https://get.sdkman.io | bash && source \"$HOME/.sdkman/bin/sdkman-init.sh\" && sdk install java 17-tem" >&2
  echo "Once installed, re-run this script." >&2
  exit 9
}

ensure_java

for arg in "$@"; do
  case "$arg" in
    --prod) MODE="prod" ;;
    --rc-key=*) RC_KEY="${arg#*=}"; MODE="prod" ;;
    -h|--help)
      echo "Usage: $0 [--prod] [--rc-key=KEY]";
      exit 0 ;;
  esac
done

# Ensure Android SDK tools are on PATH (avdmanager / adb / emulator / sdkmanager)
have_tools=true
for bin in avdmanager adb emulator sdkmanager; do
  if ! command -v "$bin" >/dev/null 2>&1; then have_tools=false; break; fi
done

if [[ $have_tools == false ]]; then
  # Attempt common macOS Android SDK locations
  for candidate in "${ANDROID_HOME:-}" "${ANDROID_SDK_ROOT:-}" "$HOME/Library/Android/sdk" \
                     "/usr/local/share/android-sdk"; do
    if [[ -n "$candidate" && -d "$candidate" ]]; then
      export ANDROID_HOME="$candidate"
      export PATH="$ANDROID_HOME/emulator:$ANDROID_HOME/platform-tools:$ANDROID_HOME/cmdline-tools/latest/bin:$PATH"
    fi
  done
  # Re-check
  have_tools=true
  for bin in avdmanager adb emulator sdkmanager; do
    if ! command -v "$bin" >/dev/null 2>&1; then have_tools=false; break; fi
  done
fi

if [[ $have_tools == false ]]; then
  echo "::error::Android SDK command-line tools not found (need avdmanager/adb/emulator)." >&2
  echo "Install via Android Studio > SDK Manager > 'Android SDK Command-line Tools', then set ANDROID_HOME." >&2
  echo "Example: export ANDROID_HOME=\"$HOME/Library/Android/sdk\"" >&2
  echo "         export PATH=\"$ANDROID_HOME/emulator:$ANDROID_HOME/platform-tools:$ANDROID_HOME/cmdline-tools/latest/bin:$PATH\"" >&2
  exit 2
fi

if ! avdmanager list avd 2>/dev/null | grep -q "Name: ${AVD_NAME}"; then
  echo "[tablet] AVD ${AVD_NAME} not found, creating..."
  yes | sdkmanager --install "${SYSTEM_IMAGE}" >/dev/null 2>&1 || true
  yes | avdmanager create avd -n "${AVD_NAME}" -k "${SYSTEM_IMAGE}" -d pixel_tablet || {
    echo "::error::Failed to create AVD ${AVD_NAME}" >&2; exit 3; }
fi

# Launch emulator if not running
if ! adb devices | grep -q "emulator-"; then
  echo "[tablet] Launching emulator ${AVD_NAME}..."
  ( emulator -avd "${AVD_NAME}" -netfast -gpu host -no-snapshot -camera-back none -camera-front none >/dev/null 2>&1 & )
  echo "[tablet] Waiting for device boot..."
  adb wait-for-device
  # Wait for sys.boot_completed
  for i in {1..60}; do
    if adb shell getprop sys.boot_completed 2>/dev/null | grep -q 1; then
      echo "[tablet] Boot complete."; break; fi
    sleep 2
  done
fi

device_id=$(flutter devices | awk '/emulator/ {print $1; exit}')
if [[ -z ${device_id} ]]; then
  echo "::error::No emulator device detected after launch" >&2
  exit 1
fi

DART_DEFINES=(--dart-define=ENABLE_MOCK_SUBSCRIPTIONS=true)
if [[ $MODE == prod ]]; then
  if [[ -z $RC_KEY ]]; then
    echo "::error::RevenueCat key not provided (set REVENUECAT_API_KEY or use --rc-key=KEY)" >&2
    exit 1
  fi
  DART_DEFINES=(--dart-define=ENABLE_MOCK_SUBSCRIPTIONS=false --dart-define=REVENUECAT_API_KEY=$RC_KEY)
fi

echo "[tablet] Running app on ${device_id} (mode=$MODE)";
echo "[tablet] Dart defines: ${DART_DEFINES[*]}"
set -x
flutter run -d "${device_id}" "${DART_DEFINES[@]}"
