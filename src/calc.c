#include <math.h>
#include "calc.h"
#include "util.h"

static const double LOG_A     = 20.0;
static const double LOG_B     = 5.0;
static const double EXP_A     = 2.0;
static const double EXP_B     = 2.0;
static const double EXP_SCALE = 50.0;
static const double SQ_K      = 1.0;

const char *calc_version(void)
{
    return "1.0.0";
}

double temp_sensor_calc(int select_sensor, int adc_value, int *info)
{
    int adc = clamp_int(adc_value, 0, 100);
    double real = 0.0;

    *info = (adc == adc_value) ? 1 : 0;

    switch (select_sensor) {
    case 1:
        real = (adc == 0) ? 0.0 : LOG_A * log(adc + 1) + LOG_B;
        break;
    case 2:
        real = EXP_A * exp((double)adc / EXP_SCALE) - EXP_B;
        break;
    case 3:
        real = SQ_K * adc * adc / 100.0;
        break;
    default:
        real = 0.0;
        *info = 0;
        break;
    }
    return real;
}
