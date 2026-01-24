#!/bin/bash
# Build unit tests for MPS3-AN536 (Cortex-R52)

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BUILD_DIR="${SCRIPT_DIR}/build_test"
TOOLCHAIN_FILE="${SCRIPT_DIR}/cmake/arm-cortex-r52-toolchain.cmake"

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

if ! command -v arm-none-eabi-gcc &> /dev/null; then
    echo -e "${RED}Error: arm-none-eabi-gcc not found${NC}"
    echo "Install with: sudo apt install gcc-arm-none-eabi"
    exit 1
fi

# Create build directory
mkdir -p "${BUILD_DIR}"
cd "${BUILD_DIR}"

# Configure with CMake
echo -e "${GREEN}Configuring CMake...${NC}"
cmake .. \
    -DCMAKE_TOOLCHAIN_FILE="${TOOLCHAIN_FILE}" \
    -DCMAKE_BUILD_TYPE=Debug \
    -G "Unix Makefiles"

if [ $? -ne 0 ]; then
    echo -e "${RED}CMake configuration failed${NC}"
    exit 1
fi

# Build
echo -e "${GREEN}Building...${NC}"
cmake --build . --parallel $(nproc)

if [ $? -ne 0 ]; then
    echo -e "${RED}Build failed${NC}"
    exit 1
fi

echo -e "${GREEN}=== Build completed successfully ===${NC}"
echo "Test binary: ${BUILD_DIR}/test/tests.bin"
echo "Run tests with: ./run_tests.sh"
