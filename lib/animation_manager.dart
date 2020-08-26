import 'dart:ui' as ui;

import 'package:flutter/animation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image/image.dart' as image;

final imageStore = StateProvider<List<ui.Image>>((_) => []);
final encodedImageProvider = StateProvider<List<int>>((_) => []);
final animationManagerProvider = Provider((ref) => AnimationManager(ref));

class AnimationManager {
  AnimationManager(this.ref);

  final ProviderReference ref;
  AnimationController painterController;
  final repaintBoundaryKey = GlobalKey();

  void onExport() {
    if (painterController == null) return;

    painterController.stop();
    ref.read(imageStore).state = [];

    painterController.addListener(captureFrame);
    painterController.forward(from: 0).whenComplete(() {
      painterController.removeListener(captureFrame);
      encodeGif();
    });
  }

  void captureFrame() async {
    final RenderRepaintBoundary boundary =
        repaintBoundaryKey.currentContext.findRenderObject();
    final image =
        await boundary.toImage(pixelRatio: ui.window.devicePixelRatio);
    final prev = ref.read(imageStore).state;
    ref.read(imageStore).state = [...prev, image];
  }

  void encodeGif() async {
    final encoder = image.GifEncoder();

    final images = ref.read(imageStore).state;
    for (final original in images) {
      final imageBytes = await original.toByteData();
      final translatedImage = image.Image.fromBytes(
        original.width,
        original.height,
        imageBytes.buffer.asUint32List().toList(),
      );

      encoder.addFrame(translatedImage);
    }

    ref.read(encodedImageProvider).state = encoder.finish();
  }

  void dispose() {
    painterController?.dispose();
  }
}
