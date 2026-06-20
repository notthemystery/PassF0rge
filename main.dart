import 'dart:io';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:ffi';

typedef NativeFunc = Int32 Function();
typedef DartFunc = int Function();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final backendPath = await AppBootstrap.init();

  final backend = Backend(backendPath);

  runApp(PassF0rgeApp(backend: backend));
}

class AppBootstrap {
  static Future<String> init() async {
    final dir = await _getAppDir();
    final dllPath = "$dir\\run.dll";

    final file = File(dllPath);
    if (!await file.exists()) {
      final data = await rootBundle.load("assets/run.dll");
      await file.create(recursive: true);
      await file.writeAsBytes(data.buffer.asUint8List());
    }

    return dir;
  }

  static Future<String> _getAppDir() async {
    final base =
        Platform.environment['LOCALAPPDATA'] ??
        Directory.systemTemp.path;

    final dir = Directory("$base\\PassF0rge");

    if (!await dir.exists()) {
      await dir.create(recursive: true);
    }

    return dir.path;
  }
}

class Backend {
  late final DynamicLibrary _lib;

  late final DartFunc runWindows;
  late final DartFunc runLinux;

  Backend(String appDir) {
    final path = Platform.isWindows
        ? "$appDir\\run.dll"
        : "$appDir/librun.so";

    _lib = DynamicLibrary.open(path);

    runWindows =
        _lib.lookupFunction<NativeFunc, DartFunc>("run_windows");

    runLinux =
        _lib.lookupFunction<NativeFunc, DartFunc>("run_linux");
  }

  int runOS() {
    if (Platform.isWindows) return runWindows();
    if (Platform.isLinux) return runLinux();
    return -1;
  }
}

class PassF0rgeApp extends StatelessWidget {
  final Backend backend;

  const PassF0rgeApp({super.key, required this.backend});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "PassF0rge",
      home: Home(backend: backend),
    );
  }
}

class Home extends StatefulWidget {
  final Backend backend;

  const Home({super.key, required this.backend});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final user = TextEditingController();
  final pass1 = TextEditingController();
  final pass2 = TextEditingController();
  final status = TextEditingController();

  void run() {
    int result = widget.backend.runOS();

    setState(() {
      if (result == 100) {
        status.text = "PassF0rge: Password Change Failed";
      } else if (result == 200) {
        status.text = "PassF0rge: Password Change Success!";
      } else {
        status.text = "PassF0rge: Execution failed";
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF1B1B2F), Color(0xFF0F0F17)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [

              const Text(
                "PassF0rge",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  letterSpacing: 2,
                ),
              ),

              const SizedBox(height: 6),

              const Text(
                "Secure FFI Password Tool Engine",
                style: TextStyle(
                  color: Colors.white54,
                  fontSize: 12,
                ),
              ),

              const SizedBox(height: 20),

              // Glass UI panel
              ClipRRect(
                borderRadius: BorderRadius.circular(18),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                  child: Container(
                    width: 360,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.08),
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(color: Colors.white24),
                    ),
                    child: Column(
                      children: [

                        TextField(
                          controller: user,
                          decoration: const InputDecoration(
                            hintText: "Username",
                          ),
                        ),

                        const SizedBox(height: 10),

                        TextField(
                          controller: pass1,
                          obscureText: true,
                          decoration: const InputDecoration(
                            hintText: "Password",
                          ),
                        ),

                        const SizedBox(height: 10),

                        TextField(
                          controller: pass2,
                          obscureText: true,
                          decoration: const InputDecoration(
                            hintText: "Confirm Password",
                          ),
                        ),

                        const SizedBox(height: 10),

                        TextField(
                          controller: status,
                          readOnly: true,
                          decoration: const InputDecoration(
                            hintText: "Status...",
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              ElevatedButton(
                onPressed: run,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF6C5CE7),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 50,
                    vertical: 14,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: const Text("RUN"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
