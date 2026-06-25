import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontendmobile/features/hr/staff/presentation/providers/staff_notifier.dart';
import 'package:frontendmobile/features/hr/staff/presentation/widgets/details_widgets_style/action_button.dart';
import 'package:frontendmobile/features/hr/staff/presentation/widgets/details_widgets_style/info_card.dart';
import 'package:frontendmobile/features/hr/staff/presentation/widgets/details_widgets_style/rows/info_rows.dart';
import 'package:frontendmobile/features/hr/staff/presentation/widgets/details_widgets_style/staff_profile_card.dart';
import 'package:frontendmobile/features/hr/staff/presentation/widgets/details_widgets_style/rows/state_row.dart';
import 'package:frontendmobile/features/hr/staff/presentation/widgets/staff/staff_form.dart';
import 'package:image_picker/image_picker.dart';

class StaffDetailBody extends ConsumerWidget {
  final int staffId;
  const StaffDetailBody({super.key, required this.staffId});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ////////////////////////////////////////////////////////////////////////////
    ///
    ////////////////////////////////////////////////////////////////////////////
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final surface = isDark ? const Color(0xFF2C2C2E) : Colors.white;
    final border = isDark ? const Color(0xFF3A3A3C) : const Color(0xFFE5E5E3);
    final muted = isDark ? const Color(0xFF9A9A9C) : const Color(0xFF6B6B68);
    final faint = isDark ? const Color(0xFF6E6E70) : const Color(0xFFA0A09C);
    final staff = ref.watch(staffDetailProvider(staffId)).valueOrNull;
    if (staff == null) return const Center(child: CircularProgressIndicator());

    ////////////////////////////////////////////////////////////////////////////
    ///
    ////////////////////////////////////////////////////////////////////////////

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //////////////////////////////////////////////////////////////////////
          ///
          //////////////////////////////////////////////////////////////////////
          ProfileCard(
            staff: staff,
            surface: surface,
            border: border,
            muted: muted,
            onPickAvatar: () => _pickAvatar(ref),
          ),
          //////////////////////////////////////////////////////////////////////
          ///
          //////////////////////////////////////////////////////////////////////
          const SizedBox(height: 12),
          StatsRow(staff: staff),
          const SizedBox(height: 12),

          //////////////////////////////////////////////////////////////////////
          ///
          //////////////////////////////////////////////////////////////////////
          InfoCard(
            surface: surface,
            border: border,
            muted: muted,
            title: 'Personal info',
            rows: [
              InfoRow(Icons.wc_rounded, 'Gender', staff.gender, faint: faint),
              InfoRow(
                Icons.cake_outlined,
                'Date of birth',
                staff.dateOfBirth,
                faint: faint,
              ),
              InfoRow(
                Icons.location_on_outlined,
                'Address',
                staff.address,
                faint: faint,
              ),
            ],
          ),

          //////////////////////////////////////////////////////////////////////
          ///
          //////////////////////////////////////////////////////////////////////
          const SizedBox(height: 12),
          InfoCard(
            surface: surface,
            border: border,
            muted: muted,
            title: 'Contact',
            rows: [
              InfoRow(
                Icons.mail_outline_rounded,
                'Email',
                staff.email,
                faint: faint,
                highlight: true,
              ),
              InfoRow(Icons.phone_outlined, 'Phone', staff.phone, faint: faint),
            ],
          ),

          //////////////////////////////////////////////////////////////////////
          ///
          //////////////////////////////////////////////////////////////////////
          if (staff.staffRole != null) ...[
            const SizedBox(height: 12),
            InfoCard(
              surface: surface,
              border: border,
              muted: muted,
              title: 'Role',
              rows: [
                InfoRow(
                  Icons.work_outline_rounded,
                  'Role name',
                  staff.staffRole!.roleName,
                  faint: faint,
                ),
                InfoRow(
                  Icons.manage_accounts_outlined,
                  'Is manager',
                  null,
                  faint: faint,
                  trailingBadge: staff.staffRole!.isManager ? 'Yes' : 'No',
                ),
              ],
            ),
          ],

          //////////////////////////////////////////////////////////////////////
          ///
          //////////////////////////////////////////////////////////////////////
          if (staff.createdAt != null) ...[
            const SizedBox(height: 12),
            InfoCard(
              surface: surface,
              border: border,
              muted: muted,
              title: 'Meta',
              rows: [
                InfoRow(
                  Icons.calendar_today_outlined,
                  'Joined',
                  staff.createdAt!.toLocal().toString().split(' ').first,
                  faint: faint,
                ),
              ],
            ),
          ],

          //////////////////////////////////////////////////////////////////////
          ///
          //////////////////////////////////////////////////////////////////////
          const SizedBox(height: 20),
          ActionButtons(
            onEdit: () => _showEditForm(context, ref),
            onDelete: () => _confirmDelete(context, ref),
          ),
        ],
      ),
    );
  }

  //////////////////////////////////////////////////////////////////////////////
  //  IMAGE UPDATE
  //////////////////////////////////////////////////////////////////////////////1

  Future<void> _pickAvatar(WidgetRef ref) async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (picked == null) return;
    await ref
        .read(staffNotifierProvider.notifier)
        .updateAvatar(staffId, File(picked.path));
  }

  //////////////////////////////////////////////////////////////////////////////
  /// UPDATE
  //////////////////////////////////////////////////////////////////////////////

  void _showEditForm(BuildContext context, WidgetRef ref) {
    final staff = ref.read(staffDetailProvider(staffId)).valueOrNull;
    if (staff == null) return;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) => StaffForm(existing: staff),
    );
  }

  //////////////////////////////////////////////////////////////////////
  /// DELETE
  //////////////////////////////////////////////////////////////////////

  void _confirmDelete(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete staff'),
        content: Text('Delete "$staffId"? This cannot be undone.'),
        actions: [
          ///////////////////////////////////////
          ///
          ///////////////////////////////////////
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          //////////////////////////////////////
          ///
          //////////////////////////////////////
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              ref.read(staffNotifierProvider.notifier).delete(staffId);
              Navigator.of(context).pop();
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
          /////////////////////////////////////
          ///
          //////////////////////////////////////
        ],
      ),
    );
  }

  ///////////////////////////////////////////////////////////////////
  ///
  ///////////////////////////////////////////////////////////////////
}
