import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'future_builder.dart';
import 'ssh.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late final _future = _auth(context);
  void _nav(BuildContext context) {
    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        transitionDuration: const Duration(seconds: 1),
        transitionsBuilder: (context, animation, secondaryAnimation, child) =>
            FadeTransition(opacity: animation, child: child),
        pageBuilder: (context, animation, secondaryAnimation) =>
            const SSHList(),
      ),
    );
  }

  Future<void> _auth(BuildContext context) async {
    try {
      final p = await SharedPreferences.getInstance();
      final fingerPrint = p.getBool('fingerPrint');
      if (fingerPrint != true) {
        if (!context.mounted) return;
        return _nav(context);
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
        return _nav(context);
      }
    } catch (e) {
      print('_auth err: $e');
      rethrow;
    }
  }

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
}
