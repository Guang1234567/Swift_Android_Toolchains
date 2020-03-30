#!/bin/bash
: "${SWIFT_ANDROID_HOME:?$SWIFT_ANDROID_HOME should be set}"
: "${ANDROID_NDK_HOME:?$ANDROID_NDK_HOME should be set}"

EXTERNAL_TOOLCHAIN="$ANDROID_NDK_HOME/toolchains/$TOOLCHAIN_ROOT-4.9/prebuilt/darwin-x86_64"

cat <<JSON
{
    "version": 1,
    "dynamic-library-extension": "so",

    "target": "$TARGET",
    "sdk": "$SWIFT_ANDROID_HOME/toolchain",
    "toolchain-bin-dir": "$SWIFT_ANDROID_HOME/toolchain/usr/bin",

    "extra-swiftc-flags": [
        "-Xfrontend", 
        "-color-diagnostics",
        "-use-ld=gold", 
        "-tools-directory", "$EXTERNAL_TOOLCHAIN/$TRIPLE/bin",
        
        "-Xcc", "--sysroot", "-Xcc", "$SWIFT_ANDROID_HOME/toolchain",
        "-Xcc", "-isystem", "-Xcc", "$SWIFT_ANDROID_HOME/toolchain/usr/include",
        "-Xcc", "-isystem", "-Xcc", "$SWIFT_ANDROID_HOME/toolchain/usr/include/$TRIPLE",
        "-Xcc", "-isystem", "-Xcc", "$SWIFT_ANDROID_HOME/toolchain/usr/lib/swift",
        "-Xclang-linker", "--sysroot", "-Xclang-linker", "$ANDROID_NDK_HOME/platforms/android-24/arch-$ARCH",
        
        "-I$SWIFT_ANDROID_HOME/toolchain/usr/include",
        "-I$SWIFT_ANDROID_HOME/toolchain/usr/include/$TRIPLE",
        "-I$SWIFT_ANDROID_HOME/toolchain/usr/lib/swift",
        
        "-L$EXTERNAL_TOOLCHAIN/lib/gcc/$TRIPLE/4.9.x",
        "-L$ANDROID_NDK_HOME/sources/cxx-stl/llvm-libc++/libs/$ABI",
        "-L$SWIFT_ANDROID_HOME/toolchain/usr/lib/swift/android/$SWIFT_ARCH",
    ],
    "extra-cc-flags": [
        "-fPIC",
        "-fblocks",
        "--sysroot",    "$SWIFT_ANDROID_HOME/toolchain",
        "-isystem",     "$SWIFT_ANDROID_HOME/toolchain/usr/include/$TRIPLE",
        "-cxx-isystem", "$ANDROID_NDK_HOME/sources/cxx-stl/llvm-libc++/include",
        
        "-I/$ANDROID_NDK_HOME/sources/cxx-stl/llvm-libc++abi/include",
        "-I$SWIFT_ANDROID_HOME/toolchain/usr/lib/swift",
    ],
    "extra-cpp-flags": [
        "-lc++_shared",
    ]
}
JSON
