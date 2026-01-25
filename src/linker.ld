/* Linker script for MPS3-AN536 Bare-Metal Application */
ENTRY(_start)

MEMORY
{
    rom : ORIGIN = 0x00000000, LENGTH = 0x100000   /* 1MB ROM */
    ram : ORIGIN = 0x10000000, LENGTH = 0x80000    /* 512KB RAM */
}

_stack_top = 0x10080000;

SECTIONS
{
    .text : {
        KEEP(*(.text._start))
        KEEP(*(.text*_start*))
        *(.text*)
    } > rom

    .rodata : {
        *(.rodata*)
    } > rom

    .data : {
        _data_start = .;
        *(.data*)
        _data_end = .;
    } > ram AT > rom

    .bss : {
        _bss_start = .;
        *(.bss*)
        *(COMMON)
        . = ALIGN(4);
        _bss_end = .;
    } > ram
}
