import 'dart:io';
import 'package:flutter/services.dart';

class AppBootstrap {
  static Future<String> init() async {
    final appDir = await _getAppDir();
    final dllPath = "$appDir/backend.dll";

    final dllFile = File(dllPath);

    // If already extracted → skip
    if (await dllFile.exists()) {
      return appDir;
    }

    await dllFile.create(recursive: true);

    final data = await rootBundle.load("run.dll");
    await dllFile.writeAsBytes(data.buffer.asUint8List());

    return appDir;
  }

  static Future<String> _getAppDir() async {
    final base = Platform.environment['LOCALAPPDATA']
        ?? Directory.systemTemp.path;

    final dir = Directory("$base\\PassF0rge");
    if (!await dir.exists()) {
      await dir.create(recursive: true);
    }
    return dir.path;
  }
}
