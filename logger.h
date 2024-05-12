#ifndef LOGGER_H
#define LOGGER_H

#include <stdio.h>

// XXX
// Unused code for now, we will log stuff ad-hoc, then
// later make most useful interface.

// Thread-unsafe.
void logger_init(void);

// Private.
void logger(char *file, int line, char *msg, enum code, int inner);

// Thread-safe.
#define logger(...) logger(__FILE__, __LINE__, __VA_ARGS__)

#endif
