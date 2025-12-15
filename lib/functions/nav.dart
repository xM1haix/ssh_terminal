import "package:flutter/material.dart";

///Reusable and shorter function which will get the
///[BuildContext] as [context] and the [x] as any parameter to return
void back(BuildContext context, [x]) => Navigator.pop(context, x);

///Reusable and shorter Future which will navigate to [location]
///and it can take the [replace] in case it want to do
///[Navigator.pushReplacement] instead of [Navigator.psuh]
Future nav(
  BuildContext context,
  Widget location, {
  bool replace = false,
}) async {
  final x = PageRouteBuilder(
    transitionDuration: const Duration(seconds: 1),
    transitionsBuilder: (context, animation, secondaryAnimation, child) =>
        FadeTransition(opacity: animation, child: child),
    pageBuilder: (context, animation, secondaryAnimation) => location,
  );
  return (replace
      ? Navigator.pushReplacement(context, x)
      : Navigator.push(context, x));
}
