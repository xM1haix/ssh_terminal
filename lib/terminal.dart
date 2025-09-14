import "package:ssh_terminal/db.dart";

///[Future] which returns the [List] of [TerminalData] from [db]
Future<List<TerminalData>> getAllSshDetails() async =>
    (await (await db()).query("ssh_details"))
        .map(TerminalData.fromJson)
        .toList();

///[Future] which returns the [TerminalData] for a specifc [id] from [db]
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

///The object representing all data about the Terminal
class TerminalData {
  ///
  TerminalData({
    required this.id,
    required this.name,
    required this.host,
    required this.port,
    required this.username,
    required this.password,
  });

  ///Factory [TerminalData.fromJson] which takes
  ///a [Map] and returns the [TerminalData]
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

  ///The [id] of [TerminalData]
  int id;

  ///The [name] of [TerminalData]
  final String name;

  ///The [host] of [TerminalData]
  final String host;

  ///The [port] of [TerminalData]
  final int port;

  ///The [username] of [TerminalData]
  final String username;

  ///The [password] of [TerminalData]
  final String password;
}
