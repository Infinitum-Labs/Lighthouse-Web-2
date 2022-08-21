library core.engines.keybine;

import 'package:flutter/services.dart';

class Keybine {
  final List<KeybineEvent> _keystrokes = [];
  int keysDown = 0;

  void down(KeybineEvent keybineEvent) {
    _keystrokes.add(keybineEvent);
    keysDown++;
  }

  void register() {
    keysDown = 0;
  }
}

class KeybineEvent {
  final KeyEvent keyEvent;

  const KeybineEvent(this.keyEvent);
}

List<KeybineEvent> emitEvents() {
  return const [
    KeybineEvent(
      KeyDownEvent(
        logicalKey: LogicalKeyboardKey.control,
        physicalKey: PhysicalKeyboardKey.controlLeft,
        timeStamp: Duration(seconds: 1),
      ),
    ),
    KeybineEvent(
      KeyDownEvent(
        logicalKey: LogicalKeyboardKey.shift,
        physicalKey: PhysicalKeyboardKey.shiftLeft,
        timeStamp: Duration(seconds: 1),
      ),
    ),
    KeybineEvent(
      KeyDownEvent(
        logicalKey: LogicalKeyboardKey.keyK,
        physicalKey: PhysicalKeyboardKey.keyK,
        timeStamp: Duration(seconds: 1),
      ),
    ),
    KeybineEvent(
      KeyUpEvent(
        logicalKey: LogicalKeyboardKey.control,
        physicalKey: PhysicalKeyboardKey.controlLeft,
        timeStamp: Duration(seconds: 1),
      ),
    ),
    KeybineEvent(
      KeyUpEvent(
        logicalKey: LogicalKeyboardKey.shift,
        physicalKey: PhysicalKeyboardKey.shiftLeft,
        timeStamp: Duration(seconds: 1),
      ),
    ),
    KeybineEvent(
      KeyUpEvent(
        logicalKey: LogicalKeyboardKey.keyK,
        physicalKey: PhysicalKeyboardKey.keyK,
        timeStamp: Duration(seconds: 1),
      ),
    ),
  ];
}

void main(List<String> args) {
  Keybine keybine = Keybine();
  /* keybine
    ..down()
    ..register(); */

  print(keybine._keystrokes);
}

/**
 * HANDOFF
 * UI component instantiates a KeybineEngine with a KeybineEmitter instance
 * The KeybineEmitter emits KeyEvent events that the KeybineEngine listens to
 * The KeybineEngine converts the KeyEvents into KeybineEvents and detects the end
 * of key combinations
 * The KeybinEngine dispatches the KeybineEvents to the respective endpoint
 */