#include <stdio.h>
#include <math.h>
#include "calc.h"

static int failed = 0;

static void check(const char *name, int select_sensor, int adc,
                  double expected_real, int expected_info)
{
    int info = -1;
    double real = temp_sensor_calc(select_sensor, adc, &info);
    int ok = (fabs(real - expected_real) < 1e-3) && (info == expected_info);
    printf("%-20s %s (real=%.4f info=%d)\n", name, ok ? "OK  " : "FAIL", real, info);
    if (!ok) failed++;
}

int main(void)
{
    check("log, adc=0",        1,   0,   0.0,     1);
    check("log, adc=50",       1,  50,  83.6365,  1);
    check("log, adc=100",      1, 100,  97.3024,  1);
    check("exp, adc=0",        2,   0,   0.0,     1);
    check("exp, adc=50",       2,  50,   3.4366,  1);
    check("exp, adc=100",      2, 100,  12.7781,  1);
    check("square, adc=50",    3,  50,  25.0,     1);
    check("square, adc=100",   3, 100, 100.0,     1);
    check("default, sensor=0", 0,  50,   0.0,     0);
    check("default, sensor=9", 9,  50,   0.0,     0);
    check("clamp, adc=-5",     3,  -5,   0.0,     0);
    check("clamp, adc=150",    3, 150, 100.0,     0);

    if (failed) {
        printf("FAILED: %d\n", failed);
        return 1;
    }
    printf("All tests passed\n");
    return 0;
}
