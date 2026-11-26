#!/usr/bin/env bash
# 日常消费 APK 手动打包脚本（不依赖 Gradle，无网络下载）
# 用法：  bash build.sh <keystore密码>
# 前置：  同目录下需有 release.keystore（别名 xiaofei），密码不入库、不入仓。

set -e

KEYSTORE_PASS="${1:-}"
if [ -z "$KEYSTORE_PASS" ]; then
  echo "用法： bash build.sh <keystore密码>"
  echo "示例： bash build.sh yourpassword"
  exit 1
fi

JDK=${JDK:-/d/AndroidBuildTools/jdk17-extract/jdk-17.0.20.1+1}
BT=${BT:-/d/AndroidBuildTools/android-sdk/build-tools/35.0.0}
ANDROID_JAR=${ANDROID_JAR:-/d/AndroidBuildTools/android-sdk/platforms/android-35/android.jar}

JAVAC="$JDK/bin/javac.exe"
JAVA="$JDK/bin/java.exe"
AAPT2="$BT/aapt2.exe"
ZIPALIGN="$BT/zipalign.exe"

cd "$(dirname "$0")"
rm -rf build && mkdir -p build/classes build/dex

echo "[1/6] aapt2 编译资源"
"$AAPT2" compile --dir res -o build/res.zip
"$AAPT2" link -o build/base.apk -I "$ANDROID_JAR" --manifest AndroidManifest.xml -R build/res.zip --auto-add-overlay

echo "[2/6] javac 编译"
"$JAVAC" -encoding UTF-8 -source 1.8 -target 1.8 -Xlint:-options -classpath "$ANDROID_JAR" -d build/classes src/com/frieny/xiaofeiapp/MainActivity.java

echo "[3/6] d8 转 dex"
CLASSES=$(find build/classes -name '*.class')
"$JAVA" -cp "$BT/lib/d8.jar" com.android.tools.r8.D8 --release --lib "$ANDROID_JAR" --output build/dex $CLASSES

echo "[4/6] 打包 dex"
python3 - <<'PY'
import zipfile, shutil
shutil.copy('build/base.apk', 'build/unsigned.apk')
with zipfile.ZipFile('build/unsigned.apk', 'a') as z:
    z.write('build/dex/classes.dex', 'classes.dex')
PY

echo "[5/6] zipalign 对齐"
"$ZIPALIGN" -f 4 build/unsigned.apk build/aligned.apk

echo "[6/6] apksigner 签名"
"$JAVA" -jar "$BT/lib/apksigner.jar" sign --ks release.keystore --ks-pass "pass:$KEYSTORE_PASS" --key-pass "pass:$KEYSTORE_PASS" --out build/日常消费.apk build/aligned.apk

"$JAVA" -jar "$BT/lib/apksigner.jar" verify --print-certs build/日常消费.apk | head -2
echo "完成： $(pwd)/build/日常消费.apk"
