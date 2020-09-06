import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:widgetgifexporttest/animation_manager.dart';

class SampleAnimation extends StatefulWidget {
  const SampleAnimation({Key key}) : super(key: key);

  @override
  _SampleAnimationState createState() => _SampleAnimationState();
}

class _SampleAnimationState extends State<SampleAnimation>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    context.read(animationManagerProvider).painterController =
        AnimationController(duration: const Duration(seconds: 3), vsync: this)
          ..addListener(() => setState(() {}))
          ..repeat();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) => RepaintBoundary(
        key: context.read(animationManagerProvider).repaintBoundaryKey,
        child: CustomPaint(
          size: constraints.biggest,
          willChange: true,
          painter: SamplePainter(context: context),
        ),
      ),
    );
  }

  @override
  void dispose() {
    context.read(animationManagerProvider).dispose();
    super.dispose();
  }
}

class SamplePainter extends CustomPainter {
  SamplePainter({this.context});

  final BuildContext context;

  @override
  void paint(Canvas canvas, Size size) {
    final progress =
        context.read(animationManagerProvider).painterController?.value ?? 0.0;
    final paint = Paint()
      ..style = PaintingStyle.fill
      ..color = Color(0xff242424);
    final origin = Offset(0, 0);
    final triangle = Path()
      ..moveTo(origin.dx, origin.dy)
      ..relativeLineTo(20, 40)
      ..relativeLineTo(-40, 0)
      ..close();

    final background = Paint()..color = Colors.white;
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), background);

    canvas.save();
    canvas.translate(size.width / 2, size.height / 2);
    canvas.rotate(2 * math.pi * progress);
    canvas.drawPath(triangle, paint);
    canvas.restore();
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
