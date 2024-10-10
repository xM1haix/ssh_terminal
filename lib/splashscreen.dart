import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ssh_terminal/nav.dart';

import 'future_builder.dart';
import 'ssh.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late final _future = _auth(context);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomFutureBuilder(
        future: _future,
        success: (x) => const Center(
          child: Text('Welcome!'),
        ),
      ),
    );
  }

  Future<void> _auth(BuildContext context) async {
    try {
      final p = await SharedPreferences.getInstance();
      final fingerPrint = p.getBool('fingerPrint');
      if (fingerPrint != true) {
        if (!context.mounted) return;
        return nav(context, SSHList());
      }
      final a = await LocalAuthentication().authenticate(
        localizedReason: 'Check the fingerprint!',
        options: const AuthenticationOptions(
          biometricOnly: true,
          stickyAuth: true,
        ),
      );
      if (a) {
        if (!context.mounted) return;
        return nav(context, SSHList());
      }
    } catch (e) {
      print('_auth err: $e');
      rethrow;
    }
  }
}
