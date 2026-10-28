#ifndef CALC_H
#define CALC_H

double temp_sensor_calc(int select_sensor, int adc_value, int *info);

/* Версия библиотеки расчёта. */
const char *calc_version(void);

#endif
