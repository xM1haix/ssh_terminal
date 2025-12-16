import "dart:io";

import "package:local_auth/local_auth.dart";
import "package:ssh_terminal/functions/custom_error.dart";
import "package:ssh_terminal/functions/shared_pref.dart";
import "package:ssh_terminal/functions/toast.dart";

class LocalAuth {
  LocalAuth._();
  static final _auth = LocalAuthentication();

  static bool? _isSupported;

  static Future<bool> auth(String msg) async {
    if (_isSupported != true) {
      return false;
    }

    try {
      return await _auth.authenticate(
        localizedReason: msg,
      );
    } on LocalAuthException catch (e) {
      toast(e.code.name);
      throw CustomError(e.code.name);
    }
  }

  static Future<List<BiometricType>> availableBiometrics() async {
    return _isSupported ?? false ? await _auth.getAvailableBiometrics() : [];
  }

  static Future<LocalAuth> init() async {
    _isSupported = SharedPref.readBool("localAuth");
    if (_isSupported ?? false) {
      final result =
          await _auth.canCheckBiometrics || await _auth.isDeviceSupported();
      await SharedPref.setBool("localAuth", result);
      _isSupported = result;
    }
    if (Platform.isLinux) {
      await SharedPref.setBool("localAuth", false);
      _isSupported = false;
      toast("Device is not supported");
      return LocalAuth._();
    }

    return LocalAuth._();
  }
}
