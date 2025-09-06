import "package:flutter/material.dart";
import "package:ssh_terminal/colors.dart";
import "package:ssh_terminal/db.dart";
import "package:ssh_terminal/future_builder.dart";
import "package:ssh_terminal/nav.dart";
import "package:ssh_terminal/new_ssh.dart";
import "package:ssh_terminal/settings.dart";
import "package:ssh_terminal/terminal.dart";
import "package:ssh_terminal/terminal_view.dart";

class SSHList extends StatefulWidget {
  const SSHList({super.key});

  @override
  State<SSHList> createState() => _SSHListState();
}

class _SSHListState extends State<SSHList> {
  late Future<List<TerminalData>> _future;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("SSH List"),
        actions: [
          IconButton(
            onPressed: () => nav(context, const Settings()),
            icon: const Icon(Icons.settings),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: "Add",
        splashColor: const Color(0xFF00FF00),
        backgroundColor: Colors.black,
        onPressed: _onAdd,
        child: const Icon(
          Icons.add,
          color: Color(0xFF00FF00),
        ),
      ),
      body: Container(
        margin: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: gray12,
        ),
        padding: const EdgeInsets.all(10),
        child: CustomFutureBuilder(
          future: _future,
          success: (x) => x.isEmpty
              ? const Center(child: Text("Nothing in here"))
              : ListView.builder(
                  itemCount: x.length,
                  itemBuilder: (_, i) => Padding(
                    padding: const EdgeInsets.all(10),
                    child: Material(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.black,
                      child: InkWell(
                        splashColor: Colors.green,
                        borderRadius: BorderRadius.circular(10),
                        onTap: () => nav(context, TerminalSSH(x[i])),
                        child: Container(
                          height: 72,
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.terminal_outlined),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Text(
                                  x[i].name,
                                  style: const TextStyle(
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                              Row(
                                children: [
                                  IconButton(
                                    onPressed: () =>
                                        nav(context, NewSsh(id: x[i].id)),
                                    icon: const Icon(
                                      Icons.edit,
                                      color: Colors.blue,
                                    ),
                                  ),
                                  IconButton(
                                    onPressed: () => _delete(x[i]),
                                    icon: const Icon(
                                      Icons.delete_outline,
                                      color: Colors.red,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _delete(e) async {
    final confirm = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(
          "Are you sure you want to delete?",
        ),
        actions: [
          TextButton(
            child: const Text(
              "Cancel",
              style: TextStyle(
                color: Colors.blue,
              ),
            ),
            onPressed: () => back(context, false),
          ),
          TextButton(
            onPressed: () => back(context, true),
            child: const Text(
              "Delete",
              style: TextStyle(
                color: Colors.red,
              ),
            ),
          ),
        ],
      ),
    );
    if (confirm != true) {
      return;
    }
    final x = await db();
    await x.delete(
      "ssh_details",
      where: "id = ?",
      whereArgs: [e.id],
    );
    _init();
  }

  void _init() => setState(() {
        _future = getAllSshDetails();
      });
  Future<void> _onAdd() async {
    final x = await nav(context, const NewSsh());
    if (x == true) {
      _init();
    }
  }
}
