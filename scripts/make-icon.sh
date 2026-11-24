#!/bin/sh
# Regenerates Resources/AppIcon.icns and docs/icon.png from scripts/make-icon.swift.
set -eu
cd "$(dirname "$0")/.."
tmp=$(mktemp -d)
swift scripts/make-icon.swift "$tmp/icon.png"
set=$tmp/AppIcon.iconset
mkdir "$set"
for size in 16 32 128 256 512; do
    sips -z $size $size "$tmp/icon.png" --out "$set/icon_${size}x${size}.png" >/dev/null
    double=$((size * 2))
    sips -z $double $double "$tmp/icon.png" --out "$set/icon_${size}x${size}@2x.png" >/dev/null
done
iconutil -c icns "$set" -o Resources/AppIcon.icns
sips -z 256 256 "$tmp/icon.png" --out docs/icon.png >/dev/null
rm -rf "$tmp"
echo "Wrote Resources/AppIcon.icns and docs/icon.png"
