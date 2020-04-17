#!/bin/bash

echo -e "
######################## Swift-Android-Toolchain ########################

Compile Start

$@

SWIFT_ANDROID_ARCH=$SWIFT_ANDROID_ARCH

#########################################################################
"

#export TOOLCHAINS=org.swift.50320190830a
#export TOOLCHAINS=org.swift.51320191213a
export TOOLCHAINS=org.swift.520202003241a

: "${SWIFT_ANDROID_HOME:?$SWIFT_ANDROID_HOME should be set}"
: "${ANDROID_NDK_HOME:?$ANDROID_NDK_HOME should be set}"

SELF_DIR=$(dirname $0)
SELF_DIR=$SELF_DIR/src/bash

xcode_toolchain=$(dirname $(dirname $(dirname $(xcrun --find swift))))

export CC="$ANDROID_NDK_HOME/toolchains/llvm/prebuilt/darwin-x86_64/bin/clang"
export CXX="$ANDROID_NDK_HOME/toolchains/llvm/prebuilt/darwin-x86_64/bin/clang++"

# swiftc dont know about CC/CXX so tell correct compiler path for him in more brutal way
export PATH="$ANDROID_NDK_HOME/toolchains/llvm/prebuilt/darwin-x86_64/bin:$PATH"

export SWIFT_EXEC=$SWIFT_ANDROID_HOME/toolchain/usr/bin/swiftc
export SWIFT_EXEC_MANIFEST=$xcode_toolchain/usr/bin/swiftc
export SWIFTPM_PD_LIBS=$xcode_toolchain/usr/lib/swift/pm

if [ ! -n "${SWIFT_ANDROID_ARCH+defined}" ] || [ "$SWIFT_ANDROID_ARCH" == "aarch64" ]
then
    export TARGET=aarch64-none-linux-android
    export TARGET2=aarch64-unknown-linux-android
    export TRIPLE=aarch64-linux-android
    export ARCH=arm64
    export SWIFT_ARCH=aarch64
    export ABI=arm64-v8a
    export TOOLCHAIN_ROOT=aarch64-linux-android
elif [ "$SWIFT_ANDROID_ARCH" == "x86_64" ]
then
    export TARGET=x86_64-none-linux-android
    export TARGET2=x86_64-unknown-linux-android
    export TRIPLE=x86_64-linux-android
    export ARCH=x86_64
    export SWIFT_ARCH=x86_64
    export ABI=x86_64
    export TOOLCHAIN_ROOT=x86_64
elif [ "$SWIFT_ANDROID_ARCH" == "armv7" ]
then
    export TARGET=armv7-unknown-linux-androideabi
    export TARGET2=armv7-none-linux-androideabi
    export TRIPLE=arm-linux-androideabi
    export ARCH=arm
    export SWIFT_ARCH=armv7
    export ABI=armeabi-v7a
    export TOOLCHAIN_ROOT=arm-linux-androideabi
elif [ "$SWIFT_ANDROID_ARCH" == "i686" ]
then
    export TARGET=i686-none-linux-android
    export TARGET2=i686-unknown-linux-android
    export TRIPLE=i686-linux-android
    export ARCH=x86
    export SWIFT_ARCH=i686
    export ABI=x86
    export TOOLCHAIN_ROOT=x86
else
    echo "Unknown arch '$SWIFT_ANDROID_ARCH'"
    exit 1
fi

include=-I.build/jniLibs/include
libs=-L.build/jniLibs/$ABI

flags="-Xcc $include -Xswiftc $include -Xswiftc $libs"
flags+=" -Xlinker $libs"
flags+=" -Xcc -D__linux__ -Xcc -D__ANDROID__"
flags+=" -Xcc -D__ANDROID_API_N__=24 -Xcc -D__ANDROID_API_M__=23 -Xcc -D__ANDROID_API__=24"
flags+=" -Xcc -DDEPLOYMENT_TARGET_ANDROID -Xcc -DDEPLOYMENT_TARGET_LINUX -Xcc -DDEPLOYMENT_RUNTIME_SWIFT"
# flags+=" -Xcc -DTARGET_OS_LINUX=1 -Xcc -DTARGET_OS_ANDROID=1"
# https://stackoverflow.com/questions/8115192/android-ndk-getting-the-backtrace
flags+=" -Xcc -funwind-tables"

$SWIFT_ANDROID_HOME/toolchain/usr/bin/swift-build --destination=<($SELF_DIR/generate-destination-json.sh) $flags "$@"

#$SWIFT_ANDROID_HOME/toolchain/usr/bin/android-swift-build  --android-target ${TARGET2} $flags "$@"

echo -e "
######################## Swift-Android-Toolchain ########################

$SWIFT_ANDROID_HOME/toolchain/usr/bin/swift-build --destination=<($SELF_DIR/generate-destination-json.sh) $flags "$@"

Compile End

#########################################################################
"

exit $?
