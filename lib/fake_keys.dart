import "package:flutter/services.dart";

enum CustomKey { arrowRight }

class CustomKeyEvent extends KeyUpEvent {
  const CustomKeyEvent({
    required super.physicalKey,
    required super.logicalKey,
    required super.timeStamp,
  });
  factory CustomKeyEvent.customKeys(CustomKey e) => switch (e) {
        CustomKey.arrowRight => const CustomKeyEvent(
            physicalKey: PhysicalKeyboardKey.arrowRight,
            logicalKey: LogicalKeyboardKey.arrowRight,
            timeStamp: Duration.zero,
          ),
      };
}
