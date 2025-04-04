ARMGNU = arm-none-eabi

AOPS = --warn --fatal-warnings -mcpu=cortex-r52
COPS = -Wall -Werror -O2 -nostdlib -nostartfiles -ffreestanding -mcpu=cortex-r52 -fno-exceptions -fno-rtti

all: application.bin

clean:
	rm -f *.bin
	rm -f *.o
	rm -f *.elf
	rm -f *.list

vectors.o: vectors.s
	$(ARMGNU)-as $(AOPS) vectors.s -o vectors.o

application.o: application.cpp
	$(ARMGNU)-g++ $(COPS) -c application.cpp -o application.o

application.bin: linker.ld vectors.o application.o
	$(ARMGNU)-ld -o application.elf -T linker.ld vectors.o application.o
	$(ARMGNU)-objdump -D application.elf > application.list
	$(ARMGNU)-objcopy application.elf application.bin -O binary
