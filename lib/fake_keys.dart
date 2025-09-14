import "package:flutter/services.dart";

///enum of [CustomKey]
enum CustomKey {
  ///Represent eh alias for arrow right
  arrowRight
}

///Extended object on [KeyUpEvent]
class CustomKeyEvent extends KeyUpEvent {
  ///Requires [physicalKey],[logicalKey],[timeStamp]
  const CustomKeyEvent({
    required super.physicalKey,
    required super.logicalKey,
    required super.timeStamp,
  });

  ///factory to create [CustomKeyEvent] based on [CustomKey]
  factory CustomKeyEvent.customKeys(CustomKey e) => switch (e) {
        CustomKey.arrowRight => const CustomKeyEvent(
            physicalKey: PhysicalKeyboardKey.arrowRight,
            logicalKey: LogicalKeyboardKey.arrowRight,
            timeStamp: Duration.zero,
          ),
      };
}
