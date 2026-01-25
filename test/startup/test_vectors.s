.cpu cortex-r52

.global _start
.section .text
_start:
    LDR pc, reset_addr
    LDR pc, undef_addr
    LDR pc, swi_addr
    LDR pc, prefetch_addr
    LDR pc, data_addr
    LDR pc, reserved_addr
    LDR pc, irq_addr
    LDR pc, fiq_addr

reset_addr:    .word reset
undef_addr:    .word hang
swi_addr:      .word hang
prefetch_addr: .word hang
data_addr:     .word hang
reserved_addr: .word hang
irq_addr:      .word hang
fiq_addr:      .word hang

reset:
    LDR sp, =_stack_top

    LDR r0, =_bss_start
    LDR r1, =_bss_end
    MOV r2, #0
bss_loop:
    CMP r0, r1
    BGE bss_done
    STR r2, [r0], #4
    B bss_loop
bss_done:

    BL __libc_init_array

    // Call test_main instead of main
    BL test_main

    B hang

hang:
    WFI
    B hang

.globl PUT32
PUT32:
    STR r1, [r0]
    BX lr

.weak __libc_init_array
__libc_init_array:
    PUSH {r4, r5, lr}
    LDR r4, =__init_array_start
    LDR r5, =__init_array_end
init_loop:
    CMP r4, r5
    BGE init_done
    LDR r0, [r4], #4
    BLX r0
    B init_loop
init_done:
    POP {r4, r5, pc}
