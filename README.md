# qemu-mps3-an536-hello-world

"Hello, World!" Application on QEMU(mps3-an536, cortex-r52)

### Environment

- Compiler : arm-none-eabi
- HW specification : QEMU(mps3-an536, cortex-r52)

### Pre-condition

- Install QEMU, arm-none-eabi compiler, arm-none-eabi-gdb

### Build

```
make
```

### QEMU Debugging

Terminal1

```
qemu-system-arm -M mps3-an536 -kernel application.elf -serial mon:stdio -nographic -s -S
```

Terminal2

```
arm-none-eabi-gdb application.elf
target remote :1234
```
