import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontendmobile/core/themes/app_pallets.dart';
import 'package:frontendmobile/config/routes/route_names.dart';
import 'package:frontendmobile/features/hr/staff/presentation/providers/staff_notifier.dart';
import 'package:frontendmobile/features/hr/staff/presentation/widgets/details_widgets_style/staff_detail_body.dart';
import 'package:frontendmobile/features/hr/staff/presentation/widgets/error_view.dart';
import 'package:go_router/go_router.dart';

class StaffDetailScreen extends ConsumerWidget {
  final int staffId;
  const StaffDetailScreen({super.key, required this.staffId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = isDark ? Pallets.backgroundDark : Pallets.backgroundLight;
    final surface = isDark ? Pallets.surfaceDark : Pallets.surfaceLight;
    final textPrimary = isDark
        ? Pallets.textPrimaryDark
        : Pallets.textPrimaryLight;
    final border = isDark ? Pallets.borderDark : Pallets.borderLight;

    final staffAsync = ref.watch(staffDetailProvider(staffId));
    final staff = staffAsync.maybeWhen(data: (s) => s, orElse: () => null);

    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        title: Text(
          staff?.name ?? 'Staff Detail',
          style: TextStyle(
            color: textPrimary,
            fontWeight: FontWeight.w700,
            fontSize: 19,
            letterSpacing: -0.3,
          ),
        ),
        centerTitle: false,
        backgroundColor: surface,
        surfaceTintColor: Pallets.transparent,
        elevation: 0,
        scrolledUnderElevation: 1,
        shape: Border(bottom: BorderSide(color: border, width: 1)),
        iconTheme: IconThemeData(color: textPrimary),
        actions: [
          if (staff != null)
            IconButton(
              icon: const Icon(Icons.edit_outlined),
              tooltip: 'Edit Staff',
              onPressed: () {
                context.push(RouteNames.staffForm, extra: staff);
              },
            ),
        ],
      ),
      body: staffAsync.when(
        loading: () => const Center(
          child: CircularProgressIndicator(color: Pallets.blurple),
        ),
        error: (e, _) => ErrorView(
          message: '$e',
          onRetry: () => ref.invalidate(staffDetailProvider(staffId)),
        ),
        data: (_) => StaffDetailBody(staffId: staffId),
      ),
    );
  }
}
