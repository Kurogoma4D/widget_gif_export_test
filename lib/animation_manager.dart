import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/animation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image/image.dart' as image;
import 'package:path_provider/path_provider.dart';

final imageStore = StateProvider<List<ui.Image>>((_) => []);
final gifImageProvider = StateProvider<List<int>>((_) => []);
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
    ref.read(gifImageProvider).state = [];

    final encoder = image.GifEncoder();
    final animation = image.Animation();

    final images = ref.read(imageStore).state;
    for (final original in images) {
      final imageBytes = await original.toByteData();

      final translatedImage = image.Image.fromBytes(
        original.width,
        original.height,
        imageBytes.buffer.asUint8List().toList(),
      );

      animation.addFrame(translatedImage);
    }

    final encoded = encoder.encodeAnimation(animation);
    saveToLocal(encoded);
    ref.read(gifImageProvider).state = encoded;
  }

  void saveToLocal(List<int> bytes) async {
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/exported.gif');
    await file.writeAsBytes(bytes);
    print('completed ${file.path}');
  }

  void dispose() {
    painterController?.dispose();
  }
}
