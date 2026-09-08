
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const MouseApp());
}

class MouseApp extends StatelessWidget {
  const MouseApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Mouse',
      theme: ThemeData(
        useMaterial3: true,
      ),
      home: const MouseHome(),
    );
  }
}

class MouseHome extends StatelessWidget {
  const MouseHome({super.key});

  static const platform = MethodChannel('com.mouse.app/control');

  Future<void> startMouse() async {
    try {
      await platform.invokeMethod('startMouse');
    } catch (_) {}
  }

  Future<void> stopMouse() async {
    try {
      await platform.invokeMethod('stopMouse');
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mouse'),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: startMouse,
              child: const Text('تشغيل'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: stopMouse,
              child: const Text('إيقاف'),
            ),
          ],
        ),
      ),
    );
  }
}
