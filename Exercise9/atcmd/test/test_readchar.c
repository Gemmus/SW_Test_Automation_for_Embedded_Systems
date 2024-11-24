/************************** */
/*          Headers         */
/************************** */
#include <stdbool.h>
#include <stdint.h>
#include "unity.h"

//-- module being tested
#include "readchar.h"
//-- module(s) being mocked
#include "mock_hw.h"

/************************** */
/*      Setup, Teardown     */
/************************** */
void setUp(void) {}

void tearDown(void) {}


/****************************/
/*    Macros definitions    */
/************************** */
#ifdef DEBUG_PRINT
#define DBG_PRINT(f_, ...)  printf((f_), ##__VA_ARGS__)
#else
#define DBG_PRINT(f_, ...)
#endif

/************************** */
/*     Helper functions     */
/************************** */
static void setup_getchar_sequence(const int *sequence, int length) {
    for (int i = 0; i < length; ++i) {
        DBG_PRINT(" sequence[%d] =  %d\n", i, sequence[i]);
        getchar_wait_us_ExpectAndReturn(500000, sequence[i]);
    }
}

/************************** */
/*      Test functions      */
/************************** */
void test_escape_sequence_pass(void) {

    DBG_PRINT("\nPASS TEST ESCAPE SEQUENCE INIT\n");
    DBG_PRINT("========================\n");

    int ch;
    bool result = false;
    const int sequence[] = {-1, -1, -1, '+', '+', '+', -1, -1, -1};
    const int buff_size = sizeof(sequence) / sizeof(sequence[0]);

    setup_getchar_sequence(sequence, buff_size);

    for (int i = 0; i < buff_size; ++i) {
        result = read_character(&ch);
        DBG_PRINT("result[%d] = %d\n", i, result);
    }

    TEST_ASSERT_TRUE(result);
}

void test_escape_sequence_fail(void) {

    DBG_PRINT("\nFAIL TEST ESCAPE SEQUENCE INIT\n");
    DBG_PRINT("========================\n");

    int ch;
    bool result = true;
    const int sequence[] = {-1, -1, -1, '+', '+', '+', -1, -1, '+'};
    const int buff_size = sizeof(sequence) / sizeof(sequence[0]);

    setup_getchar_sequence(sequence, buff_size);

    for (int i = 0; i < buff_size; ++i) {
        result = read_character(&ch);
        DBG_PRINT("result[%d] = %d\n", i, result);
    }

    TEST_ASSERT_FALSE(result);
}