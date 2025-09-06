import "package:ssh_terminal/db.dart";

Future<List<TerminalData>> getAllSshDetails() async =>
    (await (await db()).query("ssh_details"))
        .map(TerminalData.fromJson)
        .toList();

Future<TerminalData> loadSshDetails(int id) async {
  final x = await (await db()).query(
    "ssh_details",
    where: "id = ?",
    whereArgs: [id],
  );
  if (x.isEmpty) {
    throw Exception("No data found");
  }
  return TerminalData.fromJson(x.first);
}

class TerminalData {
  TerminalData({
    required this.id,
    required this.name,
    required this.host,
    required this.port,
    required this.username,
    required this.password,
  });
  factory TerminalData.fromJson(Map<String, dynamic> x) => switch (x) {
        {
          "id": final int id,
          "name": final String name,
          "host": final String host,
          "port": final int port,
          "username": final String username,
          "password": final String password,
        } =>
          TerminalData(
            id: id,
            name: name,
            host: host,
            port: port,
            username: username,
            password: password,
          ),
        _ => throw Exception("Invalid format: $x"),
      };
  int id;
  final String name;
  final String host;
  final int port;
  final String username;
  final String password;
}
