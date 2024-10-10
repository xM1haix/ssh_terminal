import 'db.dart';

Future<List<TerminalData>> getAllSshDetails() async =>
    (await (await db()).query('ssh_details'))
        .map((e) => TerminalData.fromJson(e))
        .toList();

Future<TerminalData> loadSshDetails(int id) async {
  final x = await (await db()).query(
    'ssh_details',
    where: 'id = ?',
    whereArgs: [id],
  );
  if (x.isEmpty) throw "No data found";
  return TerminalData.fromJson(x.first);
}

class TerminalData {
  int id;
  final String name;
  final String host;
  final int port;
  final String username;
  final String password;
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
          "id": int id,
          "name": String name,
          "host": String host,
          "port": int port,
          "username": String username,
          "password": String password,
        } =>
          TerminalData(
            id: id,
            name: name,
            host: host,
            port: port,
            username: username,
            password: password,
          ),
        _ => throw "Invalid format: $x",
      };
}
