#include <stdio.h>
#include <stdlib.h>

#ifdef _WIN32
    #define EXPORT __declspec(dllexport)
#else
    #define EXPORT __attribute__((visibility("default")))
    char cmd[256];
#endif

EXPORT int run_linux(const char *username, const char *password)
{
    snprintf(cmd, sizeof(cmd), "./Exploits/Linux/CopyFail %s %s", username, password);
    return system(cmd) == 0 ? 0 : -1;
}


EXPORT int run_windows(const char *username, const char *password)
{
#ifdef _WIN32
    _putenv_s("USERNAME", username);
    _putenv_s("PASSWORD", password);
    system("Exploits\\Windows\\RedSun.exe") == 0 ? 0 : -1;
    _putenv_s("USERNAME", "");
    _putenv_s("USERNAME", "");
#endif
    return 0;
}
