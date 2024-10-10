import 'dart:io';

import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import 'db.dart';
import 'splashscreen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final p = await SharedPreferences.getInstance();
  final a = LocalAuthentication();
  await p.setBool(
      'fingerPrint', await a.canCheckBiometrics && await a.isDeviceSupported());
  if (Platform.isWindows || Platform.isLinux) sqfliteFfiInit();
  await db(
    onCreate: (db, version) => db.execute(
      'CREATE TABLE ssh_details(id INTEGER PRIMARY KEY, name TEXT, host TEXT, port INTEGER, username TEXT, password TEXT, created_at TEXT DEFAULT CURRENT_TIMESTAMP)',
    ),
  );
  runApp(
    MaterialApp(
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: Colors.black,
      ),
      debugShowCheckedModeBanner: false,
      home: const SplashScreen(),
    ),
  );
}
