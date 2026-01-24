// pw_sys_io backend implementation for MPS3-AN536 (Cortex-R52)
// This provides console I/O for pw_unit_test output via UART

#include "pw_sys_io/sys_io.h"
#include "pw_status/status.h"

#include <cstdint>

namespace {

// MPS3-AN536 UART0 registers
constexpr uint32_t APB_UART0_BASE = 0xE7C00000ul;
constexpr uint32_t UART_DATA_OFFSET = 0x00;
constexpr uint32_t UART_STATE_OFFSET = 0x04;
constexpr uint32_t UART_CTRL_OFFSET = 0x08;
constexpr uint32_t UART_BAUDDIV_OFFSET = 0x10;

// State register bits
constexpr uint32_t UART_STATE_TX_FULL = (1u << 0);
constexpr uint32_t UART_STATE_RX_FULL = (1u << 1);

volatile uint32_t& UartReg(uint32_t offset) {
    return *reinterpret_cast<volatile uint32_t*>(APB_UART0_BASE + offset);
}

bool uart_initialized = false;

void EnsureUartInitialized() {
    if (uart_initialized) return;
    
    // Disable UART
    UartReg(UART_CTRL_OFFSET) = 0;
    // Set baud rate divisor (assuming 50MHz clock, 115200 baud)
    UartReg(UART_BAUDDIV_OFFSET) = 434;
    // Enable TX, RX, and TX interrupt
    UartReg(UART_CTRL_OFFSET) = (1u << 0) | (1u << 1) | (1u << 2);
    
    uart_initialized = true;
}

}  // namespace

namespace pw::sys_io {

Status ReadByte(std::byte* dest) {
    EnsureUartInitialized();
    
    // Wait for RX data available
    while (!(UartReg(UART_STATE_OFFSET) & UART_STATE_RX_FULL)) {
        // Busy wait
    }
    
    *dest = static_cast<std::byte>(UartReg(UART_DATA_OFFSET));
    return OkStatus();
}

Status TryReadByte(std::byte* dest) {
    EnsureUartInitialized();
    
    if (!(UartReg(UART_STATE_OFFSET) & UART_STATE_RX_FULL)) {
        return Status::Unavailable();
    }
    
    *dest = static_cast<std::byte>(UartReg(UART_DATA_OFFSET));
    return OkStatus();
}

Status WriteByte(std::byte b) {
    EnsureUartInitialized();
    
    // Wait until TX buffer is not full
    while (UartReg(UART_STATE_OFFSET) & UART_STATE_TX_FULL) {
        // Busy wait
    }
    
    UartReg(UART_DATA_OFFSET) = static_cast<uint32_t>(b);
    return OkStatus();
}

StatusWithSize WriteLine(std::string_view s) {
    size_t chars_written = 0;
    
    for (char c : s) {
        if (WriteByte(static_cast<std::byte>(c)).ok()) {
            ++chars_written;
        }
    }
    
    // Write newline
    if (WriteByte(static_cast<std::byte>('\r')).ok()) ++chars_written;
    if (WriteByte(static_cast<std::byte>('\n')).ok()) ++chars_written;
    
    return StatusWithSize(chars_written);
}

}  // namespace pw::sys_io
