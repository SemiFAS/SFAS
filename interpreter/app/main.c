#include <stdio.h>
#include <stdbool.h>
#include <glib.h>

int main(void)
{
    /* Test Linker option for Glib */
    GArray *t = g_array_new(false, true, sizeof(int));
    g_array_free(t, false);

    /* This is only stub, To remove */
    printf("Interpreter stub\n");
    return 0;
}