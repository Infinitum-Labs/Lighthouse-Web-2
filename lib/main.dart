import 'package:flutter/material.dart';
import 'package:lighthouse_web/core/core.dart';
import 'package:lighthouse_web/ui/components/components.dart';
import 'package:lighthouse_web/ui/views/views.dart';
import 'package:lighthouse_web/toolbox/toolbox.dart';
import 'dart:html';

void main() {
  window.document.onContextMenu.listen((e) => e.preventDefault());
  window.onBeforeUnload.listen((e) {
    Vault.deinit();
  });
  /////////////////////////////////////////
  // LogDaemonClient logger = LogDaemonClient("http://127.0.0.1:8000");
  // logger.log("Hello from client");
  const ViewConfigs viewConfigs = ViewConfigs();
  /////////////////////////////////////////
  Vault.init();
  // Debug
  final Workbench wb = Vault.create(
    Workbench(
      name: "My Amazing Workspace",
      projects: ["proj1"],
    ),
  );
  runApp(
    App(
      viewConfigs: viewConfigs,
      devConfigs: {'objectId': wb.objectId},
    ),
  );
}

class App extends StatelessWidget {
  final ViewConfigs viewConfigs;
  final JSON devConfigs;
  const App({
    required this.viewConfigs,
    this.devConfigs = const {},
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/dev',
      onUnknownRoute: (RouteSettings settings) {},
      routes: <String, WidgetBuilder>{
        '/': (BuildContext context) {
          return LaunchScreen(viewConfigs);
        },
        '/launch': (BuildContext context) {
          return LaunchScreen(viewConfigs);
        },
        '/dev': (BuildContext context) => DevScreen(devConfigs['objectId']),
      },
    );
  }
}
