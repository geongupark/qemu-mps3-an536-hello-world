#include "pw_unit_test/framework.h"
#include "uart_controller.h"

TEST(UartControllerTest, BaudDivisorCalculation_50MHz_115200) {
  uint32_t divisor = UartController::CalculateBaudDivisor(115200, 50000000);
  EXPECT_EQ(divisor, 434u);
}

TEST(UartControllerTest, BaudDivisorCalculation_25MHz_9600) {
  uint32_t divisor = UartController::CalculateBaudDivisor(9600, 25000000);
  EXPECT_EQ(divisor, 2604u);
}

TEST(UartControllerTest, BaudDivisorCalculation_ZeroBaud) {
  uint32_t divisor = UartController::CalculateBaudDivisor(0, 50000000);
  EXPECT_EQ(divisor, 0u);
}
