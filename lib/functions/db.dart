import "package:sqlite3/sqlite3.dart";

class DB {
  DB._internal() {
    _db = sqlite3.open("app.db");
    _initSchema();
  }
  static DB? _instance;
  static late final Database _db;
  static DB get _ensureInstance => _instance ??= DB._internal();

  static void close() {
    _db.close();
    _instance = null;
  }

  static void create(
    String table, {
    required Map<String, dynamic> data,
  }) {
    final columns = data.keys.join(", ");
    final v = data.values.map((e) => "?").join(", ");
    _action(
      "INSERT INTO $table ($columns) VALUES ($v)",
      data.values.toList(),
    );
  }

  static void delete(
    String table, {
    List<String> where = const [],
    List<dynamic> whereValue = const [],
  }) {
    final whereClause = where.isEmpty ? "" : 'WHERE ${where.join(' AND ')}';
    _action(
      "DELETE FROM $table $whereClause",
      where.isEmpty ? [] : whereValue,
    );
  }

  static ResultSet read(
    String table, {
    List<String> columns = const [],
    List<String> where = const [],
    List<dynamic> whereValue = const [],
  }) {
    _ensureInstance;
    final cols = columns.isEmpty ? "*" : columns.join(", ");
    final whereClause = where.isEmpty ? "" : 'WHERE ${where.join(' AND ')}';
    return _db.select(
      "SELECT $cols FROM $table $whereClause",
      where.isEmpty ? [] : whereValue,
    );
  }

  static void update(
    String table, {
    required Map<String, dynamic> data,
    List<String> where = const [],
    List<dynamic> whereValue = const [],
  }) {
    final columns = data.keys.map((k) => "$k = ?").join(", ");
    final whereClause = where.isEmpty ? "" : 'WHERE ${where.join(' AND ')}';
    _action(
      "UPDATE $table SET $columns $whereClause",
      [...data.values, ...whereValue],
    );
  }

  static void _action(String sql, List param) {
    print(sql);
    print(param);
    _db.prepare(sql)
      ..execute(param)
      ..close();
  }

  static void _initSchema() => _db.execute(
        """CREATE TABLE IF NOT EXISTS ssh_details(id INTEGER PRIMARY KEY, name TEXT, host TEXT, port INTEGER, username TEXT, password TEXT, created_at TEXT DEFAULT CURRENT_TIMESTAMP, path TEXT)""",
      );
}
