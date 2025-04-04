#define APB_UART0_BASE  0xE7C00000ul
#define __REG32(x)      (*((volatile unsigned int *)(x)))
#define UART_DATA(base) __REG32(base + 0x00)
#define UART_STATE(base) __REG32(base + 0x04)
#define UART_CTRL(base) __REG32(base + 0x08)
#define UART_BAUDDIV(base) __REG32(base + 0x10)

class UartController {
private:
    static constexpr unsigned long BASE_ADDR = APB_UART0_BASE;

public:
    static void init() {
        UART_CTRL(BASE_ADDR) = 0;
        UART_BAUDDIV(BASE_ADDR) = 434;
        UART_CTRL(BASE_ADDR) = (1 << 0) | (1 << 1) | (1 << 2);
    }

    static void putc(unsigned char ch) {
        while (UART_STATE(BASE_ADDR) & (1 << 0));
        UART_DATA(BASE_ADDR) = ch;
    }

    static void puts(const char* str) {
        while (*str) {
            putc(*str++);
        }
    }
};

extern "C" {
    int main(void) {
        UartController::init();
        UartController::putc('h');
	      UartController::putc('e');
	      UartController::putc('l');
        UartController::putc('l');
        UartController::putc('o');
        UartController::putc(',');
        UartController::putc('w');
        UartController::putc('o');
	      UartController::putc('r');
	      UartController::putc('l');
        UartController::putc('d');
        UartController::putc('!');

        UartController::puts("bye,world");
        return 0;
    }
}
