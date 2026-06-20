import 'dart:ffi';
import 'dart:io';

typedef NativeFunc = Int32 Function();
typedef DartFunc = int Function();

class Backend {
  late DynamicLibrary _lib;

  late DartFunc runWindows;
  late DartFunc runLinux;

  Backend() {
    _lib = Platform.isWindows
        ? DynamicLibrary.open("run.dll")
        : DynamicLibrary.open("librun.so");

    runWindows = _lib.lookupFunction<NativeFunc, DartFunc>("run_windows");
    runLinux   = _lib.lookupFunction<NativeFunc, DartFunc>("run_linux");
  }

  int runOS() {
    if (Platform.isWindows) return runWindows();
    if (Platform.isLinux) return runLinux();
    return -1;
  }
}
