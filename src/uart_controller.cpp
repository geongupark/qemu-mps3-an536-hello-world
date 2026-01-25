#include "uart_controller.h"

void UartController::Init() {
  UART_CTRL(APB_UART0_BASE) = 0;
  UART_BAUDDIV(APB_UART0_BASE) = 434;
  UART_CTRL(APB_UART0_BASE) = (1 << 0) | (1 << 1) | (1 << 2);
}

void UartController::SendChar(char ch) {
  while (UART_STATE(APB_UART0_BASE) & (1 << 0))
    ;
  UART_DATA(APB_UART0_BASE) = ch;
}

void UartController::WriteLine(const char *str) {
  while (*str) {
    SendChar(*str++);
  }
}
