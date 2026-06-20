import 'dart:ffi';
import 'dart:io';

typedef NativeFunc = Int32 Function();
typedef DartFunc = int Function();

class Backend {
  late final DynamicLibrary _lib;

  late final DartFunc runWindows;
  late final DartFunc runLinux;

  Backend() {
    _lib = _loadLibrary();

    runWindows =
        _lib.lookupFunction<NativeFunc, DartFunc>("run_windows");

    runLinux =
        _lib.lookupFunction<NativeFunc, DartFunc>("run_linux");
  }

  DynamicLibrary _loadLibrary() {
    final exeDir = File(Platform.resolvedExecutable).parent.path;

    final path = Platform.isWindows
        ? "$exeDir\\run.dll"
        : "$exeDir/librun.so";

    return DynamicLibrary.open(path);
  }

  int runOS() {
    if (Platform.isWindows) return runWindows();
    if (Platform.isLinux) return runLinux();
    return -1;
  }
}
