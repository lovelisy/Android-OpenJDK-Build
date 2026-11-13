#!/bin/bash
set -e

if [[ "$TARGET_JDK" == "arm" ]]; then
  export TARGET_JDK=aarch32
fi

imagespath=openjdk/build/${JVM_PLATFORM}-${TARGET_JDK}-normal-${JVM_VARIANTS}-${JDK_DEBUG_LEVEL}/images

rm -rf dizout jreout jdkout
mkdir dizout

cp -r $imagespath/j2re-image jreout
cp -r $imagespath/j2sdk-image jdkout

if [[ "$TARGET_JDK" == "x86" ]]; then
  export TARGET_JDK=i386
fi

freetype_src="$PWD/freetype-$BUILD_FREETYPE_VERSION/build_android-$TARGET_SHORT/lib/libfreetype.so"
if [[ ! -f "$freetype_src" ]]; then
  echo "Missing $freetype_src"
  exit 1
fi

for img in jreout jdkout; do
  libjava=$(find "$img" -name libjava.so | head -n 1)
  if [[ -z "$libjava" ]]; then
    echo "Cannot locate the native library directory in $img"
    exit 1
  fi
  libdir=$(dirname "$libjava")
  cp -L "$freetype_src" "$libdir/libfreetype.so"
  cp -L "$freetype_src" "$libdir/libfreetype.so.6"
  echo "Installed libfreetype.so into $libdir"
done

find jreout -name "*.diz" -delete
find jdkout -name "*.diz" -exec mv {} dizout/ \;
