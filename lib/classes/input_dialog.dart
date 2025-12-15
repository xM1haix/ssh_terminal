import "package:flutter/material.dart";

class InputData {
  const InputData(
    this.name,
    this.controller, {
    this.isPort = false,
    this.isHide = false,
    this.hiden,
  });
  final TextEditingController controller;
  final String name;
  final bool isPort;
  final Widget? hiden;
  final bool isHide;
}
