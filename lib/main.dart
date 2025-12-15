import "package:flutter/material.dart";
import "package:ssh_terminal/ui/splash_screen.dart";

void main() async {
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
