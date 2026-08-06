import 'package:flutter/material.dart';
import 'package:frontendmobile/core/themes/app_pallets.dart';
import 'package:frontendmobile/features/hr/staff/domain/entities/staff_role_entity.dart';
import 'package:frontendmobile/features/hr/staff/presentation/widgets/role/staff_role_form.dart';

class StaffRoleFormScreen extends StatelessWidget {
  final StaffRoleEntity? existing;
  const StaffRoleFormScreen({super.key, this.existing});

  bool get _isEditing => existing != null;

  @override
  Widget build(BuildContext context) {
    ////////////////////////////////////////////////////////////////////////////
    ///
    ////////////////////////////////////////////////////////////////////////////
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = isDark ? Pallets.backgroundDark : Pallets.backgroundLight;
    final surface = isDark ? Pallets.surfaceDark : Pallets.surfaceLight;
    final textPrimary = isDark
        ? Pallets.textPrimaryDark
        : Pallets.textPrimaryLight;
    final border = isDark ? Pallets.borderDark : Pallets.borderLight;
    ////////////////////////////////////////////////////////////////////////////
    ///
    ////////////////////////////////////////////////////////////////////////////
    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        title: Text(
          _isEditing ? 'Edit Staff Role' : 'Create Staff Role',
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
      body: StaffRoleForm(existing: existing),
    );
    ////////////////////////////////////////////////////////////////////////////
    ///
    ////////////////////////////////////////////////////////////////////////////
  }
}
