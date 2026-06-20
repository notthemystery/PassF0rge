#include <stdio.h>
#include <stdlib.h>

#ifdef _WIN32
    #define EXPORT __declspec(dllexport)

    static void set_env(const char *name, const char *value)
    {
        _putenv_s(name, value);
    }

#else
    #define EXPORT __attribute__((visibility("default")))

    static void set_env(const char *name, const char *value)
    {
        setenv(name, value, 1);
    }

#endif

EXPORT int run_linux(const char *username, const char *password)
{
    set_env("USERNAME", username);
    set_env("PASSWORD", password);

    return system("./Exploits/Linux/CopyFail") == 0 ? 0 : -1;
}

EXPORT int run_windows(const char *username, const char *password)
{
    set_env("USERNAME", username);
    set_env("PASSWORD", password);

    return system("Exploits\\Windows\\RedSun.exe") == 0 ? 0 : -1;
}
