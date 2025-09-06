import "dart:async";
import "dart:io";

import "package:path/path.dart";
import "package:sqflite_common_ffi/sqflite_ffi.dart";

Future<Database> db({FutureOr<void> Function(Database, int)? onCreate}) async {
  if (Platform.isWindows || Platform.isLinux) {
    return databaseFactoryFfi.openDatabase(
      inMemoryDatabasePath,
      options: OpenDatabaseOptions(
        version: 1,
        onCreate: onCreate,
      ),
    );
  }
  return openDatabase(
    join(
      await getDatabasesPath(),
      "my_database.db",
    ),
    version: 1,
    onCreate: onCreate,
  );
}
