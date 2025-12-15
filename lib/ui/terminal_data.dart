import "package:ssh_terminal/functions/db.dart";

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
    required this.path,
  });

  ///Factory [TerminalData.fromJson] which takes
  ///a [Map] and returns the [TerminalData]
  factory TerminalData.fromJson(Map<String, dynamic> x) => switch (x) {
        {
          "id": final int id,
          "name": final String name,
          "host": final String host,
          "port": final int port,
          "path": final String path,
          "username": final String username,
          "password": final String password,
        } =>
          TerminalData(
            id: id,
            name: name,
            host: host,
            port: port,
            path: path,
            username: username,
            password: password,
          ),
        _ => throw Exception("Invalid format: $x"),
      };

  ///The [id] of [TerminalData]
  final int id;

  ///The [name] of [TerminalData]
  final String name;

  ///The [host] of [TerminalData]
  final String host;

  ///The [port] of [TerminalData]
  final int port;

  ///The [path] of the [TerminalData]
  final String path;

  ///The [username] of [TerminalData]
  final String username;

  ///The [password] of [TerminalData]
  final String password;

  Map<String, dynamic> get _toMap => {
        "id": id,
        "name": name,
        "host": host,
        "port": port,
        "path": path,
        "username": username,
        "password": password,
      };

  Map<String, dynamic> get _toMapWithoutId => {
        "name": name,
        "host": host,
        "port": port,
        "path": path,
        "username": username,
        "password": password,
      };

  void insert() => DB.create("ssh_details", data: _toMapWithoutId);

  void insertOrUpdate({required bool shouldInsert}) =>
      shouldInsert ? insert() : update();
  @override
  String toString() =>
      """TerminaData(id:$id, name: $name, host: $host, port: $port, path: $path, username: $username, password: $password,)""";
  void update() => DB.update(
        "ssh_details",
        data: _toMap,
        where: ["id = ?"],
        whereValue: [id],
      );

  ///Method which returns the [List] of [TerminalData] from [db]
  static List<TerminalData> getAllSSHDetails() =>
      DB.read("ssh_details").map(TerminalData.fromJson).toList();

  ///Method which returns the [TerminalData] for a specifc [id] from [db]
  static TerminalData loadSshDetails(int id) {
    final x = DB.read("ssh_details", where: ["id = ?"], whereValue: [id]);
    if (x.isEmpty) {
      throw Exception("No data found");
    }
    return TerminalData.fromJson(x.first);
  }
}
