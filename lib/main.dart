import 'package:flutter/material.dart';
import 'package:lighthouse_web/ui/ui.dart';
import 'dart:html';

void main() {
  window.document.onContextMenu.listen((e) => e.preventDefault());
  window.onBeforeUnload.listen((e) {
    //corelib.DB.deinit();
  });
  runApp(App());
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      //initialRoute: "splash", //initialRoute
      routes: {
        '/': (context) => DevScreen(),
      },
      theme: ThemeData(
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        hoverColor: Colors.transparent,
        fontFamily: "RedHatDisplay",
      ),
      onUnknownRoute: (settings) {
        return MaterialPageRoute(builder: (_) => DevScreen() //Error404Page(),
            );
      },
      debugShowCheckedModeBanner: false,
    );
  }
}
