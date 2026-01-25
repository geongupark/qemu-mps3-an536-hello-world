# CMake Toolchain file for ARM Cortex-R52 (MPS3-AN536)
# For bare-metal cross-compilation with arm-none-eabi-gcc

set(CMAKE_SYSTEM_NAME Generic)
set(CMAKE_SYSTEM_PROCESSOR arm)

# Toolchain prefix
set(TOOLCHAIN_PREFIX arm-none-eabi-)

# Arm official toolchain path (installed via .pkg)
set(ARM_TOOLCHAIN_PATH "/Applications/ArmGNUToolchain/13.3.rel1/arm-none-eabi")

# Find the toolchain from Arm official path first
find_program(CMAKE_C_COMPILER ${ARM_TOOLCHAIN_PATH}/bin/${TOOLCHAIN_PREFIX}gcc)
find_program(CMAKE_CXX_COMPILER ${ARM_TOOLCHAIN_PATH}/bin/${TOOLCHAIN_PREFIX}g++)
find_program(CMAKE_ASM_COMPILER ${ARM_TOOLCHAIN_PATH}/bin/${TOOLCHAIN_PREFIX}gcc)
find_program(CMAKE_AR ${ARM_TOOLCHAIN_PATH}/bin/${TOOLCHAIN_PREFIX}ar)
find_program(CMAKE_OBJCOPY ${ARM_TOOLCHAIN_PATH}/bin/${TOOLCHAIN_PREFIX}objcopy)
find_program(CMAKE_OBJDUMP ${ARM_TOOLCHAIN_PATH}/bin/${TOOLCHAIN_PREFIX}objdump)
find_program(CMAKE_SIZE ${ARM_TOOLCHAIN_PATH}/bin/${TOOLCHAIN_PREFIX}size)

# Cortex-R52 specific flags
set(CPU_FLAGS "-mcpu=cortex-r52 -mthumb")

# Common flags
set(COMMON_FLAGS "${CPU_FLAGS} -ffunction-sections -fdata-sections -fno-exceptions -fno-rtti")

# C/C++ flags
set(CMAKE_C_FLAGS_INIT "${COMMON_FLAGS} -std=c11")
set(CMAKE_CXX_FLAGS_INIT "${COMMON_FLAGS} -std=c++17")
set(CMAKE_ASM_FLAGS_INIT "${CPU_FLAGS}")

# Linker flags
set(CMAKE_EXE_LINKER_FLAGS_INIT "-nostartfiles -nostdlib -Wl,--gc-sections")

# Don't try to run test executables on host
set(CMAKE_TRY_COMPILE_TARGET_TYPE STATIC_LIBRARY)

# Search paths
set(CMAKE_FIND_ROOT_PATH_MODE_PROGRAM NEVER)
set(CMAKE_FIND_ROOT_PATH_MODE_LIBRARY ONLY)
set(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE ONLY)
set(CMAKE_FIND_ROOT_PATH_MODE_PACKAGE ONLY)
