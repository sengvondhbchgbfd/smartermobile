import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontendmobile/features/auth/data/models/auth_user_model.dart';
import 'package:frontendmobile/features/dashboard/presentation/components/attendance_scann.dart';
import 'package:frontendmobile/features/dashboard/presentation/widgets/chat_preview_widget.dart';
import 'package:frontendmobile/features/dashboard/presentation/widgets/modules_grid_widgets.dart';
import 'package:frontendmobile/features/dashboard/presentation/widgets/recent_activity_widgets.dart';
import 'package:frontendmobile/features/dashboard/presentation/widgets/stage_grid_widgets.dart';

////////////////////////////////////////////////////////////////////////////////
///
////////////////////////////////////////////////////////////////////////////////
class StatsSection extends StatelessWidget {
  const StatsSection({super.key, required this.screenWidth});
  final double screenWidth;
  @override
  Widget build(BuildContext context) => const StatsGrid();
}

////////////////////////////////////////////////////////////////////////////////
/// ATTENDNCE CARD
////////////////////////////////////////////////////////////////////////////////

class AttendanceSection extends StatelessWidget {
  const AttendanceSection({super.key});
  @override
  Widget build(BuildContext context) => buildAttendanceCard();
}

////////////////////////////////////////////////////////////////////////////////
///
////////////////////////////////////////////////////////////////////////////////
class ModulesSection extends StatelessWidget {
  const ModulesSection({
    super.key,
    required this.screenWidth,
    this.currentUser,
  });
  final double screenWidth;
  final UserInfo? currentUser;
  @override
  Widget build(BuildContext context) =>
      buildModules(context, screenWidth, visibleModules(currentUser));
}
////////////////////////////////////////////////////////////////////////////////
///
////////////////////////////////////////////////////////////////////////////////

class ChatPreviewSection extends StatelessWidget {
  const ChatPreviewSection({super.key});
  @override
  Widget build(BuildContext context) => buildChatPreview();
}

////////////////////////////////////////////////////////////////////////////////
///  RECENT ACTIVITY — notifier's own build() handles the initial fetch
////////////////////////////////////////////////////////////////////////////////

class RecentActivitySection extends ConsumerWidget {
  const RecentActivitySection({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) =>
      buildRecentActivity(context, ref);
}
