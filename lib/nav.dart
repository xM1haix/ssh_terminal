import 'package:flutter/material.dart';

Future nav(BuildContext context, Widget location,
    [bool replace = false]) async {
  final x = PageRouteBuilder(
    transitionDuration: const Duration(seconds: 1),
    transitionsBuilder: (context, animation, secondaryAnimation, child) =>
        FadeTransition(opacity: animation, child: child),
    pageBuilder: (context, animation, secondaryAnimation) => location,
  );
  return await (replace
      ? Navigator.pushReplacement(context, x)
      : Navigator.push(context, x));
}

void back(BuildContext context, [dynamic x]) => Navigator.pop(context, x);
