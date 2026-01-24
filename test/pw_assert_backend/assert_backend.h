// Minimal pw_assert backend for bare-metal MPS3-AN536
// Provides crash/assert handlers that simply halt the processor

#pragma once

#ifdef __cplusplus
extern "C" {
#endif

// Declare external function to avoid inline asm in constexpr context
void _pw_assert_trap(void);

#ifdef __cplusplus
}  // extern "C"
#endif

// Simple assert failure handler - calls external trap function
#define PW_ASSERT_HANDLE_FAILURE(condition_str) \
  _pw_assert_trap()
