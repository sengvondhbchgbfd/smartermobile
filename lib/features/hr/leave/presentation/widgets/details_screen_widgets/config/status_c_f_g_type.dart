

import 'package:flutter/material.dart';

class StatusCfg {
  final String label;
  final Color color, bg;
  final IconData icon;
  const StatusCfg({
    required this.label,
    required this.color,
    required this.bg,
    required this.icon,
  });
}

class TypeCfg {
  final String label;
  final IconData icon;
  final Color color;
  const TypeCfg({required this.label, required this.icon, required this.color});
}
