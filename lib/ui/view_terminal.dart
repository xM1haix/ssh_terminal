import "dart:async";
import "dart:convert";

import "package:dartssh2/dartssh2.dart";
import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:ssh_terminal/classes/virtual_key.dart";
import "package:ssh_terminal/colors.dart";
import "package:ssh_terminal/functions/nav.dart";
import "package:ssh_terminal/ui/terminal_data.dart";
import "package:xterm/xterm.dart";

class ViewTerminal extends StatefulWidget {
  const ViewTerminal(
    this.x, {
    super.key,
  });
  final TerminalData x;
  @override
  State<ViewTerminal> createState() => _ViewTerminalState();
}

class _ViewTerminalState extends State<ViewTerminal> {
  late final _terminal = Terminal();
  late final SSHSession _session;
  late SSHClient client;
  final _terminalController = TerminalController();
  late var _keys = <VirtualKey>[];
  final _focusNode = FocusNode();
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
      ),
      body: KeyboardListener(
        focusNode: _focusNode,
        autofocus: true,
        onKeyEvent: print,
        child: Column(
          children: [
            Expanded(
              child: TerminalView(
                _terminal,
                controller: _terminalController,
                backgroundOpacity: 0,
              ),
            ),
            Wrap(
              children: _keys.map((e) => e.toWidget()).toList(),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    unawaited(_connectToServer());
  }

  void _close(BuildContext context) {
    client.close();
    back(context);
  }

  Future<void> _connectToServer() async {
    _terminal.write("Connecting...\r\n");
    try {
      client = SSHClient(
        await SSHSocket.connect(widget.x.host, widget.x.port),
        username: widget.x.username,
        onPasswordRequest: () => widget.x.password,
      );

      _session = await client.shell(
        pty: SSHPtyConfig(
          width: _terminal.viewWidth,
          height: _terminal.viewHeight,
        ),
      );
      setState(() {
        _keys = [
          VArrow("↑", "\x1b[A", _session),
          VArrow("↓", "\x1b[B", _session),
          VArrow("←", "\x1b[D", _session),
          VArrow("→", "\x1b[C", _session),
          Vkey(
            "CTRL",
            LogicalKeyboardKey.controlLeft,
            PhysicalKeyboardKey.controlLeft,
            setState,
          ),
          Vkey(
            "SHIFT",
            LogicalKeyboardKey.shiftLeft,
            PhysicalKeyboardKey.shiftLeft,
            setState,
          ),
          Vkey(
            "ALT",
            LogicalKeyboardKey.altLeft,
            PhysicalKeyboardKey.altLeft,
            setState,
          ),
          Vkey(
            "DEL",
            LogicalKeyboardKey.delete,
            PhysicalKeyboardKey.delete,
            setState,
          ),
          Vkey(
            "ESC",
            LogicalKeyboardKey.escape,
            PhysicalKeyboardKey.escape,
            setState,
          ),
        ];
      });
      _terminal.buffer.clear();
      _terminal.buffer.setCursor(0, 0);
      _terminal.onResize = _session.resizeTerminal;
      _terminal.onOutput = (data) => _session.write(utf8.encode(data));
      _session.stdout
          .cast<List<int>>()
          .transform(const Utf8Decoder())
          .listen(_terminal.write);
      _session.stderr
          .cast<List<int>>()
          .transform(const Utf8Decoder())
          .listen(_terminal.write);
    } catch (e) {
      _terminal.write("Error connecting to server: $e\r\n");
    }
  }
}
