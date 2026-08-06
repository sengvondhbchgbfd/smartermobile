import 'package:flutter/material.dart';

class ShellScrollController extends InheritedWidget {
  final ScrollController controller;
  const ShellScrollController({
    super.key,
    required this.controller,
    required super.child,
  });
  static ScrollController? of(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<ShellScrollController>()
        ?.controller;
  }

  @override
  bool updateShouldNotify(ShellScrollController oldWidget) =>
      controller != oldWidget.controller;
}
