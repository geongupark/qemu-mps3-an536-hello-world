#!/bin/bash
set -e

BUILD_DIR="build_out"
TOOLCHAIN="cmake/arm-cortex-r52-toolchain.cmake"

echo "=== Building MPS3-AN536 Project (App + Tests) ==="

rm -rf "$BUILD_DIR"
mkdir -p "$BUILD_DIR"

cd "$BUILD_DIR"
cmake .. -DCMAKE_TOOLCHAIN_FILE="../$TOOLCHAIN"
make -j$(nproc)

echo ""
echo "=== Build completed successfully ==="
echo "App binary: $BUILD_DIR/src/application.bin"
echo "Test binary: $BUILD_DIR/test/tests.bin"
