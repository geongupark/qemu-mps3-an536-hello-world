# Test CMakeLists.txt - ONLY for testing

set(PW_ROOT ${CMAKE_CURRENT_SOURCE_DIR}/../third_party/pigweed)

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
    ${CMAKE_CURRENT_SOURCE_DIR}/pw_sys_io_mps3.cpp
)

# Test runner and the target logic
set(TEST_SOURCES
    ${CMAKE_CURRENT_SOURCE_DIR}/test_main.cpp
    ${CMAKE_CURRENT_SOURCE_DIR}/uart_test.cpp
    ${CMAKE_CURRENT_SOURCE_DIR}/pw_assert_trap.cpp
    ${CMAKE_CURRENT_SOURCE_DIR}/syscalls.cpp
)

add_executable(tests
    ${CMAKE_CURRENT_SOURCE_DIR}/test_vectors.s
    ${PW_UNIT_TEST_SOURCES}
    ${PW_SUPPORT_SOURCES}
    ${PW_SYS_IO_SOURCES}
    ${TEST_SOURCES}
)

target_include_directories(tests PRIVATE
    ${CMAKE_CURRENT_SOURCE_DIR}
    ${CMAKE_CURRENT_SOURCE_DIR}/..
    ${PW_INCLUDE_DIRS}
)

# Rename 'main' in application.cpp to 'prod_main' during test build
# to avoid conflict with the entry point, without modifying application.cpp
target_compile_definitions(tests PRIVATE
    main=prod_main
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
    -T${CMAKE_CURRENT_SOURCE_DIR}/test_linker.ld
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
