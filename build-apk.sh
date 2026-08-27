#!/bin/bash
# Build script for J2ME Game Speedup APK without Android Studio

# This script uses command-line tools only
# Prerequisites: Java JDK, Android SDK command-line tools

set -e

# Configuration
ANDROID_SDK_ROOT="${ANDROID_SDK_ROOT:-.}/sdk"
BUILD_DIR="build"
APP_NAME="GameSpeedup"
VERSION="1.0"
PACKAGE_NAME="com.j2me.gamespeedup"

echo "Building J2ME Game Speedup APK..."
echo "=================================="

# Create build directories
mkdir -p $BUILD_DIR/src
mkdir -p $BUILD_DIR/obj
mkdir -p $BUILD_DIR/bin
mkdir -p dist

# Compile Java files
echo "Compiling Java files..."
javac -d $BUILD_DIR/obj \
    app/src/main/java/com/j2me/gamespeedup/*.java

# Create classes.dex
echo "Creating DEX file..."
$ANDROID_SDK_ROOT/build-tools/33.0.0/dx \
    --dex \
    --output=$BUILD_DIR/classes.dex \
    $BUILD_DIR/obj

# Create APK structure
echo "Creating APK structure..."
mkdir -p $BUILD_DIR/apk/lib/armeabi-v7a
mkdir -p $BUILD_DIR/apk/res
mkdir -p $BUILD_DIR/apk/assets

# Copy resources
cp -r app/src/main/res/* $BUILD_DIR/apk/res/
cp app/src/main/AndroidManifest.xml $BUILD_DIR/apk/

# Create resources.arsc
echo "Compiling resources..."
$ANDROID_SDK_ROOT/build-tools/33.0.0/aapt \
    package -f -m \
    -J $BUILD_DIR \
    -M $BUILD_DIR/apk/AndroidManifest.xml \
    -S $BUILD_DIR/apk/res \
    -I $ANDROID_SDK_ROOT/platforms/android-33/android.jar \
    -F $BUILD_DIR/resources.arsc

# Create APK
echo "Creating APK..."
mkdir -p $BUILD_DIR/apk/META-INF
$ANDROID_SDK_ROOT/build-tools/33.0.0/aapt \
    package -f \
    -M $BUILD_DIR/apk/AndroidManifest.xml \
    -S $BUILD_DIR/apk/res \
    -I $ANDROID_SDK_ROOT/platforms/android-33/android.jar \
    -F $BUILD_DIR/$APP_NAME.unsigned.apk \
    $BUILD_DIR/apk/

# Add classes.dex to APK
cd $BUILD_DIR
zip -r $APP_NAME.unsigned.apk classes.dex
cd ..

# Sign APK
echo "Signing APK..."
$ANDROID_SDK_ROOT/build-tools/33.0.0/apksigner sign \
    --ks release.keystore \
    --ks-pass pass:android \
    --out dist/$APP_NAME.apk \
    $BUILD_DIR/$APP_NAME.unsigned.apk

echo "=================================="
echo "✅ APK built successfully!"
echo "APK location: dist/$APP_NAME.apk"
echo "Size: $(du -h dist/$APP_NAME.apk)"
