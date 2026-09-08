import 'package:flutter/material.dart';
import 'package:flutter_overlay_window/flutter_overlay_window.dart';

void main() {
  runApp(const MyApp());
}

// نقطة دخول النافذة العائمة التي تظهر خارج التطبيق
@pragma("vm:entry-point")
void overlayMain() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: FloatingMouseOverlay(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Floating Mouse',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // طلب صلاحيات الظهور فوق التطبيقات وتشغيل الماوس العائم
  Future<void> _toggleOverlay() async {
    final bool? isGranted = await FlutterOverlayWindow.isPermissionGranted();
    if (isGranted == false) {
      await FlutterOverlayWindow.requestPermission();
      return;
    }

    final bool isActive = await FlutterOverlayWindow.isActive();
    if (isActive) {
      await FlutterOverlayWindow.closeOverlay();
    } else {
      await FlutterOverlayWindow.showOverlay(
        height: 300,
        width: 300,
        alignment: OverlayAlignment.center,
        flag: OverlayFlag.defaultFlag,
        visibility: NotificationVisibility.visibilityPublic,
        positionGravity: PositionGravity.none,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        title: const Text('الماوس العائم الاحترافي'),
        backgroundColor: const Color(0xFF1F1F1F),
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.mouse, size: 80, color: Colors.blueAccent),
              const SizedBox(height: 20),
              const Text(
                'اضغط لتفعيل الماوس العائم ليظهر فوق كل التطبيقات',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white70, fontSize: 16),
              ),
              const SizedBox(height: 30),
              ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent,
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
              ).wrap(
                ElevatedButton(
                  onPressed: _toggleOverlay,
                  child: const Text('تشغيل / إيقاف الماوس', style: TextStyle(fontSize: 18, color: Colors.white)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// شكل الماوس العائم الذي يظهر على الشاشة في الخلفية
class FloatingMouseOverlay extends StatefulWidget {
  const FloatingMouseOverlay({super.key});

  @override
  State<FloatingMouseOverlay> createState() => _FloatingMouseOverlayState();
}

class _FloatingMouseOverlayState extends State<FloatingMouseOverlay> {
  double _x = 0;
  double _y = 0;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Stack(
        children: [
          // منطقة تحريك الماوس بحرية على الشاشة
          Positioned(
            left: _x,
            top: _y,
            child: GestureDetector(
              onPanUpdate: (details) {
                setState(() {
                  _x += details.delta.dx;
                  _y += details.delta.dy;
                });
              },
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.black54,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.blueAccent, width: 2),
                ),
                child: const Icon(
                  Icons.navigation,
                  color: Colors.white,
                  size: 32,
                ),
              ),
            ),
          ),
          // زر الضغط المنفصل (الكليك) ليتم تنفيذ الضغطة مكان المؤشر
          Positioned(
            bottom: 20,
            right: 20,
            child: FloatingActionButton(
              backgroundColor: Colors.redAccent,
              onPressed: () {
                // هنا يتم إرسال أمر النقرة في إحداثيات مؤشر الماوس
                FlutterOverlayWindow.shareData("click_at_${_x}_${_y}");
              },
              child: const Icon(Icons.touch_app, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
