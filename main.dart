import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Floating Mouse',
      theme: ThemeData.dark(),
      home: const MouseControlScreen(),
    );
  }
}

class MouseControlScreen extends StatefulWidget {
  const MouseControlScreen({super.key});

  @override
  State<MouseControlScreen> createState() => _MouseControlScreenState();
}

class _MouseControlScreenState extends State<MouseControlScreen> {
  bool _isServiceRunning = false;

  void _toggleMouseService() {
    setState(() {
      _isServiceRunning = !_isServiceRunning;
    });
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(_isServiceRunning ? 'تم تفعيل وضع الماوس' : 'تم إيقاف الماوس'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('الماوس العائم الشامل'),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              _isServiceRunning ? Icons.mouse : Icons.power_settings_new,
              size: 100,
              color: _isServiceRunning ? Colors.greenAccent : Colors.redAccent,
            ),
            const SizedBox(height: 30),
            Text(
              _isServiceRunning ? 'الماوس جاهز للعمل الشامل' : 'الخدمة متوقفة',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 40),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: _isServiceRunning ? Colors.red : Colors.green,
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
              ),
              onPressed: _toggleMouseService,
              icon: Icon(_isServiceRunning ? Icons.stop : Icons.play_arrow),
              label: Text(
                _isServiceRunning ? 'إيقاف الماوس' : 'تشغيل الماوس',
                style: const TextStyle(fontSize: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
