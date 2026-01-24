#!/bin/bash

# Configuration
QEMU=qemu-system-arm
MACHINE=mps3-an536
CPU=cortex-r52
TEST_BIN=build_test/test/tests.bin
TEST_ELF=build_test/test/tests
LOG_FILE=test_output.log

# Check if build exists
if [ ! -f "$TEST_ELF" ]; then
    echo "Test binary not found! Run ./build_tests.sh first."
    exit 1
fi

echo "=== MPS3-AN536 Unit Test Runner ==="
echo "Running tests on QEMU..."

# Run QEMU in the background, redirect output to a log file
$QEMU \
    -machine $MACHINE \
    -cpu $CPU \
    -nographic \
    -semihosting \
    -kernel $TEST_ELF > "$LOG_FILE" 2>&1 &

QEMU_PID=$!

# Monitor the log file for success or failure strings
MAX_WAIT=10
COUNT=0
SUCCESS=0

while [ $COUNT -lt $MAX_WAIT ]; do
    if grep -q "\[  PASSED  \]" "$LOG_FILE"; then
        echo "Tests passed!"
        SUCCESS=1
        break
    fi
    if grep -q "\[  FAILED  \]" "$LOG_FILE"; then
        echo "Tests failed!"
        SUCCESS=0
        break
    fi
    sleep 1
    COUNT=$((COUNT + 1))
done

# Kill QEMU
kill $QEMU_PID 2>/dev/null
wait $QEMU_PID 2>/dev/null

# Show output
cat "$LOG_FILE"

if [ $SUCCESS -eq 1 ]; then
    echo ""
    echo "=== Tests completed successfully ==="
    exit 0
else
    echo ""
    echo "=== Tests failed or timed out ==="
    exit 1
fi
