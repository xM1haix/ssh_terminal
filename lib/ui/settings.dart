import "package:flutter/material.dart";
import "package:ssh_terminal/colors.dart";
import "package:toast/toast.dart";

///Settings page
class Settings extends StatefulWidget {
  ///
  const Settings({super.key});
  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Settings"),
      ),
      body: Container(
        margin: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: gray12,
        ),
        padding: const EdgeInsets.all(10),
        child: ListView(),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    ToastContext().init(context);
  }
}
