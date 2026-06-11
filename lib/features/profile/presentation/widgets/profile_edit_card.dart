import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
  //////////////////////////////////////////////////////////////////////////////
  // ── Controllers ──────────────────────────────────────────────
  //////////////////////////////////////////////////////////////////////////////
  late final TextEditingController _name;
  late final TextEditingController _phone;
  late final TextEditingController _address;
  late final TextEditingController _email;

  //////////////////////////////////////////////////////////////////////////////
  // ── Dropdown state ───────────────────────────────────────────
  //////////////////////////////////////////////////////////////////////////////

  String? _selectedGender;
  DateTime? _selectedDob;
  //////////////////////////////////////////////////////////////////////////////
  // ── Avatar ───────────────────────────────────────────────────
  //////////////////////////////////////////////////////////////////////////////

  File? _avatarFile;
  bool _loading = false;

  static const _genders = ['male', 'female', 'other'];
  //////////////////////////////////////////////////////////////////////////////
  // ── Discord-inspired colors ───────────────────────────────────
  //////////////////////////////////////////////////////////////////////////////

  static const _bg = Color(0xFF1E1F22);
  static const _surface = Color(0xFF2B2D31);
  static const _blurple = Color(0xFF5865F2);
  static const _textPrimary = Colors.white;
  static const _textMuted = Color(0xFFB5BAC1);

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
  // ── Pick avatar ───────────────────────────────────────────────
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
  // ── Pick date ─────────────────────────────────────────────────
  //////////////////////////////////////////////////////////////////////////////

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDob ?? DateTime(now.year - 25),
      firstDate: DateTime(1950),
      lastDate: DateTime(now.year - 16),
      builder: (ctx, child) => Theme(
        data: ThemeData.dark().copyWith(
          colorScheme: const ColorScheme.dark(
            primary: _blurple,
            surface: _surface,
          ),
        ),
        child: child!,
      ),
    );
    if (picked != null && mounted) {
      setState(() => _selectedDob = picked);
    }
  }
  //////////////////////////////////////////////////////////////////////////////
  // ── Submit ────────────────────────────────────────────────────
  //////////////////////////////////////////////////////////////////////////////

  Future<void> _submit() async {
    if (_name.text.trim().isEmpty) {
      _showSnack('Name is required');
      return;
    }

    if (widget.staff.id == null) {
      _showSnack('Staff ID not found');
      return;
    }

    setState(() => _loading = true);
    try {
      final request = UpdateStaffRequest(
        name: _name.text.trim(),
        phone: _phone.text.trim().isEmpty ? null : _phone.text.trim(),
        address: _address.text.trim().isEmpty ? null : _address.text.trim(),
        email: _email.text.trim().isEmpty ? null : _email.text.trim(),
        gender: _selectedGender,
        dateOfBirth: _selectedDob != null
            ? '${_selectedDob!.year}-${_selectedDob!.month.toString().padLeft(2, '0')}-${_selectedDob!.day.toString().padLeft(2, '0')}'
            : null,
      );

      await ref
          .read(staffNotifierProvider.notifier)
          .updates(widget.staff.id!, request, avatarFile: _avatarFile);
      if (mounted) context.pop();
    } catch (e) {
      if (mounted) _showSnack(e.toString());
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }
  //////////////////////////////////////////////////////////////////////////////
  ///
  //////////////////////////////////////////////////////////////////////////////

  void _showSnack(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: _surface,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }
  //////////////////////////////////////////////////////////////////////////////
  // ── Build ─────────────────────────────────────────────────────
  //////////////////////////////////////////////////////////////////////////////

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      appBar: AppBar(
        backgroundColor: _bg,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            size: 18,
            color: _textMuted,
          ),
          onPressed: () => context.pop(),
        ),
        title: const Text(
          'Edit Profile',
          style: TextStyle(
            color: _textPrimary,
            fontSize: 17,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: _loading
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: _blurple,
                    ),
                  )
                : TextButton(
                    onPressed: _submit,
                    child: const Text(
                      'Save',
                      style: TextStyle(
                        color: _blurple,
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
            ////////////////////////////////////////////////////////////////////
            // ── Avatar picker ──────────────────────────────────
            ////////////////////////////////////////////////////////////////////
            AvatarPicker(
              avatarUrl: widget.staff.avatarUrl,
              avatarFile: _avatarFile,
              name: widget.staff.name,
              onTap: _pickAvatar,
            ),
            const SizedBox(height: 24),

            ////////////////////////////////////////////////////////////////////
            // ── Read-only section ──────────────────────────────
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
            // ── Editable section ───────────────────────────────
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

            // Gender dropdown
            GenderDropdown(
              value: _selectedGender,
              genders: _genders,
              onChanged: (val) => setState(() => _selectedGender = val),
            ),
            const SizedBox(height: 10),
            DateTile(dob: _selectedDob, onTap: _pickDate),
            const SizedBox(height: 32),

            ////////////////////////////////////////////////////////////////////
            // ── Save button ────────────────────────────────────
            ////////////////////////////////////////////////////////////////////
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _loading ? null : _submit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: _blurple,
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
