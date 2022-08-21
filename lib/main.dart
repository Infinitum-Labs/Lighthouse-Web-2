import 'package:flutter/material.dart';
import 'package:lighthouse_web/core/core.dart';
import 'package:lighthouse_web/ui/components/components.dart';
import 'package:lighthouse_web/ui/views/views.dart';
import 'dart:html';

void main() {
  window.document.onContextMenu.listen((e) => e.preventDefault());
  window.onBeforeUnload.listen((e) {
    Vault.deinit();
  });
  // UPGRADE: https://dart.dev/guides/language/language-tour#super-parameters
  // UPGRADE: https://dart.dev/guides/language/language-tour#declaring-enhanced-enums
  /////////////////////////////////////////
  // LogDaemonClient logger = LogDaemonClient("http://127.0.0.1:8000");
  // logger.log("Hello from client");
  /////////////////////////////////////////
  const ViewConfigs viewConfigs = ViewConfigs();
  SatelliteStation satStation = SatelliteStation(
    CommunicationSatellite(),
    ObservatorySatellite(),
  );
  Vault.init(satStation);
  runApp(
    App(
      viewConfigs: viewConfigs,
      satelliteStation: satStation,
    ),
  );
}

class App extends StatelessWidget {
  final ViewConfigs viewConfigs;
  final JSON devConfigs;
  final SatelliteStation satelliteStation;

  const App({
    required this.viewConfigs,
    required this.satelliteStation,
    this.devConfigs = const {},
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/data',
      onUnknownRoute: (RouteSettings settings) {},
      routes: <String, WidgetBuilder>{
        '/': (BuildContext context) {
          return LaunchScreen(viewConfigs, satelliteStation);
        },
        '/launch': (BuildContext context) {
          return LaunchScreen(viewConfigs, satelliteStation);
        },
        '/data': (BuildContext context) =>
            DataView(viewConfigs, satelliteStation),
        '/dev': (BuildContext context) => DevScreen(),
      },
    );
  }
}
