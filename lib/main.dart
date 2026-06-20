import 'dart:ffi';
import 'dart:io';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:ffi/ffi.dart';

typedef NativeRun = Int32 Function(
  Pointer<Utf8>,
  Pointer<Utf8>,
);

typedef DartRun = int Function(
  Pointer<Utf8>,
  Pointer<Utf8>,
);

void main() {
  runApp(const PassF0rgeApp());
}

class Backend {
  late final DynamicLibrary _lib;
  late final DartRun run;

  Backend() {
    _lib = Platform.isWindows
        ? DynamicLibrary.open("run.dll")
        : DynamicLibrary.open("librun.so");

    run = _lib.lookupFunction<NativeRun, DartRun>("run");
  }

  int runApp(String user, String pass) {
    final u = user.toNativeUtf8();
    final p = pass.toNativeUtf8();

    final result = run(u, p);

    calloc.free(u);
    calloc.free(p);

    return result;
  }
}

class PassF0rgeApp extends StatelessWidget {
  const PassF0rgeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Home(),
    );
  }
}

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final backend = Backend();

  final userCtrl = TextEditingController();
  final passCtrl = TextEditingController();
  final confirmCtrl = TextEditingController();
  final statusCtrl = TextEditingController();

  void run() {
    final user = userCtrl.text;
    final pass = passCtrl.text;
    final confirm = confirmCtrl.text;

    if (pass != confirm) {
      setState(() {
        statusCtrl.text = "Passwords do not match";
      });
      return;
    }

    final result = backend.runApp(user, pass);

    setState(() {
      if (result == 100) {
        statusCtrl.text = "Login success";
      } else {
        statusCtrl.text = "Login failed";
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF1B1B2F),
              Color(0xFF0F0F17),
            ],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [

              const Text(
                "PassF0rge",
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  letterSpacing: 2,
                ),
              ),

              const SizedBox(height: 6),

              const Text(
                "Secure FFI Auth Engine",
                style: TextStyle(
                  color: Colors.white54,
                  fontSize: 12,
                ),
              ),

              const SizedBox(height: 20),

              /// GLASS PANEL
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
                          controller: userCtrl,
                          decoration: const InputDecoration(
                            hintText: "Username",
                          ),
                        ),

                        const SizedBox(height: 10),

                        TextField(
                          controller: passCtrl,
                          obscureText: true,
                          decoration: const InputDecoration(
                            hintText: "Password",
                          ),
                        ),

                        const SizedBox(height: 10),

                        TextField(
                          controller: confirmCtrl,
                          obscureText: true,
                          decoration: const InputDecoration(
                            hintText: "Confirm Password",
                          ),
                        ),

                        const SizedBox(height: 10),

                        TextField(
                          controller: statusCtrl,
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
