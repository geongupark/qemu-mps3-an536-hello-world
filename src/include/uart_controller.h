#pragma once

#include <cstdint>

#define APB_UART0_BASE 0xE7C00000ul
#define __REG32(x) (*((volatile unsigned int *)(x)))
#define UART_DATA(base) __REG32(base + 0x00)
#define UART_STATE(base) __REG32(base + 0x04)
#define UART_CTRL(base) __REG32(base + 0x08)
#define UART_BAUDDIV(base) __REG32(base + 0x10)

class UartController {
public:
  static void Init();
  static void SendChar(char ch);
  static void WriteLine(const char *str);

  static constexpr uint32_t CalculateBaudDivisor(uint32_t baud_rate,
                                                 uint32_t system_clock_hz) {
    if (baud_rate == 0)
      return 0;
    return system_clock_hz / baud_rate;
  }
};
