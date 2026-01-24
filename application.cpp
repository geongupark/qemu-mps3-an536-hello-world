#include <cstdint>

#define APB_UART0_BASE  0xE7C00000ul
#define __REG32(x)      (*((volatile unsigned int *)(x)))
#define UART_DATA(base) __REG32(base + 0x00)
#define UART_STATE(base) __REG32(base + 0x04)
#define UART_CTRL(base) __REG32(base + 0x08)
#define UART_BAUDDIV(base) __REG32(base + 0x10)

class UartController {
public:
    static void Init() {
        UART_CTRL(APB_UART0_BASE) = 0;
        UART_BAUDDIV(APB_UART0_BASE) = 434;
        UART_CTRL(APB_UART0_BASE) = (1 << 0) | (1 << 1) | (1 << 2);
    }

    static void SendChar(char ch) {
        while (UART_STATE(APB_UART0_BASE) & (1 << 0));
        UART_DATA(APB_UART0_BASE) = ch;
    }

    static void WriteLine(const char* str) {
        while (*str) {
            SendChar(*str++);
        }
    }
    
    static constexpr uint32_t CalculateBaudDivisor(uint32_t baud_rate, uint32_t system_clock_hz) {
        if (baud_rate == 0) return 0;
        return system_clock_hz / baud_rate;
    }
};

extern "C" {
    int main(void) {
        UartController::Init();
        // Individual calls to match working version Step 794
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
