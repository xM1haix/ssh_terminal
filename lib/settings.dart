import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';

import 'colors.dart';
import 'toast.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  late bool _fingerPrint = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Settings'),
      ),
      body: Container(
        margin: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: gray12,
        ),
        padding: const EdgeInsets.all(10),
        child: ListView(
          children: [
            if (_fingerPrint)
              SwitchListTile(
                activeColor: Colors.blue,
                title: const Text('Unlock using fingerprint'),
                value: _fingerPrint,
                onChanged: (value) async {
                  try {
                    final x = await _getFingerPrint();
                    if (x != true) throw "Finger print failed";
                    setState(() => _fingerPrint = value);
                    final p = await SharedPreferences.getInstance();
                    final s = await p.setBool('fingerPrint', _fingerPrint);
                    if (s != true) throw "Failed to save";
                  } catch (e) {
                    toast(e.toString());
                  }
                },
              ),
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    ToastContext().init(context);
    _getPrefs();
  }

  Future<bool> _getFingerPrint() async {
    try {
      return await LocalAuthentication().authenticate(
        localizedReason: 'Check the fingerprint!',
        options: const AuthenticationOptions(
          biometricOnly: true,
        ),
      );
    } on PlatformException catch (e) {
      Toast.show(e.toString(), duration: 3, gravity: Toast.bottom);
      return false;
    }
  }

  void _getPrefs() async {
    final p = await SharedPreferences.getInstance();
    final auth = LocalAuthentication();
    await p.setBool('fingerPrint',
        await auth.canCheckBiometrics && await auth.isDeviceSupported());
    setState(() {
      _fingerPrint = p.getBool('fingerPrint') ?? false;
    });
  }
}
