import 'dart:async';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

Future<Database> db({FutureOr<void> Function(Database, int)? onCreate}) async =>
    await openDatabase(
      join(
        await getDatabasesPath(),
        'my_database.db',
      ),
      version: 1,
      onCreate: onCreate,
    );
