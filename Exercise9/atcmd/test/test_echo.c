/************************** */
/*          Headers         */
/************************** */
#include <stdbool.h>
#include "unity.h"

//-- module being tested
#include "echo.h"
//-- module(s) being mocked
#include "mock_hw.h"

/****************************/
/*          Macros          */
/************************** */
#ifdef DEBUG_PRINT
#define DBG_PRINT(f_, ...)  printf((f_), ##__VA_ARGS__)
#else
#define DBG_PRINT(f_, ...)
#endif

#define LOCAL_ECHO_STATE_STORAGE_ADDRESS     0x0000

/************************** */
/*      Setup, Teardown     */
/************************** */
void setUp(void) {}

void tearDown(void) {}

/************************** */
/*      Test functions      */
/************************** */
void test_set_local_echo_stores_false(void) {
    DBG_PRINT("\nLOCAL ECHO TEST SET FALSE\n");
    DBG_PRINT("========================\n");

    bool state = false;
    write_wds_Expect(LOCAL_ECHO_STATE_STORAGE_ADDRESS, state);
    set_local_echo(state);
}

void test_set_local_echo_stores_true(void) {
    DBG_PRINT("\nLOCAL ECHO TEST SET TRUE\n");
    DBG_PRINT("========================\n");

    bool state = true;
    write_wds_Expect(LOCAL_ECHO_STATE_STORAGE_ADDRESS, state);
    set_local_echo(state);
}

void test_get_local_echo_returns_false_when_storage_is_zero(void) {
    DBG_PRINT("\nLOCAL ECHO TEST GET FALSE\n");
    DBG_PRINT("========================\n");

    read_wds_ExpectAndReturn(LOCAL_ECHO_STATE_STORAGE_ADDRESS, 0);
    TEST_ASSERT_FALSE(get_local_echo());
}

void test_get_local_echo_returns_true_when_storage_is_one(void) {
    DBG_PRINT("\nLOCAL ECHO TEST GET FALSE\n");
    DBG_PRINT("========================\n");

    read_wds_ExpectAndReturn(LOCAL_ECHO_STATE_STORAGE_ADDRESS, 1);
    TEST_ASSERT_TRUE(get_local_echo());
}
