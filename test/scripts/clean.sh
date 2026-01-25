#!/bin/bash
# Clean test build artifacts

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TEST_DIR="$(dirname "$SCRIPT_DIR")"
BUILD_DIR="${TEST_DIR}/build"

echo "=== Cleaning test build artifacts ==="

if [ -d "$BUILD_DIR" ]; then
    rm -rf "$BUILD_DIR"
    echo "Removed: $BUILD_DIR"
else
    echo "Nothing to clean (build directory does not exist)"
fi

# Also remove test output log
if [ -f "${TEST_DIR}/test_output.log" ]; then
    rm -f "${TEST_DIR}/test_output.log"
    echo "Removed: test_output.log"
fi

echo "=== Clean complete ==="
