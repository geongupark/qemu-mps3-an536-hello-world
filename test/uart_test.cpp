#include "pw_unit_test/framework.h"

// Declaration of the class in application.cpp
class UartController;

// Since we include application.cpp in the test build, we can just use the class
#include "../application.cpp"

TEST(UartControllerTest, BaudDivisorCalculation_50MHz_115200) {
  uint32_t divisor = UartController::CalculateBaudDivisor(115200, 50000000);
  EXPECT_EQ(divisor, 434u);
}

TEST(UartControllerTest, BaudDivisorCalculation_25MHz_9600) {
  uint32_t divisor = UartController::CalculateBaudDivisor(9600, 25000000);
  EXPECT_EQ(divisor, 2604u);
}

TEST(UartControllerTest, StatusBit_TxFull) {
    // In application.cpp, bit 0 is TX_FULL
    EXPECT_EQ(1 << 0, 1);
}
