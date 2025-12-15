import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:ssh_terminal/classes/input_dialog.dart";
import "package:ssh_terminal/colors.dart";
import "package:ssh_terminal/functions/nav.dart";
import "package:ssh_terminal/ui/terminal_data.dart";

///Page which create or update a ssh entry
class NewSsh extends StatefulWidget {
  ///If the id is given it will show the UI for update
  const NewSsh({this.id, super.key});

  ///The id of the edited ssh entry
  final int? id;
  @override
  State<NewSsh> createState() => _NewSshState();
}

class _NewSshState extends State<NewSsh> {
  final _name = TextEditingController();
  final _host = TextEditingController();
  final _port = TextEditingController();
  final _username = TextEditingController();
  final _password = TextEditingController();
  final _path = TextEditingController();
  var _isHide = true;
  late final inputs = [
    InputData("Name", _name),
    InputData("Host", _host),
    InputData("Port", _port, isPort: true),
    InputData("Path", _path),
    InputData("Username", _username),
    InputData(
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
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          TextButton.icon(
            onPressed: _save,
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
        child: _body(),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    if (widget.id != null) {
      final x = TerminalData.loadSshDetails(widget.id!);
      setState(() {
        _name.text = x.name;
        _host.text = x.host;
        _port.text = x.port.toString();
        _username.text = x.username;
        _path.text = x.path;
        _password.text = x.password;
      });
    }
  }

  Widget _body() => ListView(
        children: inputs
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
  void _save() {
    TerminalData.fromJson({
      "id": widget.id ?? -1,
      "name": _name.text.trim(),
      "host": _host.text.trim(),
      "port": int.parse(_port.text.trim()),
      "path": _path.text.trim(),
      "username": _username.text.trim(),
      "password": _password.text,
    }).insertOrUpdate(shouldInsert: widget.id == null);
    back(context, true);
  }
}
