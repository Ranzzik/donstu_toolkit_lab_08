#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "calc.h"
#include "util.h"

#ifndef GIT_HASH
#define GIT_HASH "unknown"
#endif

#ifndef BUILD_DATE
#define BUILD_DATE "unknown"
#endif

int main(int argc, char *argv[])
{
    if (argc == 2 && strcmp(argv[1], "--version") == 0) {
        printf("temp_sensor_calc %s (git %s, built %s)\n",
               calc_version(), GIT_HASH, BUILD_DATE);
        return 0;
    }

    if (argc != 3) {
        fprintf(stderr, "Usage: %s <sensor 1..3> <adc 0..100>\n", argv[0]);
        return 2;
    }

    char *end1 = NULL;
    char *end2 = NULL;
    long sel = strtol(argv[1], &end1, 10);
    long adc = strtol(argv[2], &end2, 10);
    if (*end1 != '\0' || *end2 != '\0') {
        fprintf(stderr, "Error: arguments must be integers\n");
        return 2;
    }

    int info = 0;
    double real = temp_sensor_calc((int)sel, (int)adc, &info);
    print_result((int)sel, (int)adc, real, info);
    return 0;
}
