import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontendmobile/core/themes/app_pallets.dart';
import 'package:frontendmobile/features/profile/presentation/widgets/edited/avatar_picker.dart';
import 'package:frontendmobile/features/profile/presentation/widgets/edited/date_tile.dart';
import 'package:frontendmobile/features/profile/presentation/widgets/edited/edit_field.dart';
import 'package:frontendmobile/features/profile/presentation/widgets/edited/gender_dropdown.dart';
import 'package:frontendmobile/features/profile/presentation/widgets/edited/read_only_tile.dart';
import 'package:frontendmobile/features/profile/presentation/widgets/edited/section_label.dart'
    show SectionLabel;
import 'package:image_picker/image_picker.dart';
import 'package:frontendmobile/features/hr/staff/data/model/staff/update_staff_request.dart';
import 'package:frontendmobile/features/hr/staff/domain/entities/staff_entity.dart';
import 'package:frontendmobile/features/hr/staff/presentation/providers/staff_notifier.dart';
import 'package:frontendmobile/features/profile/domain/entities/profile_entity.dart';
import 'package:go_router/go_router.dart';

////////////////////////////////////////////////////////////////////////////////
///
////////////////////////////////////////////////////////////////////////////////

class EditProfilePage extends ConsumerStatefulWidget {
  final ProfileEntity profile;
  final StaffEntity staff;

  const EditProfilePage({
    super.key,
    required this.profile,
    required this.staff,
  });

  @override
  ConsumerState<EditProfilePage> createState() => _EditProfilePageState();
}

////////////////////////////////////////////////////////////////////////////////
///
////////////////////////////////////////////////////////////////////////////////

class _EditProfilePageState extends ConsumerState<EditProfilePage> {
  late final TextEditingController _name;
  late final TextEditingController _phone;
  late final TextEditingController _address;
  late final TextEditingController _email;

  String? _selectedGender;
  DateTime? _selectedDob;
  File? _avatarFile;
  bool _loading = false;

  static const _genders = ['male', 'female', 'other'];

  //////////////////////////////////////////////////////////////////////////////
  ///
  //////////////////////////////////////////////////////////////////////////////

  @override
  void initState() {
    super.initState();
    _name = TextEditingController(text: widget.staff.name);
    _phone = TextEditingController(text: widget.staff.phone ?? '');
    _address = TextEditingController(text: widget.staff.address ?? '');
    _email = TextEditingController(text: widget.staff.email ?? '');
    _selectedGender = widget.staff.gender;
    if (widget.staff.dateOfBirth != null) {
      _selectedDob = DateTime.tryParse(widget.staff.dateOfBirth!);
    }
  }

  //////////////////////////////////////////////////////////////////////////////
  ///
  //////////////////////////////////////////////////////////////////////////////

  @override
  void dispose() {
    _name.dispose();
    _phone.dispose();
    _address.dispose();
    _email.dispose();
    super.dispose();
  }

  //////////////////////////////////////////////////////////////////////////////
  ///
  //////////////////////////////////////////////////////////////////////////////

  Future<void> _pickAvatar() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );
    if (picked != null && mounted) {
      setState(() => _avatarFile = File(picked.path));
    }
  }

  //////////////////////////////////////////////////////////////////////////////
  ///
  //////////////////////////////////////////////////////////////////////////////

  Future<void> _pickDate(bool isDark) async {
    final now = DateTime.now();
    final surface = isDark ? Pallets.surfaceDark : Pallets.surfaceLight;
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDob ?? DateTime(now.year - 25),
      firstDate: DateTime(1950),
      lastDate: DateTime(now.year - 16),
      builder: (ctx, child) => Theme(
        data: (isDark ? ThemeData.dark() : ThemeData.light()).copyWith(
          colorScheme: isDark
              ? ColorScheme.dark(primary: Pallets.gradient2, surface: surface)
              : ColorScheme.light(primary: Pallets.gradient2, surface: surface),
        ),
        child: child!,
      ),
    );
    if (picked != null && mounted) {
      setState(() => _selectedDob = picked);
    }
  }

  //////////////////////////////////////////////////////////////////////////////
  ///
  //////////////////////////////////////////////////////////////////////////////

  Future<void> _submit(Color surface) async {
    if (_name.text.trim().isEmpty) {
      _showSnack('Name is required', surface);
      return;
    }
    if (widget.staff.id == null) {
      _showSnack('Staff ID not found', surface);
      return;
    }
    setState(() => _loading = true);
    try {
      ////////////////////////////////////////
      ///
      ///////////////////////////////////////
      final request = UpdateStaffRequest(
        name: _name.text.trim(),
        phone: _phone.text.trim().isEmpty ? null : _phone.text.trim(),
        address: _address.text.trim().isEmpty ? null : _address.text.trim(),
        email: _email.text.trim().isEmpty ? null : _email.text.trim(),
        gender: _selectedGender,
        dateOfBirth: _selectedDob != null
            ? '${_selectedDob!.year}-'
                  '${_selectedDob!.month.toString().padLeft(2, '0')}-'
                  '${_selectedDob!.day.toString().padLeft(2, '0')}'
            : null,
      );

      ////////////////////////////////////////
      ///
      ///////////////////////////////////////
      await ref
          .read(staffNotifierProvider.notifier)
          .updates(widget.staff.id!, request, avatarFile: _avatarFile);
      if (mounted) context.pop();
    } catch (e) {
      if (mounted) _showSnack(e.toString(), surface);
    } finally {
      if (mounted) setState(() => _loading = false);
    }
    ////////////////////////////////////////
    ///
    ///////////////////////////////////////
  }

  //////////////////////////////////////////////////////////////////////////////
  ///
  //////////////////////////////////////////////////////////////////////////////
  void _showSnack(String msg, Color surface) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: surface,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  //////////////////////////////////////////////////////////////////////////////
  ///
  //////////////////////////////////////////////////////////////////////////////

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
    final textSecondary = isDark
        ? Pallets.textSecondaryDark
        : Pallets.textSecondaryLight;

    ////////////////////////////////////////////////////////////////////////////
    ///
    ////////////////////////////////////////////////////////////////////////////
    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        backgroundColor: bg,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            size: 18,
            color: textSecondary,
          ),
          onPressed: () => context.pop(),
        ),
        title: Text(
          'Edit Profile',
          style: TextStyle(
            color: textPrimary,
            fontSize: 17,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: _loading
                ? SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Pallets.gradient2,
                    ),
                  )
                : TextButton(
                    onPressed: () => _submit(surface),
                    child: const Text(
                      'Save',
                      style: TextStyle(
                        color: Pallets.gradient2,
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                      ),
                    ),
                  ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AvatarPicker(
              avatarUrl: widget.staff.avatarUrl,
              avatarFile: _avatarFile,
              name: widget.staff.name,
              onTap: _pickAvatar,
            ),
            const SizedBox(height: 24),

            ////////////////////////////////////////////////////////////////////
            // ── Read-only ─────────────────────────────────────────────────
            ////////////////////////////////////////////////////////////////////
            SectionLabel('ACCOUNT'),
            const SizedBox(height: 8),
            ReadOnlyTile(
              icon: Icons.alternate_email_rounded,
              label: 'Username',
              value: widget.profile.username,
            ),
            const SizedBox(height: 6),
            ReadOnlyTile(
              icon: Icons.badge_outlined,
              label: 'Staff ID',
              value: '#${widget.profile.staffId}',
            ),
            const SizedBox(height: 6),
            ReadOnlyTile(
              icon: Icons.shield_outlined,
              label: 'Role',
              value: widget.staff.staffRole?.roleName ?? widget.profile.role,
            ),
            const SizedBox(height: 6),
            ReadOnlyTile(
              icon: Icons.business_outlined,
              label: 'Department',
              value: widget.profile.department ?? '—',
            ),
            const SizedBox(height: 24),

            ////////////////////////////////////////////////////////////////////
            // ── Editable ─────────────────────────────────────────────────
            ////////////////////////////////////////////////////////////////////
            SectionLabel('PERSONAL INFO'),
            const SizedBox(height: 8),
            EditField(
              controller: _name,
              label: 'Full Name',
              icon: Icons.person_outline_rounded,
            ),
            const SizedBox(height: 10),
            EditField(
              controller: _phone,
              label: 'Phone',
              icon: Icons.phone_outlined,
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 10),
            EditField(
              controller: _email,
              label: 'Email',
              icon: Icons.mail_outline_rounded,
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 10),
            EditField(
              controller: _address,
              label: 'Address',
              icon: Icons.location_on_outlined,
              maxLines: 2,
            ),
            const SizedBox(height: 10),
            GenderDropdown(
              value: _selectedGender,
              genders: _genders,
              onChanged: (val) => setState(() => _selectedGender = val),
            ),
            const SizedBox(height: 10),
            DateTile(dob: _selectedDob, onTap: () => _pickDate(isDark)),
            const SizedBox(height: 32),

            ////////////////////////////////////////////////////////////////////
            // ── Save button ───────────────────────────────────────────────
            ////////////////////////////////////////////////////////////////////
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _loading ? null : () => _submit(surface),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Pallets.gradient2,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: _loading
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Text(
                        'Save Changes',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
