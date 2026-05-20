import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontendmobile/config/routes/route_names.dart';
import 'package:frontendmobile/features/hr/staff/domain/entities/staff_entity.dart';
import 'package:frontendmobile/features/hr/staff/presentation/providers/staff_notifier.dart';
import 'package:frontendmobile/features/hr/staff/presentation/widgets/image_preview_screen.dart';
import 'package:frontendmobile/features/hr/staff/presentation/widgets/in_app_camera_screen.dart';
import 'package:frontendmobile/features/hr/staff/presentation/widgets/staff_avatar.dart';
import 'package:frontendmobile/features/hr/staff/presentation/widgets/staff_detail_sheet.dart';
import 'package:frontendmobile/features/hr/staff/presentation/widgets/staff_form.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

class StaffCard extends ConsumerWidget {
  final StaffEntity staff;
  const StaffCard({super.key, required this.staff});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: ListTile(
        isThreeLine: true,
        onTap: () => _showDetail(context),

        // ── Avatar: tapping now shows the Facebook-style picker sheet ──
        leading: GestureDetector(
          onTap: () => _showAvatarOptions(context, ref),
          child: StaffAvatar(name: staff.name, avatarUrl: staff.avatarUrl),
        ),

        title: Text(
          staff.name,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),

        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(staff.email ?? 'No email'),
            Text(staff.phone ?? 'No phone'),
            if (staff.staffRole != null)
              Text(
                staff.staffRole!.roleName,
                style: TextStyle(
                  color: Colors.blue.shade700,
                  fontWeight: FontWeight.w500,
                ),
              ),
          ],
        ),

        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.edit_outlined),
              onPressed: () => _showForm(context, ref),
            ),
            IconButton(
              icon: const Icon(Icons.delete_outline, color: Colors.red),
              onPressed: () => _confirmDelete(context, ref),
            ),
          ],
        ),
      ),
    );
  }

  // ──────────────────────────────────────────────────────────────
  // AVATAR OPTIONS  (Facebook-style bottom sheet)
  // ──────────────────────────────────────────────────────────────

  void _showAvatarOptions(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // ── Handle bar ──
              Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),

              // ── Large avatar preview ──
              StaffAvatar(
                name: staff.name,
                avatarUrl: staff.avatarUrl,
                radius: 48,
              ),
              const SizedBox(height: 8),
              Text(
                staff.name,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 16),
              const Divider(height: 1),

              // ── View photo ──
              if (staff.avatarUrl != null)
                ListTile(
                  leading: const CircleAvatar(
                    backgroundColor: Color(0xFFE4E6EB),
                    child: Icon(Icons.image_outlined, color: Colors.black87),
                  ),
                  title: const Text('View profile photo'),
                  onTap: () {
                    Navigator.pop(context);
                    _viewPhoto(context);
                  },
                ),

              // ── Upload from gallery ──
              ListTile(
                leading: const CircleAvatar(
                  backgroundColor: Color(0xFFE4E6EB),
                  child: Icon(
                    Icons.photo_library_outlined,
                    color: Colors.black87,
                  ),
                ),
                title: const Text('Upload photo'),
                subtitle: const Text('Choose from your gallery'),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(context, ref, ImageSource.gallery);
                },
              ),

              // ── Take a photo ──
              ListTile(
                leading: const CircleAvatar(
                  backgroundColor: Color(0xFFE4E6EB),
                  child: Icon(Icons.camera_alt_outlined, color: Colors.black87),
                ),
                title: const Text('Take a photo'),
                subtitle: const Text('Use your camera'),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(context, ref, ImageSource.camera);
                },
              ),

              // ── Remove photo ──
              if (staff.avatarUrl != null)
                ListTile(
                  leading: const CircleAvatar(
                    backgroundColor: Color(0xFFE4E6EB),
                    child: Icon(Icons.delete_outline, color: Colors.red),
                  ),
                  title: const Text(
                    'Remove current photo',
                    style: TextStyle(color: Colors.red),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    _confirmRemoveAvatar(context, ref);
                  },
                ),

              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }

  // ──────────────────────────────────────────────────────────────
  // VIEW FULL-SCREEN PHOTO
  // ──────────────────────────────────────────────────────────────

  void _viewPhoto(BuildContext context) {
    if (staff.avatarUrl == null) return;
    showDialog(
      context: context,
      builder: (_) => Dialog(
        backgroundColor: Colors.black,
        insetPadding: EdgeInsets.zero,
        child: Stack(
          children: [
            Center(
              child: InteractiveViewer(child: Image.network(staff.avatarUrl!)),
            ),
            Positioned(
              top: 40,
              right: 16,
              child: IconButton(
                icon: const Icon(Icons.close, color: Colors.white, size: 28),
                onPressed: () => Navigator.pop(context),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ──────────────────────────────────────────────────────────────
  // PICK IMAGE (gallery or camera)
  // ──────────────────────────────────────────────────────────────
  Future<void> _pickImage(
    BuildContext context,
    WidgetRef ref,
    ImageSource source,
  ) async {
    File? imageFile;

    // Step 1: Get image from camera or gallery
    if (source == ImageSource.camera) {
      imageFile = await Navigator.push<File>(
        context,
        MaterialPageRoute(
          fullscreenDialog: true,
          builder: (_) => const InAppCameraScreen(),
        ),
      );
    } else {
      final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (picked != null) imageFile = File(picked.path);
    }

    if (imageFile == null) return;

    // Step 2: Show preview screen — user decides Save or Cancel
    if (!context.mounted) return;
    final confirmed = await Navigator.push<File>(
      context,
      MaterialPageRoute(
        fullscreenDialog: true,
        builder: (_) => ImagePreviewScreen(
          imageFile: imageFile!,
          oldAvatarUrl: staff.avatarUrl, // ← passes old photo for swipe compare
        ),
      ),
    );

    // Step 3: Only upload if user tapped Save
    if (confirmed == null) return;

    await ref
        .read(staffNotifierProvider.notifier)
        .updateAvatar(staff.id!, confirmed);
  }

  // ──────────────────────────────────────────────────────────────
  // CONFIRM REMOVE AVATAR
  // ──────────────────────────────────────────────────────────────

  void _confirmRemoveAvatar(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Remove photo'),
        content: const Text(
          'Are you sure you want to remove the profile photo?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              // Call your remove-avatar method here, e.g.:
              // ref.read(staffNotifierProvider.notifier).removeAvatar(staff.id!);
            },
            child: const Text('Remove', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  // ──────────────────────────────────────────────────────────────
  // SHOW DETAIL
  // ──────────────────────────────────────────────────────────────

  void _showDetail(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) => StaffDetailSheet(staff: staff),
    );
  }

  // ──────────────────────────────────────────────────────────────
  // SHOW FORM
  // ──────────────────────────────────────────────────────────────

  void _showForm(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) => ProviderScope(
        parent: ProviderScope.containerOf(context),
        child: StaffForm(
          existing: staff,
          onGoToRoles: () => context.go(RouteNames.staffRoles),
        ),
      ),
    );
  }

  // ──────────────────────────────────────────────────────────────
  // CONFIRM DELETE
  // ──────────────────────────────────────────────────────────────

  void _confirmDelete(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Staff'),
        content: Text('Delete "${staff.name}"? This cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              ref.read(staffNotifierProvider.notifier).delete(staff.id!);
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}

// ──────────────────────────────────────────────────────────────
// AVATAR WIDGET
// ──────────────────────────────────────────────────────────────
