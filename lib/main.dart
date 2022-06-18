import 'package:flutter/material.dart';
import 'package:lighthouse_web/ui/components/components.dart';
import 'package:lighthouse_web/ui/views/views.dart';
import 'dart:html';

void main() {
  window.document.onContextMenu.listen((e) => e.preventDefault());
  window.onBeforeUnload.listen((e) {
    //corelib.DB.deinit();
  });
  runApp(const App());
}

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dashboard(
      atmosphere: Atmosphere(
        lithosphere: Center(
          child: Container(
            width: 100,
            height: 100,
            color: Colors.green,
          ),
        ),
      ),
    );
  }
}
