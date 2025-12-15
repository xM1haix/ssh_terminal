import "package:flutter/material.dart";
import "package:ssh_terminal/functions/nav.dart";
import "package:ssh_terminal/ui/future_builder.dart";
import "package:ssh_terminal/ui/ssh_list.dart";

///Splash Screen
class SplashScreen extends StatefulWidget {
  ///Splash Screen
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
          child: Text("Welcome!"),
        ),
      ),
    );
  }

  Future<void> _auth(BuildContext context) async {
    await Future.delayed(const Duration(seconds: 1));
    if (context.mounted) {
      return nav(context, const SSHList(), replace: true);
    }
  }
}
