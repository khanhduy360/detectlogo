import 'dart:math';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

/// CameraApp is the Main Application.
class CameraApp extends StatefulWidget {
  /// Default Constructor
  List<CameraDescription> cameras;
  CameraApp({super.key, required this.cameras});

  @override
  State<CameraApp> createState() => _CameraAppState();
}

class _CameraAppState extends State<CameraApp> with SingleTickerProviderStateMixin {
  late CameraController controller;
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    controller = CameraController(widget.cameras[0], ResolutionPreset.max);
    controller.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {});
    }).catchError((Object e) {
      if (e is CameraException) {
        switch (e.code) {
          case 'CameraAccessDenied':
          // Handle access errors here.
            break;
          default:
          // Handle other errors here.
            break;
        }
      }
    });

    _animationController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 2),
    );
    _animation = Tween<double>(begin: 150.0, end: 200.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );
    _animationController.repeat(reverse: true);
  }

  @override
  void dispose() {
    controller.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!controller.value.isInitialized) {
      return Container();
    }
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          CameraPreview(controller),
          Positioned(
            bottom: 16,
            left: 16,
            right: 16,
            child: FloatingActionButton(
              onPressed: () {
                // Add your capture logic here
              },
              backgroundColor: Colors.transparent, // Set button background color to transparent
              elevation: 0, // Remove button elevation
              child: Icon(
                Icons.camera,
                color: Colors.white,
                size: 50,// Set icon color
              ),
            ),
          ),
          Center(
            child: AnimatedBuilder(
              animation: _animation,
              builder: (context, child) {
                return Container(
                  width: _animation.value,
                  height: _animation.value,
                  child: CustomPaint(
                    painter: SquarePainter(),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class SquarePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = Colors.yellow
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4;

    final double radius = 16; // Bán kính của góc bo

    final Offset topLeft = Offset(0, 0);
    final Offset topRight = Offset(size.width, 0);
    final Offset bottomLeft = Offset(0, size.height);
    final Offset bottomRight = Offset(size.width, size.height);

    canvas.drawArc(Rect.fromCircle(center: topLeft, radius: radius), pi, pi / 2, false, paint);
    canvas.drawArc(Rect.fromCircle(center: topRight, radius: radius), -pi / 2, pi / 2, false, paint);
    canvas.drawArc(Rect.fromCircle(center: bottomLeft, radius: radius), pi / 2, pi / 2, false, paint);
    canvas.drawArc(Rect.fromCircle(center: bottomRight, radius: radius), 0, pi / 2, false, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
