#include <stdio.h>

int ConsoleLog(void* ctx, const char * input) {
  printf(input);

  return 0;
}