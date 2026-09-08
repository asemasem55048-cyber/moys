import 'package:flutter/material.dart';
import 'package:flutter_overlay_window/flutter_overlay_window.dart';

void main() {
  runApp(const MyApp());
}

// هذه الدالة مسؤولة عن تشغيل نافذة الماوس العائمة خارج التطبيق
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
      theme: ThemeData.dark(),
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
  // طلب إذن العرض فوق التطبيقات وتشغيل الماوس العائم
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
        height: 200,
        width: 200,
        alignment: Alignment.center,
        flag: OverlayFlag.clickThrough,
        visibility: NotificationVisibility.visibilityPublic,
        positionGravity: PositionGravity.none,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('الماوس العائم الشامل'),
        centerTitle: true,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.mouse, size: 80, color: Colors.greenAccent),
              const SizedBox(height: 20),
              const Text(
                'اضغط للتشغيل، وسيعمل الماوس العائم في الخارج على كل الشاشة',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white70, fontSize: 16),
              ),
              const SizedBox(height: 30),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                ),
                onPressed: _toggleOverlay,
                icon: const Icon(Icons.play_arrow),
                child: const Text('تشغيل الماوس العائم', style: TextStyle(fontSize: 18)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// شكل مؤشر الماوس الذي يظهر حرًا فوق التطبيقات الأخرى
class FloatingMouseOverlay extends StatefulWidget {
  const FloatingMouseOverlay({super.key});

  @override
  State<FloatingMouseOverlay> createState() => _FloatingMouseOverlayState();
}

class _FloatingMouseOverlayState extends State<FloatingMouseOverlay> {
  double _x = 100;
  double _y = 100;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Stack(
        children: [
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
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.black54,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.greenAccent, width: 2),
                ),
                child: const Icon(
                  Icons.navigation,
                  color: Colors.white,
                  size: 36,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
