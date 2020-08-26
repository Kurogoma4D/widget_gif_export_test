import 'dart:ui' as ui;

import 'package:flutter/animation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final animationManagerProvider = Provider((ref) => AnimationManager(ref));

class AnimationManager {
  AnimationManager(this.ref) {
    ref.onDispose(dispose);
  }

  final ProviderReference ref;
  AnimationController painterController;
  final repaintBoundaryKey = GlobalKey();
  List<ui.Image> images = [];

  void dispose() {
    painterController?.dispose();
  }
}
