#!/bin/bash
# Build unit tests for MPS3-AN536 (Cortex-R52)

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TEST_DIR="$(dirname "$SCRIPT_DIR")"
PROJECT_DIR="$(dirname "$TEST_DIR")"
BUILD_DIR="${TEST_DIR}/build"
TOOLCHAIN_FILE="${TEST_DIR}/cmake/arm-cortex-r52-toolchain.cmake"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${YELLOW}=== Building MPS3-AN536 Unit Tests ===${NC}"

# Check for required tools
if ! command -v cmake &> /dev/null; then
    echo -e "${RED}Error: cmake not found${NC}"
    exit 1
fi

# Create build directory
rm -rf "${BUILD_DIR}"
mkdir -p "${BUILD_DIR}"
cd "${BUILD_DIR}"

# Configure with CMake (source is test/ directory)
echo -e "${GREEN}Configuring CMake...${NC}"
cmake "$TEST_DIR" \
    -DCMAKE_TOOLCHAIN_FILE="${TOOLCHAIN_FILE}" \
    -DCMAKE_BUILD_TYPE=Debug \
    -G "Unix Makefiles"

if [ $? -ne 0 ]; then
    echo -e "${RED}CMake configuration failed${NC}"
    exit 1
fi

# Build
echo -e "${GREEN}Building...${NC}"
cmake --build . --parallel $(sysctl -n hw.ncpu 2>/dev/null || nproc 2>/dev/null || echo 4)

if [ $? -ne 0 ]; then
    echo -e "${RED}Build failed${NC}"
    exit 1
fi

echo -e "${GREEN}=== Build completed successfully ===${NC}"
echo "Test binary: ${BUILD_DIR}/tests"
echo "Run tests with: ./run_tests.sh"
