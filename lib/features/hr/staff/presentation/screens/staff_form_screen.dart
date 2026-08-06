import 'package:flutter/material.dart';
import 'package:frontendmobile/core/themes/app_pallets.dart';
import 'package:frontendmobile/features/hr/staff/domain/entities/staff_entity.dart';
import 'package:frontendmobile/features/hr/staff/presentation/widgets/staff/staff_form.dart';
import 'package:frontendmobile/config/routes/route_names.dart';
import 'package:go_router/go_router.dart';

class StaffFormScreen extends StatelessWidget {
  final StaffEntity? existing;
  const StaffFormScreen({super.key, this.existing});

  bool get _isEditing => existing != null;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = isDark ? Pallets.backgroundDark : Pallets.backgroundLight;
    final surface = isDark ? Pallets.surfaceDark : Pallets.surfaceLight;
    final textPrimary = isDark
        ? Pallets.textPrimaryDark
        : Pallets.textPrimaryLight;
    final border = isDark ? Pallets.borderDark : Pallets.borderLight;

    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        title: Text(
          _isEditing ? 'Edit Staff' : 'Create Staff',
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
      ),
      body: StaffForm(
        existing: existing,
        onGoToRoles: () => context.go(RouteNames.staffRoles),
      ),
    );
  }
}
