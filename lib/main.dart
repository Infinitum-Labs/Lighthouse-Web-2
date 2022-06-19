import 'package:flutter/material.dart';
import 'package:lighthouse_web/core/data_handling/data_handling.dart';
import 'package:lighthouse_web/ui/views/views.dart';
import 'dart:html';

void main() {
  window.document.onContextMenu.listen((e) => e.preventDefault());
  window.onBeforeUnload.listen((e) {});
  //bool initialisedIdbFactory = Store.init();

  runApp(const App());
}

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/launch',
      onUnknownRoute: (RouteSettings settings) {},
      routes: <String, WidgetBuilder>{
        '/': (BuildContext context) {
          return const LaunchScreen();
        },
        '/launch': (BuildContext context) {
          return const LaunchScreen();
        }
      },
    );
  }
}
