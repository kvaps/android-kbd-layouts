#!/bin/sh
# Build and sign the keyboard layouts APK (needs the android-framework-res package).
set -e
cd "$(dirname "$0")"
rm -rf build && mkdir build
aapt2 compile --dir res -o build/res.zip
aapt2 link -I /usr/share/android-framework-res/framework-res.apk --manifest AndroidManifest.xml -o build/unsigned.apk build/res.zip
zipalign -f 4 build/unsigned.apk build/aligned.apk
[ -f debug.keystore ] || keytool -genkeypair -keystore debug.keystore -storepass android -keypass android \
  -alias key -keyalg RSA -keysize 2048 -validity 10000 -dname CN=kbdlayouts >/dev/null 2>&1
apksigner sign --ks debug.keystore --ks-pass pass:android --out build/kbd-layouts.apk build/aligned.apk
echo build/kbd-layouts.apk
