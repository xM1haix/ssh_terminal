import 'package:flutter/services.dart';

enum CustomKey { arrowRight }

class CustomKeyEvent extends KeyUpEvent {
  const CustomKeyEvent({
    required super.physicalKey,
    required super.logicalKey,
    required super.timeStamp,
  });
  factory CustomKeyEvent.customKeys(CustomKey e) => switch (e) {
        CustomKey.arrowRight => const CustomKeyEvent(
            physicalKey: PhysicalKeyboardKey(0x0007004f),
            logicalKey: LogicalKeyboardKey(0x100000303),
            timeStamp: Duration.zero,
          ),
      };
}
