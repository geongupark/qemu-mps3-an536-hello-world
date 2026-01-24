#include <cstdio>
#include <string_view>
#include "pw_sys_io/sys_io.h"
#include "pw_unit_test/framework.h"
#include "pw_unit_test/simple_printing_event_handler.h"

namespace {

void ExitQemu(bool success) {
  uint32_t r0_val = 0x18;
  uint32_t r1_val = success ? 0x20026 : 0x20023;

  __asm__ volatile (
      "mov r0, %0\n"
      "mov r1, %1\n"
      "bkpt #0xAB\n"
      :
      : "r"(r0_val), "r"(r1_val)
      : "r0", "r1", "memory"
  );

  while (true) {
    __asm__ volatile("wfi");
  }
}

void WriteStringToUart(std::string_view s, bool newline) {
  for (char c : s) {
    pw::sys_io::WriteByte(static_cast<std::byte>(c)).IgnoreError();
  }
  if (newline) {
    pw::sys_io::WriteByte(static_cast<std::byte>('\n')).IgnoreError();
  }
}

} // namespace

extern "C" int test_main() {
  pw::unit_test::SimplePrintingEventHandler handler(WriteStringToUart);
  pw::unit_test::RegisterEventHandler(&handler);

  int status = RUN_ALL_TESTS();

  ExitQemu(status == 0);

  return 0;
}
