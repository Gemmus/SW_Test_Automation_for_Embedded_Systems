#include <stdint.h>
#include "echo.h"
#include "hw.h"

#define LOCAL_ECHO_STATE_STORAGE_ADDRESS     0x0000

void set_local_echo(bool state)
{
    write_wds(LOCAL_ECHO_STATE_STORAGE_ADDRESS, state);
}

bool get_local_echo(void)
{
    return read_wds(LOCAL_ECHO_STATE_STORAGE_ADDRESS);
}