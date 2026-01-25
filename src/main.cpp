#include "uart_controller.h"

extern "C" {
int main(void) {
  UartController::Init();
  UartController::SendChar('h');
  UartController::SendChar('e');
  UartController::SendChar('l');
  UartController::SendChar('l');
  UartController::SendChar('o');
  UartController::SendChar(',');
  UartController::SendChar('w');
  UartController::SendChar('o');
  UartController::SendChar('r');
  UartController::SendChar('l');
  UartController::SendChar('d');
  UartController::SendChar('!');
  UartController::SendChar('\n');
  return 0;
}
}
