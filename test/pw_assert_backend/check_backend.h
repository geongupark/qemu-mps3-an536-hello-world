// Minimal pw_assert backend for bare-metal MPS3-AN536
// Provides crash/assert handlers that simply halt the processor

#pragma once

#include "pw_preprocessor/arguments.h"
#include "pw_preprocessor/compiler.h"

// Simple crash handler - just halt
#define PW_HANDLE_CRASH(...)           \
  do {                                  \
    while (true) {                      \
      __asm__ volatile("wfi");          \
    }                                   \
  } while (0)

// Assert failure handler
#define PW_HANDLE_ASSERT_FAILURE(condition_str, ...) \
  PW_HANDLE_CRASH(__VA_ARGS__)

// Binary compare failure handler
#define PW_HANDLE_ASSERT_BINARY_COMPARE_FAILURE(lhs, op, rhs, type_fmt, ...) \
  PW_HANDLE_CRASH(__VA_ARGS__)
