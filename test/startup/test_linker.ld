/* Linker script for test build on MPS3-AN536 */
/* Memory Map:
 *   ROM: 0x00000000 - Flash/ROM area
 *   BRAM: 0x10000000 - 0x1007FFFF (512KB internal SRAM)
 *   DDR4: 0x20000000+ (External memory)
 */
ENTRY(_start)

MEMORY
{
    rom  : ORIGIN = 0x00000000, LENGTH = 0x100000    /* 1MB for code */
    bram : ORIGIN = 0x10000000, LENGTH = 0x80000     /* 512KB internal SRAM */
}

/* Stack at top of BRAM */
_stack_top = 0x10080000;

SECTIONS
{
    .text : {
        KEEP(*(.text._start))   /* Keep startup code */
        KEEP(*(.text*_start*))  /* Keep startup code */
        *(.text*)
    } > rom

    .rodata : {
        *(.rodata*)
    } > rom

    .init_array : {
        __init_array_start = .;
        KEEP(*(.init_array*))
        __init_array_end = .;
    } > rom

    .data : {
        _data_start = .;
        *(.data*)
        _data_end = .;
    } > bram AT > rom

    _data_load_start = LOADADDR(.data);

    .bss : {
        _bss_start = .;
        *(.bss*)
        *(COMMON)
        . = ALIGN(4);
        _bss_end = .;
    } > bram

    /* Heap starts after BSS, ends before stack */
    _heap_start = .;
    _heap_end = 0x10070000;  /* Leave 64KB for stack */
}
