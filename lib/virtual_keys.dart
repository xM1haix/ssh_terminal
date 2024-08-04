import 'package:flutter/material.dart';
import 'package:xterm/xterm.dart';

class VirtualKeyboardView extends StatelessWidget {
  final VirtualKeyboard keyboard;
  const VirtualKeyboardView(this.keyboard, {super.key});
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
                break;
              case 1:
                keyboard.alt = !keyboard.alt;
                break;
              case 2:
                keyboard.shift = !keyboard.shift;
                break;
              case 3:
                keyboard.tab = !keyboard.tab;
                break;
            }
          },
          children: const [
            Text('Ctrl'),
            Text('Alt'),
            Text('Shift'),
            Text('Tab'),
          ],
        ),
      );
}

class VirtualKeyboard extends TerminalInputHandler with ChangeNotifier {
  final TerminalInputHandler _inputHandler;
  VirtualKeyboard(this._inputHandler);
  bool _ctrl = false;
  bool get ctrl => _ctrl;
  set ctrl(bool value) {
    if (_ctrl != value) {
      _ctrl = value;
      notifyListeners();
    }
  }

  bool _tab = false;
  bool get tab => _tab;
  set tab(bool value) {
    if (_tab != value) {
      _tab = value;
      notifyListeners();
    }
  }

  bool _shift = false;
  bool get shift => _shift;
  set shift(bool value) {
    if (_shift != value) {
      _shift = value;
      notifyListeners();
    }
  }

  bool _alt = false;
  bool get alt => _alt;
  set alt(bool value) {
    if (_alt != value) {
      _alt = value;
      notifyListeners();
    }
  }

  @override
  String? call(TerminalKeyboardEvent event) =>
      _inputHandler.call(event.copyWith(
        ctrl: event.ctrl || _ctrl,
        shift: event.shift || _shift,
        alt: event.alt || _alt,
        key: _tab ? TerminalKey.tab : event.key,
      ));
}
