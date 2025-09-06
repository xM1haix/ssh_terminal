import "package:flutter/material.dart";
import "package:xterm/xterm.dart";

class VirtualKeyboard extends TerminalInputHandler with ChangeNotifier {
  VirtualKeyboard(this._inputHandler);
  final TerminalInputHandler _inputHandler;
  var _ctrl = false;
  var _tab = false;
  var _shift = false;

  var _alt = false;
  bool get alt => _alt;
  set alt(bool value) {
    if (_alt != value) {
      _alt = value;
      notifyListeners();
    }
  }

  bool get ctrl => _ctrl;
  set ctrl(bool value) {
    if (_ctrl != value) {
      _ctrl = value;
      notifyListeners();
    }
  }

  bool get shift => _shift;

  set shift(bool value) {
    if (_shift != value) {
      _shift = value;
      notifyListeners();
    }
  }

  bool get tab => _tab;
  set tab(bool value) {
    if (_tab != value) {
      _tab = value;
      notifyListeners();
    }
  }

  @override
  String? call(TerminalKeyboardEvent event) => _inputHandler.call(
        event.copyWith(
          ctrl: event.ctrl || _ctrl,
          shift: event.shift || _shift,
          alt: event.alt || _alt,
          key: _tab ? TerminalKey.tab : event.key,
        ),
      );
}

class VirtualKeyboardView extends StatelessWidget {
  const VirtualKeyboardView(this.keyboard, {super.key});
  final VirtualKeyboard keyboard;
  @override
  Widget build(BuildContext context) => AnimatedBuilder(
        animation: keyboard,
        builder: (context, child) => ToggleButtons(
          isSelected: [
            keyboard.ctrl,
            keyboard.alt,
            keyboard.shift,
            keyboard.tab,
          ],
          onPressed: (index) {
            switch (index) {
              case 0:
                keyboard.ctrl = !keyboard.ctrl;
              case 1:
                keyboard.alt = !keyboard.alt;
              case 2:
                keyboard.shift = !keyboard.shift;
              case 3:
                keyboard.tab = !keyboard.tab;
            }
          },
          children: const [
            Text("Ctrl"),
            Text("Alt"),
            Text("Shift"),
            Text("Tab"),
          ],
        ),
      );
}
