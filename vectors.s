.cpu cortex-r52

.global _start
.section .text
_start:
    LDR sp, stack_ptr
    B reset

    .word hang
    .word hang
    .word hang
    .word hang
    .word hang
    .word hang
    .word hang

stack_ptr: .word 0x10010000

reset:
    BL main
    B hang

hang:
    B hang

.globl PUT32
PUT32:
    STR r1, [r0]
    BX lr
