#include <stdio.h>
#include "util.h"

int clamp_int(int v, int lo, int hi)
{
    if (v < lo) return lo;
    if (v > hi) return hi;
    return v;
}

void print_result(int select_sensor, int adc_value, double real, int info)
{
    printf("sensor=%d adc=%d -> real=%.4f info=%d\n",
           select_sensor, adc_value, real, info);
}
