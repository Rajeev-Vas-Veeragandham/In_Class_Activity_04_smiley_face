import 'package:flutter/material.dart';
import 'dart:math';

void main() {
  runApp(const EmojiDrawingApp());
}

class EmojiDrawingApp extends StatelessWidget {
  const EmojiDrawingApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Animated Emoji Drawer',
      theme: ThemeData(primarySwatch: Colors.blue, useMaterial3: true),
      home: const EmojiDemoScreen(),
    );
  }
}

class EmojiDemoScreen extends StatefulWidget {
  const EmojiDemoScreen({super.key});

  @override
  State<EmojiDemoScreen> createState() => _EmojiDemoScreenState();
}

class _EmojiDemoScreenState extends State<EmojiDemoScreen>
    with SingleTickerProviderStateMixin {
  String selectedEmoji = 'Heart';
  late AnimationController bgController;

  @override
  void initState() {
    super.initState();
    bgController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 6),
    )..repeat();
  }

  @override
  Widget build(BuildContext context) {
    Widget emojiWidget;
    switch (selectedEmoji) {
      case 'Smiley':
        emojiWidget = const AnimatedSmileyFace();
        break;
      case 'Party':
        emojiWidget = const PartySmileyFace();
        break;
      case 'Heart':
        emojiWidget = const AnimatedHeart();
        break;
      default:
        emojiWidget = const AnimatedSmileyFace();
    }

    return Scaffold(
      body: AnimatedBuilder(
        animation: bgController,
        builder: (context, child) {
          return Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.deepPurple.shade400,
                  Colors.blue.shade400,
                  Colors.pink.shade400,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                stops: [
                  0.2 + 0.2 * sin(bgController.value * 2 * pi),
                  0.5,
                  0.8 - 0.2 * cos(bgController.value * 2 * pi),
                ],
              ),
            ),
            child: SafeArea(
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  ShaderMask(
                    shaderCallback: (bounds) => LinearGradient(
                      colors: [
                        Colors.yellow,
                        Colors.orange,
                        Colors.red,
                        Colors.purple,
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      transform: GradientRotation(bgController.value * 2 * pi),
                    ).createShader(bounds),
                    child: const Text(
                      "🎨 Animated Emoji Drawer",
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 500),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFFFF416C), Color(0xFFFF4B2B)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(25),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.3),
                          blurRadius: 12,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: DropdownButton<String>(
                      value: selectedEmoji,
                      dropdownColor: Colors.black87,
                      style: const TextStyle(color: Colors.white, fontSize: 18),
                      underline: const SizedBox(),
                      icon: const Icon(
                        Icons.arrow_drop_down,
                        color: Colors.white,
                      ),
                      items: const [
                        DropdownMenuItem(
                          value: 'Smiley',
                          child: Text("🙂 Smiley Face"),
                        ),
                        DropdownMenuItem(
                          value: 'Party',
                          child: Text("🥳 Party Smiley"),
                        ),
                        DropdownMenuItem(
                          value: 'Heart',
                          child: Text("❤️ Heart Emoji"),
                        ),
                      ],
                      onChanged: (val) {
                        setState(() {
                          selectedEmoji = val!;
                        });
                      },
                    ),
                  ),
                  const SizedBox(height: 20),
                  Expanded(
                    child: Center(
                      child: Container(
                        margin: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Colors.white, Colors.grey.shade200],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: const BorderRadius.all(
                            Radius.circular(25),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black26,
                              blurRadius: 15,
                              spreadRadius: 3,
                            ),
                          ],
                        ),
                        child: emojiWidget,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    bgController.dispose();
    super.dispose();
  }
}

//// ---------------- Animated Heart ---------------- ////

class AnimatedHeart extends StatefulWidget {
  const AnimatedHeart({super.key});

  @override
  State<AnimatedHeart> createState() => _AnimatedHeartState();
}

class _AnimatedHeartState extends State<AnimatedHeart>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return CustomPaint(
          size: const Size(300, 300),
          painter: HeartPainter(_controller.value),
        );
      },
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

class HeartPainter extends CustomPainter {
  final double progress;
  HeartPainter(this.progress);

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final heartPath = Path();

    heartPath.moveTo(center.dx, center.dy + 40);
    heartPath.cubicTo(
      center.dx - 60,
      center.dy - 20,
      center.dx - 40,
      center.dy - 100,
      center.dx,
      center.dy - 60,
    );
    heartPath.cubicTo(
      center.dx + 40,
      center.dy - 100,
      center.dx + 60,
      center.dy - 20,
      center.dx,
      center.dy + 40,
    );

    final gradient = RadialGradient(
      colors: [
        Colors.redAccent.withOpacity(0.7 + 0.3 * sin(progress * 2 * pi)),
        Colors.purpleAccent.withOpacity(0.6 + 0.4 * cos(progress * 2 * pi)),
      ],
    );

    final paint = Paint()
      ..shader = gradient.createShader(
        Rect.fromCircle(center: center, radius: 120),
      )
      ..style = PaintingStyle.fill;

    canvas.drawPath(heartPath, paint);

    final glowPaint = Paint()
      ..color = Colors.pink.withOpacity(0.5)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 6 + 3 * sin(progress * 2 * pi);
    canvas.drawPath(heartPath, glowPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

//// ---------------- Animated Smiley ---------------- ////

class AnimatedSmileyFace extends StatefulWidget {
  const AnimatedSmileyFace({super.key});

  @override
  State<AnimatedSmileyFace> createState() => _AnimatedSmileyFaceState();
}

class _AnimatedSmileyFaceState extends State<AnimatedSmileyFace>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        return CustomPaint(
          size: const Size(300, 300),
          painter: SmileyPainter(_controller.value),
        );
      },
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

class SmileyPainter extends CustomPainter {
  final double progress;
  SmileyPainter(this.progress);

  @override
  void paint(Canvas canvas, Size size) {
    final c = Offset(size.width / 2, size.height / 2);

    final facePaint = Paint()
      ..shader = RadialGradient(
        colors: [Colors.yellow.shade200, Colors.yellow.shade700],
      ).createShader(Rect.fromCircle(center: c, radius: 100));
    canvas.drawCircle(c, 100, facePaint);

    final eyePaint = Paint()..color = Colors.black;
    double blink = (sin(progress * 2 * pi) + 1) / 2;
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(c.dx - 40, c.dy - 30),
        width: 20,
        height: 20 * blink,
      ),
      eyePaint,
    );
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(c.dx + 40, c.dy - 30),
        width: 20,
        height: 20 * blink,
      ),
      eyePaint,
    );

    final smilePaint = Paint()
      ..color = Colors.black
      ..strokeWidth = 6
      ..style = PaintingStyle.stroke;
    final smileRect = Rect.fromCircle(
      center: Offset(c.dx, c.dy + 20),
      radius: 50,
    );
    double sweep = 0.6 * pi + 0.2 * pi * sin(progress * 2 * pi);
    canvas.drawArc(smileRect, 0.2 * pi, sweep, false, smilePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

//// ---------------- Party Smiley ---------------- ////

class PartySmileyFace extends StatefulWidget {
  const PartySmileyFace({super.key});

  @override
  State<PartySmileyFace> createState() => _PartySmileyFaceState();
}

class _PartySmileyFaceState extends State<PartySmileyFace>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final Random random = Random();
  final List<ConfettiPiece> confetti = [];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();
    for (int i = 0; i < 60; i++) {
      confetti.add(
        ConfettiPiece(
          x: random.nextDouble() * 300,
          y: random.nextDouble() * -300,
          color: Colors.primaries[random.nextInt(Colors.primaries.length)],
          size: 5 + random.nextDouble() * 8,
          speed: 1 + random.nextDouble() * 2,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        for (var c in confetti) {
          c.y += c.speed;
          if (c.y > 300) {
            c.y = random.nextDouble() * -100;
            c.x = random.nextDouble() * 300;
          }
        }
        return Stack(
          alignment: Alignment.center,
          children: [
            CustomPaint(
              size: const Size(300, 300),
              painter: SmileyPainter(_controller.value),
            ),
            CustomPaint(
              size: const Size(300, 300),
              painter: PartyHatPainter(_controller.value),
            ),
            CustomPaint(
              size: const Size(300, 300),
              painter: ConfettiPainter(confetti),
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

class ConfettiPiece {
  double x, y, size, speed;
  Color color;
  ConfettiPiece({
    required this.x,
    required this.y,
    required this.color,
    required this.size,
    required this.speed,
  });
}

class ConfettiPainter extends CustomPainter {
  final List<ConfettiPiece> confetti;
  ConfettiPainter(this.confetti);
  @override
  void paint(Canvas canvas, Size size) {
    for (var c in confetti) {
      final paint = Paint()..color = c.color;
      canvas.drawCircle(Offset(c.x, c.y), c.size / 2, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class PartyHatPainter extends CustomPainter {
  final double progress;
  PartyHatPainter(this.progress);
  @override
  void paint(Canvas canvas, Size size) {
    final c = Offset(size.width / 2, size.height / 2);
    final hatPath = Path()
      ..moveTo(c.dx - 40, c.dy - 100)
      ..lineTo(c.dx, c.dy - 170 - 5 * sin(progress * 2 * pi))
      ..lineTo(c.dx + 40, c.dy - 100)
      ..close();
    final hatPaint = Paint()
      ..shader = LinearGradient(
        colors: [Colors.red, Colors.orange, Colors.purple],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ).createShader(Rect.fromLTWH(c.dx - 40, c.dy - 170, 80, 70));
    canvas.drawPath(hatPath, hatPaint);
    canvas.drawCircle(
      Offset(c.dx, c.dy - 170 - 5 * sin(progress * 2 * pi)),
      12,
      Paint()..color = Colors.purple,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}