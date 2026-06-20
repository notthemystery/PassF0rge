import 'dart:ui';
import 'package:flutter/material.dart';
import 'ffi_backend.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: GlassApp(),
    );
  }
}

class GlassApp extends StatefulWidget {
  const GlassApp({super.key});

  @override
  State<GlassApp> createState() => _GlassAppState();
}

class _GlassAppState extends State<GlassApp> {
  final backend = Backend();

  final TextEditingController user = TextEditingController();
  final TextEditingController pass1 = TextEditingController();
  final TextEditingController pass2 = TextEditingController();
  final TextEditingController status = TextEditingController();

  void runAction() {
    int result = backend.runOS();

    setState(() {
      if (result == 1) {
        status.text = "C backend executed successfully";
      } else {
        status.text = "Execution failed";
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
                "My Secure Tool",
                style: TextStyle(
                  fontSize: 24,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 20),

              // Glass panel
              ClipRRect(
                borderRadius: BorderRadius.circular(18),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                  child: Container(
                    width: 350,
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
                onPressed: runAction,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF6C5CE7),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 40,
                    vertical: 14,
                  ),
                ),
                child: const Text("RUN"),
              )
            ],
          ),
        ),
      ),
    );
  }
}
