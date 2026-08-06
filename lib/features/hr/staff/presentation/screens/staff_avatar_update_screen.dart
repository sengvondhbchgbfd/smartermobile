import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontendmobile/core/themes/app_pallets.dart';
import 'package:frontendmobile/features/hr/staff/presentation/providers/staff_notifier.dart';
import 'package:frontendmobile/features/hr/staff/presentation/widgets/in_app_camera_screen.dart';
import 'package:frontendmobile/features/hr/staff/presentation/widgets/staff_image_widgets/staff_avatar.dart';
import 'package:image_picker/image_picker.dart';

class StaffAvatarUpdateScreen extends ConsumerStatefulWidget {
  final int staffId;
  final String name;
  final String? currentAvatarUrl;

  const StaffAvatarUpdateScreen({
    super.key,
    required this.staffId,
    required this.name,
    this.currentAvatarUrl,
  });

  @override
  ConsumerState<StaffAvatarUpdateScreen> createState() =>
      _StaffAvatarUpdateScreenState();
}

class _StaffAvatarUpdateScreenState
    extends ConsumerState<StaffAvatarUpdateScreen> {
  File? _pickedFile;
  bool _isSaving = false;

  bool get _hasChange => _pickedFile != null;

  // ── Pick from gallery ──────────────────────────────────────
  Future<void> _pickFromGallery() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() => _pickedFile = File(picked.path));
    }
  }

  // ── Take photo (reuses your in-app camera) ─────────────────
  Future<void> _pickFromCamera() async {
    final file = await Navigator.push<File>(
      context,
      MaterialPageRoute(
        fullscreenDialog: true,
        builder: (_) => const InAppCameraScreen(),
      ),
    );
    if (file != null) {
      setState(() => _pickedFile = file);
    }
  }

  // ── Save ─────────────────────────────────────────────────
  Future<void> _save() async {
    if (!_hasChange) return;
    setState(() => _isSaving = true);
    try {
      await ref
          .read(staffNotifierProvider.notifier)
          .updateAvatar(widget.staffId, _pickedFile!);
      if (mounted) Navigator.pop(context, true);
    } catch (e) {
      if (mounted) {
        setState(() => _isSaving = false);
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Failed to update photo: $e')));
      }
    }
  }

  // ── Cancel ───────────────────────────────────────────────
  void _cancel() => Navigator.pop(context, false);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = isDark ? Pallets.backgroundDark : Pallets.backgroundLight;
    final surface = isDark ? Pallets.surfaceDark : Pallets.surfaceLight;
    final textPrimary = isDark
        ? Pallets.textPrimaryDark
        : Pallets.textPrimaryLight;
    final textSecondary = isDark
        ? Pallets.textSecondaryDark
        : Pallets.textSecondaryLight;
    final border = isDark ? Pallets.borderDark : Pallets.borderLight;
    final chipBg = isDark ? Pallets.surfaceElevated : Pallets.backgroundLight;

    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        title: Text(
          'Update Photo',
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
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: _isSaving ? null : _cancel,
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              const SizedBox(height: 12),

              // ── Preview ──
              // ── Preview ──
              Container(
                width: 160,
                height: 160,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Pallets.blurple, width: 2),
                ),
                padding: const EdgeInsets.all(4),
                child: ClipOval(
                  child: _pickedFile != null
                      ? Image.file(_pickedFile!, fit: BoxFit.cover)
                      : StaffAvatar(
                          name: widget.name,
                          avatarUrl: widget.currentAvatarUrl,
                          radius: 76,
                        ),
                ),
              ),

              const SizedBox(height: 8),
              Text(
                widget.name,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 15,
                  color: textPrimary,
                ),
              ),

              const SizedBox(height: 32),

              // ── Pick source buttons ──
              Row(
                children: [
                  Expanded(
                    child: _SourceButton(
                      icon: Icons.photo_library_outlined,
                      label: 'Gallery',
                      chipBg: chipBg,
                      textColor: textPrimary,
                      onTap: _isSaving ? null : _pickFromGallery,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _SourceButton(
                      icon: Icons.camera_alt_outlined,
                      label: 'Camera',
                      chipBg: chipBg,
                      textColor: textPrimary,
                      onTap: _isSaving ? null : _pickFromCamera,
                    ),
                  ),
                ],
              ),

              if (_hasChange) ...[
                const SizedBox(height: 12),
                Text(
                  'New photo selected — tap Save to apply.',
                  style: TextStyle(fontSize: 12.5, color: textSecondary),
                ),
              ],

              const Spacer(),

              // ── Save / Cancel ──
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: _isSaving ? null : _cancel,
                      style: OutlinedButton.styleFrom(
                        foregroundColor: textPrimary,
                        side: BorderSide(color: border),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text('Cancel'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        gradient: _hasChange ? Pallets.brandGradient : null,
                        color: _hasChange ? null : chipBg,
                      ),
                      child: ElevatedButton(
                        onPressed: (_hasChange && !_isSaving) ? _save : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Pallets.transparent,
                          shadowColor: Pallets.transparent,
                          disabledBackgroundColor: Pallets.transparent,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: _isSaving
                            ? const SizedBox(
                                width: 18,
                                height: 18,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : Text(
                                'Save',
                                style: TextStyle(
                                  color: _hasChange
                                      ? Colors.white
                                      : textSecondary,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SourceButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color chipBg;
  final Color textColor;
  final VoidCallback? onTap;

  const _SourceButton({
    required this.icon,
    required this.label,
    required this.chipBg,
    required this.textColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: chipBg,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Icon(icon, color: Pallets.blurple, size: 24),
            const SizedBox(height: 6),
            Text(label, style: TextStyle(fontSize: 12.5, color: textColor)),
          ],
        ),
      ),
    );
  }
}
