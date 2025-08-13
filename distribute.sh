#!/bin/bash


# Stop script on error
set -e

echo "🔨 Compilation Android (APK)..."
flutter build apk --release
echo "✅ Compilation Android (APK) terminée !"

echo "🔨 Compilation iOS (IPA)..."
flutter build ipa --release
echo "✅ Compilation iOS (IPA) terminée !"

# Chemins vers tes builds
ANDROID_APK_PATH="build/app/outputs/flutter-apk/app-release.apk"
IOS_IPA_PATH="build/ios/ipa/Runner.ipa"

# App IDs Firebase
ANDROID_APP_ID="1:216035312780:android:16f8fb9cbf4505a448e7a9"
IOS_APP_ID="1:216035312780:ios:3d85700466cfe5be48e7a9"

# Nom du groupe de testeurs dans Firebase
ANDROID_GROUP_NAME="Android"
IOS_GROUP_NAME="iOS"

# Notes de version
RELEASE_NOTES="🚀 Nouvelle version pilote de CutIt. Merci pour vos retours !"

echo "📤 Distribution APK Android..."
firebase appdistribution:distribute "$ANDROID_APK_PATH" \
  --app "$ANDROID_APP_ID" \
  --groups "$ANDROID_GROUP_NAME" \
  --release-notes "$RELEASE_NOTES"

echo "📤 Distribution IPA iOS..."
firebase appdistribution:distribute "$IOS_IPA_PATH" \
  --app "$IOS_APP_ID" \
  --groups "$IOS_GROUP_NAME" \
  --release-notes "$RELEASE_NOTES"

echo "✅ Distribution terminée !"