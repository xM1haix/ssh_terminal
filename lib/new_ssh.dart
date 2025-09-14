import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:ssh_terminal/colors.dart";
import "package:ssh_terminal/db.dart";
import "package:ssh_terminal/future_builder.dart";
import "package:ssh_terminal/nav.dart";
import "package:ssh_terminal/terminal.dart";

///Page which create or update a ssh entry
class NewSsh extends StatefulWidget {
  ///If the id is given it will show the UI for update
  const NewSsh({this.id, super.key});

  ///The id of the edited ssh entry
  final int? id;

  @override
  State<NewSsh> createState() => _NewSshState();
}

class _InputData {
  const _InputData(
    this.name,
    this.controller, {
    this.isPort = false,
    this.isHide = false,
    this.hiden,
  });
  final TextEditingController controller;
  final String name;
  final bool isPort;
  final Widget? hiden;
  final bool isHide;
}

class _NewSshState extends State<NewSsh> {
  final _name = TextEditingController();
  final _host = TextEditingController();
  final _port = TextEditingController();
  final _username = TextEditingController();
  final _password = TextEditingController();
  var _isHide = true;
  late Future<TerminalData>? _future;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          TextButton.icon(
            onPressed: () => _save(context),
            icon: const Icon(Icons.save_alt),
            label: const Text("Save"),
          ),
        ],
        centerTitle: true,
        title: Text(
          widget.id == null ? "Add a new SSH" : "Edit the SSH Details",
        ),
      ),
      body: Container(
        margin: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: gray12,
        ),
        padding: const EdgeInsets.all(10),
        child: widget.id == null
            ? _body()
            : CustomFutureBuilder(
                future: _future!,
                success: (x) => _body(),
              ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    if (widget.id != null) {
      _future = loadSshDetails(widget.id!).then((x) {
        setState(() {
          _name.text = x.name;
          _host.text = x.host;
          _port.text = x.port.toString();
          _username.text = x.username;
          _password.text = x.password;
        });
        return x;
      });
    }
  }

  Widget _body() => ListView(
        children: [
          _InputData("Name", _name),
          _InputData("Host", _host),
          _InputData("Port", _port, isPort: true),
          _InputData("Username", _username),
          _InputData(
            "password",
            _password,
            isHide: _isHide,
            hiden: Material(
              borderRadius: BorderRadius.circular(40),
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(40),
                onTap: () => setState(() => _isHide = !_isHide),
                child: Icon(
                  Icons.remove_red_eye,
                  color: _isHide ? Colors.grey : Colors.blue,
                ),
              ),
            ),
          ),
        ]
            .map(
              (e) => Padding(
                padding: const EdgeInsets.all(8),
                child: TextField(
                  obscureText: e.isHide,
                  keyboardType: e.isPort ? TextInputType.number : null,
                  inputFormatters: e.isPort
                      ? [FilteringTextInputFormatter.digitsOnly]
                      : null,
                  controller: e.controller,
                  decoration: InputDecoration(
                    suffixIcon: e.hiden,
                    hintText: e.name,
                    labelText: e.name,
                    border: const OutlineInputBorder(),
                  ),
                ),
              ),
            )
            .toList(),
      );
  Future<void> _save(BuildContext context) async {
    final ssh = {
      "name": _name.text,
      "host": _host.text,
      "port": int.parse(_port.text),
      "username": _username.text,
      "password": _password.text,
    };
    final x = await db();
    await (widget.id == null
        ? x.insert(
            "ssh_details",
            ssh,
          )
        : x.update(
            "ssh_details",
            ssh,
            where: "id = ?",
            whereArgs: [widget.id],
          ));
    if (!context.mounted) {
      return;
    }
    back(context, true);
  }
}
