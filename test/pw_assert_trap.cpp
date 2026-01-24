// pw_assert trap implementation for bare-metal

extern "C" void _pw_assert_trap(void) {
    while (true) {
        __asm__ volatile("wfi");
    }
}
