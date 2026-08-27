@echo off
REM Build script for J2ME Game Speedup APK without Android Studio (Windows)
REM Prerequisites: Java JDK, Android SDK command-line tools

setlocal enabledelayedexpansion

set ANDROID_SDK_ROOT=%ANDROID_SDK_ROOT:.=\sdk%
set BUILD_DIR=build
set APP_NAME=GameSpeedup
set VERSION=1.0
set PACKAGE_NAME=com.j2me.gamespeedup

echo Building J2ME Game Speedup APK...
echo ==================================

REM Create build directories
if not exist %BUILD_DIR%\src mkdir %BUILD_DIR%\src
if not exist %BUILD_DIR%\obj mkdir %BUILD_DIR%\obj
if not exist %BUILD_DIR%\bin mkdir %BUILD_DIR%\bin
if not exist dist mkdir dist

REM Compile Java files
echo Compiling Java files...
javac -d %BUILD_DIR%\obj ^
    app\src\main\java\com\j2me\gamespeedup\*.java

if !errorlevel! neq 0 (
    echo Compilation failed!
    exit /b 1
)

REM Create classes.dex
echo Creating DEX file...
%ANDROID_SDK_ROOT%\build-tools\33.0.0\dx.bat ^
    --dex ^
    --output=%BUILD_DIR%\classes.dex ^
    %BUILD_DIR%\obj

if !errorlevel! neq 0 (
    echo DEX creation failed!
    exit /b 1
)

REM Create APK
echo Creating APK package...
if not exist %BUILD_DIR%\apk mkdir %BUILD_DIR%\apk
if not exist %BUILD_DIR%\apk\lib\armeabi-v7a mkdir %BUILD_DIR%\apk\lib\armeabi-v7a
if not exist %BUILD_DIR%\apk\res mkdir %BUILD_DIR%\apk\res

REM Copy resources
xcopy app\src\main\res %BUILD_DIR%\apk\res /E /I /Y
copy app\src\main\AndroidManifest.xml %BUILD_DIR%\apk\

REM Package APK
%ANDROID_SDK_ROOT%\build-tools\33.0.0\aapt.exe package -f ^
    -M %BUILD_DIR%\apk\AndroidManifest.xml ^
    -S %BUILD_DIR%\apk\res ^
    -I %ANDROID_SDK_ROOT%\platforms\android-33\android.jar ^
    -F dist\%APP_NAME%.apk ^
    %BUILD_DIR%\apk\

REM Add classes.dex using PowerShell
powershell -Command "Add-Type -AssemblyName System.IO.Compression.FileSystem; [System.IO.Compression.ZipFile]::OpenRead('dist\%APP_NAME%.apk').Entries | Out-Null; (New-Object System.IO.Compression.ZipArchive([System.IO.File]::Open('dist\%APP_NAME%.apk', 'Update'), 'Update')).CreateEntryFromFile('%BUILD_DIR%\classes.dex', 'classes.dex', 'Optimal')"

echo ==================================
echo Build complete!
echo APK: dist\%APP_NAME%.apk
echo.
echo Installation:
echo   adb install dist\%APP_NAME%.apk
pause
