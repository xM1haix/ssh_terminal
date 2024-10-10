import 'dart:async';
import 'dart:convert';

import 'package:dartssh2/dartssh2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:xterm/xterm.dart';

import 'colors.dart';
import 'nav.dart';
import 'terminal.dart';
import 'virtual_keys.dart';

void fakeKey() {
  KeyUpEvent;
}

void simulateKeyPress(LogicalKeyboardKey key) {
  // Create a key event
  const keyEvent = KeyUpEvent(
    physicalKey: PhysicalKeyboardKey(0x0007004f),
    logicalKey: LogicalKeyboardKey(0x100000303),
    timeStamp: Duration.zero,
  );

  // Dispatch the key event to the RawKeyboard
  HardwareKeyboard.instance.handleKeyEvent(keyEvent);
}

class TerminalSSH extends StatefulWidget {
  final TerminalData x;

  const TerminalSSH(
    this.x, {
    super.key,
  });

  @override
  State<TerminalSSH> createState() => _TerminalSSHState();
}

class _TerminalSSHState extends State<TerminalSSH> {
  final _focusNode = FocusNode();
  late final _terminal = Terminal(inputHandler: _keyboard);
  final _keyboard = VirtualKeyboard(
    defaultInputHandler,
  );
  late SSHClient client;
  final _terminalController = TerminalController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: IconButton(
          onPressed: () => _close(context),
          icon: const Icon(
            Icons.close,
            color: Colors.red,
          ),
        ),
        backgroundColor: gray12,
        title: Text(widget.x.name),
        actions: [
          const IconButton(
            onPressed: fakeKey,
            icon: Icon(Icons.arrow_right),
          ),
          VirtualKeyboardView(_keyboard),
        ],
      ),
      body: KeyboardListener(
        focusNode: _focusNode,
        autofocus: true,
        onKeyEvent: (event) {
          print(event);
        },
        child: TerminalView(
          _terminal,
          controller: _terminalController,
          backgroundOpacity: 0,
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _connectToServer();
  }

  void _close(BuildContext context) {
    client.close();
    back(context);
  }

  Future<void> _connectToServer() async {
    _terminal.write('Connecting...\r\n');
    try {
      client = SSHClient(
        await SSHSocket.connect(widget.x.host, widget.x.port),
        username: widget.x.username,
        onPasswordRequest: () => widget.x.password,
      );

      final session = await client.shell(
        pty: SSHPtyConfig(
          width: _terminal.viewWidth,
          height: _terminal.viewHeight,
        ),
      );
      _terminal.buffer.clear();
      _terminal.buffer.setCursor(0, 0);
      _terminal.onResize = (width, height, pixelWidth, pixelHeight) =>
          session.resizeTerminal(width, height, pixelWidth, pixelHeight);
      _terminal.onOutput = (data) => session.write(utf8.encode(data));
      session.stdout
          .cast<List<int>>()
          .transform(const Utf8Decoder())
          .listen(_terminal.write);
      session.stderr
          .cast<List<int>>()
          .transform(const Utf8Decoder())
          .listen(_terminal.write);
    } catch (e) {
      _terminal.write('Error connecting to server: $e\r\n');
    }
  }
}

// void simulateKeyRelease(LogicalKeyboardKey key) {
//   // Create a key event for release
//   final keyEvent = RawKeyUpEvent(
//     data: RawKeyEventDataAndroid(
//       keyCode: key.keyId,
//       scanCode: 0,
//     ),
//     character: key.debugName,
//     logicalKey: key,
//     isKeyPressed: false,
//     physicalKey: PhysicalKeyboardKey(key.keyId),
//   );

//   // Dispatch the key event to the RawKeyboard
//   RawKeyboard.instance.handleRawKeyEvent(keyEvent);
// }
