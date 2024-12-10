// On some platforms (Linux), UINT64_MAX is defined via a "complex" macro that Swift cannot parse.
// Therefore it is redefined here as a simple constant, to allow Swift to use the webgpu constants.
#include <stdint.h>
#define UINT64_MAX 18446744073709551615ULL

#include <webgpu/webgpu.h>
