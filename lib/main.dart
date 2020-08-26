import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:widgetgifexporttest/action_button.dart';
import 'package:widgetgifexporttest/animation_manager.dart';
import 'package:widgetgifexporttest/sample_animation.dart';

void main() {
  runApp(ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('GIF export test')),
      body: Column(
        children: <Widget>[
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.5,
            child: const SampleAnimation(),
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                const SizedBox(height: 16),
                ActionButton(
                  label: 'EXPORT',
                  onPressed: () =>
                      context.read(animationManagerProvider).onExport(),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

// TODO: Riverpodでマネージャークラス作る エクスポートボタンのonPressed
// TODO: マネージャークラスにRepaintBoundaryで使うキーとImage保存用のリストを保持する
// TODO: ボタンを押すとAnimaionControllerで再生→キャプチャをする
// TODO: 最終的に何らかの手段でprintする Imageとして出せる？
