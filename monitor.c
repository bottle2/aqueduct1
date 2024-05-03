#include <assert.h>
#include <stdio.h>
#include <stdlib.h>
#include <uv.h>

uv_loop_t *loop = NULL;

void watch(uv_fs_event_t *handle, char const *filename, int events, int status)
{
}

int main(void)
{
    loop = uv_default_loop();

    return uv_run(loop, UV_RUN_DEFAULT);
}
