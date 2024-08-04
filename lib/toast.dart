import 'package:toast/toast.dart';

void toast(String x) => Toast.show(
      x,
      duration: 3,
      gravity: Toast.bottom,
    );
