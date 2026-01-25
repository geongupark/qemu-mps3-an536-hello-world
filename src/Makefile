# Makefile for MPS3-AN536 Bare-Metal Application (Production Build)
# This is completely independent from the test build

CC = arm-none-eabi-gcc
CXX = arm-none-eabi-g++
AS = arm-none-eabi-gcc
OBJCOPY = arm-none-eabi-objcopy
SIZE = arm-none-eabi-size

# Use Arm official toolchain if available
ARM_TOOLCHAIN = /Applications/ArmGNUToolchain/13.3.rel1/arm-none-eabi/bin
ifneq ($(wildcard $(ARM_TOOLCHAIN)/arm-none-eabi-gcc),)
    CC = $(ARM_TOOLCHAIN)/arm-none-eabi-gcc
    CXX = $(ARM_TOOLCHAIN)/arm-none-eabi-g++
    AS = $(ARM_TOOLCHAIN)/arm-none-eabi-gcc
    OBJCOPY = $(ARM_TOOLCHAIN)/arm-none-eabi-objcopy
    SIZE = $(ARM_TOOLCHAIN)/arm-none-eabi-size
endif

# Directories
SRC_DIR = .
BUILD_DIR = build

# Source files
C_SOURCES = 
CXX_SOURCES = uart_controller.cpp main.cpp
ASM_SOURCES = vectors.s

# Object files
OBJECTS = $(addprefix $(BUILD_DIR)/,$(C_SOURCES:.c=.o))
OBJECTS += $(addprefix $(BUILD_DIR)/,$(CXX_SOURCES:.cpp=.o))
OBJECTS += $(addprefix $(BUILD_DIR)/,$(ASM_SOURCES:.s=.o))

# Target
TARGET = $(BUILD_DIR)/application

# Flags
CPU_FLAGS = -mcpu=cortex-r52 -mthumb
CFLAGS = $(CPU_FLAGS) -Wall -ffunction-sections -fdata-sections -std=c11
CXXFLAGS = $(CPU_FLAGS) -Wall -ffunction-sections -fdata-sections -fno-exceptions -fno-rtti -std=c++17
ASFLAGS = $(CPU_FLAGS)
LDFLAGS = $(CPU_FLAGS) -T$(SRC_DIR)/linker.ld -nostartfiles -Wl,--gc-sections

# Include paths
INCLUDES = -I$(SRC_DIR)/include

# Rules
all: $(TARGET).bin
	@echo "Build complete: $(TARGET).bin"
	@$(SIZE) $(TARGET).elf

$(BUILD_DIR):
	mkdir -p $(BUILD_DIR)

$(BUILD_DIR)/%.o: $(SRC_DIR)/%.c | $(BUILD_DIR)
	$(CC) $(CFLAGS) $(INCLUDES) -c $< -o $@

$(BUILD_DIR)/%.o: $(SRC_DIR)/%.cpp | $(BUILD_DIR)
	$(CXX) $(CXXFLAGS) $(INCLUDES) -c $< -o $@

$(BUILD_DIR)/%.o: $(SRC_DIR)/%.s | $(BUILD_DIR)
	$(AS) $(ASFLAGS) -c $< -o $@

$(TARGET).elf: $(OBJECTS)
	$(CXX) $(LDFLAGS) $^ -o $@

$(TARGET).bin: $(TARGET).elf
	$(OBJCOPY) -O binary $< $@

clean:
	rm -rf $(BUILD_DIR)

run: $(TARGET).elf
	qemu-system-arm -M mps3-an536 -cpu cortex-r52 -nographic -semihosting -kernel $<

.PHONY: all clean run
