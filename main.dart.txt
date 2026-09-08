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
      title: 'Mouse Pointer App',
      home: const PointerHomeScreen(),
    );
  }
}

class PointerHomeScreen extends StatefulWidget {
  const PointerHomeScreen({super.key});

  @override
  State<PointerHomeScreen> createState() => _PointerHomeScreenState();
}

class _PointerHomeScreenState extends State<PointerHomeScreen> {
  bool isRunning = false;
  Offset pointerPos = const Offset(200, 300);
  Offset lastTouch = Offset.zero;
  bool isInsideTarget = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF202020),
      body: Stack(
        children: [
          // خلفية تفاعلية لتحريك السهم ولمس الشاشة
          Positioned.fill(
            child: GestureDetector(
              onPanStart: (details) {
                if (!isRunning) return;
                lastTouch = details.globalPosition;
              },
              onPanUpdate: (details) {
                if (!isRunning) return;
                final dx = details.globalPosition.dx - lastTouch.dx;
                final dy = details.globalPosition.dy - lastTouch.dy;

                setState(() {
                  pointerPos = Offset(
                    (pointerPos.dx + dx).clamp(20.0, MediaQuery.of(context).size.width - 20),
                    (pointerPos.dy + dy).clamp(50.0, MediaQuery.of(context).size.height - 50),
                  );
                });

                lastTouch = details.globalPosition;
              },
              onPanEnd: (details) {
                if (!isRunning) return;
                // محاكاة النقر في مكان السهم
                // هنا يتم تفعيل الزر أو الكليك عند مكان سهم الماوس بدلاً من الإصبع
              },
              child: Container(
                color: Colors.transparent,
                child: Center(
                  child: Container(
                    width: 180,
                    height: 80,
                    decoration: BoxDecoration(
                      color: const Color(0xFF555555),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: const Center(
                      child: Text(
                        "اضغط هنا",
                        style: TextStyle(color: Colors.white, fontSize: 22),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),

          // سهم الماوس المتحرك
          if (isRunning)
            Positioned(
              left: pointerPos.dx - 12,
              top: pointerPos.dy - 14,
              child: IgnorePointer(
                child: Transform.rotate(
                  angle: -0.785398, // -45 degrees
                  child: const Icon(
                    Icons.navigation,
                    color: Colors.white,
                    size: 30,
                  ),
                ),
              ),
            ),

          // زر التشغيل والإيقاف العائم في الأعلى
          Positioned(
            top: 50,
            left: 20,
            right: 20,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton.icon(
                  onPressed: () {
                    setState(() {
                      isRunning = !isRunning;
                    });
                  },
                  icon: Icon(isRunning ? Icons.stop : Icons.play_arrow),
                  label: Text(isRunning ? "إيقاف الماوس" : "تشغيل الماوس"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isRunning ? Colors.red : Colors.green,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
