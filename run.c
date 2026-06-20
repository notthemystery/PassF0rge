#include <stdio.h>
#include <stdlib.h>

#pragma once

#ifdef _WIN32
    #define EXPORT __declspec(dllexport)
    #define WINDOWS 1
    #define LINUX 0

#elif defined(__linux__)
    #define EXPORT __attribute__((visibility("default")))
    #define WINDOWS 0
    #define LINUX 1

#else
    #define EXPORT
    #define WINDOWS 0
    #define LINUX 0
#endif

EXPORT int run_linux(const char *username, const char *password) {
    setenv("USERNAME", username, 1);
    setenv("PASSWORD", password, 1);
    if (system("./Exploits/Linux/CopyFail") == 0) {
        return 0;
    } else {
        return -1;
    }
}

EXPORT run_windows(const char *username, const char *password) {
    setenv("USERNAME", username, 1);
    setenv("PASSWORD", password, 1);
    if (system("Exploits\\Windows\\RedSun.exe") == 0) {
        return 0;
    } else {
        return -1;
    }
}
