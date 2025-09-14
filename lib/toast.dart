import "package:toast/toast.dart";

///Reusable [Toast.show] function where [x]
///represents the message and the duration is always 3 seconds
void toast(String x) => Toast.show(
      x,
      duration: 3,
    );
