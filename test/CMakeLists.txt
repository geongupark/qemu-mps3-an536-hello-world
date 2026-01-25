# Test CMakeLists.txt - Unit tests for MPS3-AN536
# This is the main CMake file for the test build

cmake_minimum_required(VERSION 3.10)
project(MPS3-AN536-Tests LANGUAGES C CXX ASM)

if(NOT CMAKE_TOOLCHAIN_FILE)
    message(FATAL_ERROR "CMAKE_TOOLCHAIN_FILE must be set")
endif()

# Paths relative to test/ directory
set(SRC_DIR ${CMAKE_CURRENT_SOURCE_DIR}/../src)
set(PW_ROOT ${CMAKE_CURRENT_SOURCE_DIR}/third_party/pigweed)

# Pigweed include directories
set(PW_INCLUDE_DIRS
    ${PW_ROOT}/pw_unit_test/public
    ${PW_ROOT}/pw_preprocessor/public
    ${PW_ROOT}/pw_polyfill/public
    ${PW_ROOT}/pw_span/public
    ${PW_ROOT}/pw_status/public
    ${PW_ROOT}/pw_result/public
    ${PW_ROOT}/pw_bytes/public
    ${PW_ROOT}/pw_string/public
    ${PW_ROOT}/pw_containers/public
    ${PW_ROOT}/pw_numeric/public
    ${PW_ROOT}/pw_sys_io/public
    ${PW_ROOT}/pw_assert/public
    ${PW_ROOT}/pw_unit_test/light_public_overrides
    ${PW_ROOT}/pw_unit_test/public_overrides
    ${PW_ROOT}/pw_assert/assert_compatibility_public_overrides
    ${PW_ROOT}/pw_assert/print_and_abort_check_public_overrides
    ${PW_ROOT}/third_party/fuchsia/repo/sdk/lib/stdcompat/include
    ${PW_ROOT}/third_party/fuchsia/repo/sdk/lib/fit/include
)

# Production source library
add_library(uart_lib STATIC
    ${SRC_DIR}/uart_controller.cpp
)

target_include_directories(uart_lib PUBLIC
    ${SRC_DIR}/include
)

target_compile_options(uart_lib PRIVATE
    -Wall
    -fno-exceptions
    -fno-rtti
    -ffunction-sections
    -fdata-sections
)

# Pigweed sources
set(PW_UNIT_TEST_SOURCES
    ${PW_ROOT}/pw_unit_test/framework_light.cc
    ${PW_ROOT}/pw_unit_test/googletest_style_event_handler.cc
    ${PW_ROOT}/pw_unit_test/simple_printing_event_handler.cc
)

set(PW_SUPPORT_SOURCES
    ${PW_ROOT}/pw_status/status.cc
    ${PW_ROOT}/pw_string/string_builder.cc
)

set(PW_SYS_IO_SOURCES
    ${CMAKE_CURRENT_SOURCE_DIR}/support/pw_sys_io_mps3.cpp
)

# Test support files
set(TEST_SUPPORT_SOURCES
    ${CMAKE_CURRENT_SOURCE_DIR}/support/test_main.cpp
    ${CMAKE_CURRENT_SOURCE_DIR}/support/pw_assert_trap.cpp
    ${CMAKE_CURRENT_SOURCE_DIR}/support/syscalls.cpp
)

# Unit test files
set(UNIT_TEST_SOURCES
    ${CMAKE_CURRENT_SOURCE_DIR}/unit/uart_controller_test.cpp
)

add_executable(tests
    ${CMAKE_CURRENT_SOURCE_DIR}/startup/test_vectors.s
    ${PW_UNIT_TEST_SOURCES}
    ${PW_SUPPORT_SOURCES}
    ${PW_SYS_IO_SOURCES}
    ${TEST_SUPPORT_SOURCES}
    ${UNIT_TEST_SOURCES}
)

target_link_libraries(tests PRIVATE
    uart_lib
)

target_include_directories(tests PRIVATE
    ${SRC_DIR}/include
    ${CMAKE_CURRENT_SOURCE_DIR}/support
    ${PW_INCLUDE_DIRS}
)

target_compile_definitions(tests PRIVATE
    PW_UNIT_TEST_CONFIG_MEMORY_POOL_SIZE=4096
    PW_UNIT_TEST_CONFIG_EXPECTATION_BUFFER_SIZE=128
    PW_ASSERT_ENABLE_DEBUG=0
)

target_compile_options(tests PRIVATE
    -Wall
    -fno-exceptions
    -fno-rtti
    -ffunction-sections
    -fdata-sections
)

target_link_options(tests PRIVATE
    -T${CMAKE_CURRENT_SOURCE_DIR}/startup/test_linker.ld
    -Wl,--gc-sections
    -nostartfiles
    --specs=nano.specs
    --specs=nosys.specs
)

target_link_libraries(tests PRIVATE
    stdc++_nano
    c_nano
    m
    gcc
)

add_custom_command(TARGET tests POST_BUILD
    COMMAND ${CMAKE_OBJCOPY} -O binary $<TARGET_FILE:tests> ${CMAKE_CURRENT_BINARY_DIR}/tests.bin
    COMMENT "Generating test binary"
)
