#define GLFW_INCLUDE_NONE
#include <GLFW/glfw3.h>

#ifdef __APPLE__
#define GLFW_EXPOSE_NATIVE_COCOA
#elif __linux__
#define GLFW_EXPOSE_NATIVE_X11
#endif

#include <GLFW/glfw3native.h>
