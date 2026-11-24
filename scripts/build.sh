#!/bin/sh
# Builds build/Pomo.app: SwiftPM compiles the binary, this wraps it in an app bundle
# (needed for notifications and launch at login) and signs it ad hoc.
set -eu
cd "$(dirname "$0")/.."
swift build -c release
app=build/Pomo.app
rm -rf "$app"
mkdir -p "$app/Contents/MacOS"
cp "$(swift build -c release --show-bin-path)/Pomo" "$app/Contents/MacOS/Pomo"
cp Resources/Info.plist "$app/Contents/Info.plist"
codesign --force --sign - "$app"
echo "Built $app"
