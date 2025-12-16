import "package:flutter/material.dart";
import "package:ssh_terminal/colors.dart";
import "package:ssh_terminal/functions/db.dart";
import "package:ssh_terminal/functions/local_auth.dart";
import "package:ssh_terminal/functions/nav.dart";
import "package:ssh_terminal/ui/new_ssh.dart";
import "package:ssh_terminal/ui/settings.dart";
import "package:ssh_terminal/ui/terminal_data.dart";
import "package:ssh_terminal/ui/view_terminal.dart";

/// Page which shows all the SSH as a [List] and give options to
/// edit, delete or create a new SSH also there is the [Icons.settings]
/// button which navigates to [Settings] page
class SSHList extends StatefulWidget {
  ///
  const SSHList({super.key});

  @override
  State<SSHList> createState() => _SSHListState();
}

class _SSHListState extends State<SSHList> {
  // late Future<List<TerminalData>> _future;
  late var x = <TerminalData>[];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("SSH List"),
        actions: [
          IconButton(
            onPressed: () async {
              await LocalAuth.init();
            },
            icon: const Icon(Icons.refresh),
          ),
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
        child: x.isEmpty
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
                      onTap: () => nav(context, ViewTerminal(x[i])),
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
                                  onPressed: () => _edit(x[i].id),
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
    );
  }

  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _delete(TerminalData e) async {
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
    DB.delete(
      "ssh_details",
      where: ["id = ?"],
      whereValue: [e.id],
    );
    _init();
  }

  Future<void> _edit(int id) async {
    await nav(context, NewSsh(id: id));
    _init();
  }

  void _init() {
    setState(() {
      x = TerminalData.getAllSSHDetails();
    });
  }

  Future<void> _onAdd() async {
    await nav(context, const NewSsh());
    _init();
  }
}
