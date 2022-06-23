import 'package:flutter/material.dart';
import 'package:lighthouse_web/core/core.dart';
import 'package:lighthouse_web/ui/components/components.dart';
import 'package:lighthouse_web/ui/views/views.dart';
import 'package:lighthouse_web/toolbox/toolbox.dart';
import 'dart:html';

void main() {
  window.document.onContextMenu.listen((e) => e.preventDefault());
  window.onBeforeUnload.listen((e) {});
  /////////////////////////////////////////
  bool initialisedIdbFactory = Store.init();
  LogDaemonClient logger = LogDaemonClient("http://127.0.0.1:8000");
  logger.log("Hello from client");
  const ViewConfigs viewConfigs = ViewConfigs();
  /////////////////////////////////////////
  runApp(
    const App(
      viewConfigs: viewConfigs,
    ),
  );
}

class App extends StatelessWidget {
  final ViewConfigs viewConfigs;
  const App({required this.viewConfigs, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/launch',
      onUnknownRoute: (RouteSettings settings) {},
      routes: <String, WidgetBuilder>{
        '/': (BuildContext context) {
          return LaunchScreen(viewConfigs);
        },
        '/launch': (BuildContext context) {
          return LaunchScreen(viewConfigs);
        }
      },
    );
  }
}
