import 'package:flutter/material.dart';
import 'package:frontendmobile/config/routes/route_names.dart';

const List<(String, IconData, String)> navItems = [
  (RouteNames.dashboard, Icons.dashboard_rounded, 'Home'),
  (RouteNames.chat, Icons.chat_rounded, 'Chat'),
  ('__scan__', Icons.qr_code_scanner_rounded, 'Scan'),
  (RouteNames.users, Icons.people_alt_rounded, 'Users'),
  (RouteNames.profile, Icons.person_rounded, 'Profile'),
];
