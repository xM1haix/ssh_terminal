import "dart:convert";

import "package:dartssh2/dartssh2.dart";
import "package:flutter/material.dart";
import "package:flutter/services.dart";

class VArrow extends VirtualKey {
  VArrow(
    super.text,
    this.value,
    this._session,
  );
  final String value;
  final SSHSession _session;

  @override
  void onPressed() {
    _session.write(utf8.encode(value));
  }

  @override
  Widget toWidget() {
    return IconButton(onPressed: onPressed, icon: Text(text));
  }
}

abstract class VirtualKey {
  VirtualKey(this.text);
  final String text;
  void onPressed();
  Widget toWidget();
}

class Vkey extends VirtualKey {
  Vkey(
    super.text,
    this.logicalKeyboardKey,
    this.physicalKeyboardKey,
    this.setState,
  );
  final void Function(Function()) setState;
  final LogicalKeyboardKey logicalKeyboardKey;
  final PhysicalKeyboardKey physicalKeyboardKey;
  var _isPressed = false;

  @override
  void onPressed() {
    HardwareKeyboard.instance.handleKeyEvent(
      _isPressed
          ? KeyUpEvent(
              logicalKey: logicalKeyboardKey,
              physicalKey: physicalKeyboardKey,
              timeStamp: Duration.zero,
            )
          : KeyDownEvent(
              logicalKey: logicalKeyboardKey,
              physicalKey: physicalKeyboardKey,
              timeStamp: Duration.zero,
            ),
    );
    setState(() {
      _isPressed = !_isPressed;
    });
  }

  @override
  Widget toWidget() {
    return ElevatedButton(
      onPressed: onPressed,
      child: Text(
        text,
        style: TextStyle(
          color: _isPressed ? Colors.green : Colors.red,
        ),
      ),
    );
  }
}
