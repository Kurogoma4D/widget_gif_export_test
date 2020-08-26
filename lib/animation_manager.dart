import 'dart:ui' as ui;

import 'package:flutter/animation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final animationManagerProvider = Provider((ref) => AnimationManager(ref));

class AnimationManager {
  AnimationManager(this.ref);

  final ProviderReference ref;
  AnimationController painterController;
  final repaintBoundaryKey = GlobalKey();
  List<ui.Image> images = [];

  void onExport() {
    if (painterController == null) return;

    painterController.stop();
    images = [];

    painterController.addListener(captureFrame);
    painterController.forward(from: 0).whenComplete(() {
      painterController.removeListener(captureFrame);
      print(images.length);
    });
  }

  void captureFrame() async {
    final RenderRepaintBoundary boundary =
        repaintBoundaryKey.currentContext.findRenderObject();
    final image =
        await boundary.toImage(pixelRatio: ui.window.devicePixelRatio);
    images.add(image);
  }

  void dispose() {
    painterController?.dispose();
  }
}
