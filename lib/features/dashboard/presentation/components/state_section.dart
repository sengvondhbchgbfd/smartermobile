import 'package:flutter/material.dart';
import 'package:frontendmobile/features/dashboard/presentation/components/attendance_scann.dart';
import 'package:frontendmobile/features/dashboard/presentation/widgets/chat_preview_widget.dart';
import 'package:frontendmobile/features/dashboard/presentation/widgets/modules_grid_widgets.dart';
import 'package:frontendmobile/features/dashboard/presentation/widgets/recent_activity_widgets.dart';
import 'package:frontendmobile/features/dashboard/presentation/widgets/stage_grid_widgets.dart';

class StatsSection extends StatelessWidget {
  const StatsSection({super.key, required this.screenWidth});

  final double screenWidth;
  @override
  Widget build(BuildContext context) => buildStatsGrid(screenWidth);
}

class ModulesSection extends StatelessWidget {
  const ModulesSection({super.key, required this.screenWidth});

  final double screenWidth;

  @override
  Widget build(BuildContext context) => buildModules(screenWidth);
}

class AttendanceSection extends StatelessWidget {
  const AttendanceSection({super.key});

  @override
  Widget build(BuildContext context) => buildAttendanceCard();
}

class ChatPreviewSection extends StatelessWidget {
  const ChatPreviewSection({super.key});

  @override
  Widget build(BuildContext context) => buildChatPreview();
}

class RecentActivitySection extends StatelessWidget {
  const RecentActivitySection({super.key});

  @override
  Widget build(BuildContext context) => buildRecentActivity();
}
