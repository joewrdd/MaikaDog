#!/bin/zsh
set -e
cd "$(dirname "$0")"
APP="build/macos/Build/Products/Release/Maika.app"
[ -d "$APP" ] || { echo "Build first: flutter build macos --release"; exit 1; }
rm -rf dist/dmg_stage dist/Maika.dmg
mkdir -p dist/dmg_stage
cp -R "$APP" dist/dmg_stage/
codesign --force --deep --preserve-metadata=entitlements --sign - "dist/dmg_stage/Maika.app"
ln -s /Applications dist/dmg_stage/Applications
hdiutil create -volname "Maika" -srcfolder dist/dmg_stage -ov -format UDZO dist/Maika.dmg
rm -rf dist/dmg_stage
echo "dist/Maika.dmg ready"
