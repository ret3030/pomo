#!/bin/sh
# Publishes the version in Resources/Info.plist as a GitHub release and prints
# the sha256 that goes into Casks/pomo.rb in ret3030/homebrew-tap.
set -eu
cd "$(dirname "$0")/.."
version=$(/usr/libexec/PlistBuddy -c 'Print CFBundleShortVersionString' Resources/Info.plist)
scripts/build.sh
zip="build/Pomo-$version.zip"
# ditto keeps the bundle's attributes and signature intact, plain zip does not.
ditto -c -k --keepParent build/Pomo.app "$zip"
gh release create "v$version" "$zip" --title "Pomo $version" \
    --notes "Install with \`brew install --cask ret3030/tap/pomo\`."
echo "version \"$version\""
echo "sha256 \"$(shasum -a 256 "$zip" | cut -d' ' -f1)\""
