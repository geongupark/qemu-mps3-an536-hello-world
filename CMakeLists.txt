cmake_minimum_required(VERSION 3.10)
project(MPS3-AN536-Tests LANGUAGES C CXX ASM)

if(NOT CMAKE_TOOLCHAIN_FILE)
    message(FATAL_ERROR "CMAKE_TOOLCHAIN_FILE must be set")
endif()

set(PW_ROOT ${CMAKE_CURRENT_SOURCE_DIR}/third_party/pigweed)

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

add_subdirectory(test)
