import 'package:flutter/material.dart';
import 'package:frontendmobile/core/themes/app_pallets.dart';
import 'package:frontendmobile/features/inventory/invoice/presentation/widgets/details/attachment_tile.dart';

class AttachmentsSection extends StatelessWidget {
  final List<dynamic> attachments;
  final bool isUploading;
  final VoidCallback onAdd;
  final void Function(int attachmentId) onDelete;

  const AttachmentsSection({
    super.key,
    required this.attachments,
    required this.isUploading,
    required this.onAdd,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textPrimary = isDark
        ? Pallets.textPrimaryDark
        : Pallets.textPrimaryLight;
    final textSecondary = isDark
        ? Pallets.textSecondaryDark
        : Pallets.textSecondaryLight;
    final accent = Pallets.blurple;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Attachments',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 14,
                color: textPrimary,
              ),
            ),
            TextButton.icon(
              onPressed: isUploading ? null : onAdd,
              style: TextButton.styleFrom(foregroundColor: accent),
              icon: isUploading
                  ? SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: accent,
                      ),
                    )
                  : const Icon(Icons.attach_file, size: 18),
              label: Text(isUploading ? 'Uploading...' : 'Add'),
            ),
          ],
        ),
        const SizedBox(height: 8),
        if (isUploading)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Row(
              children: [
                SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: accent,
                  ),
                ),
                const SizedBox(width: 10),
                Text(
                  'Uploading attachment...',
                  style: TextStyle(color: textSecondary),
                ),
              ],
            ),
          )
        else if (attachments.isEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Text(
              'No attachments yet.',
              style: TextStyle(color: textSecondary),
            ),
          )
        else
          ...attachments.map(
            (att) => AttachmentTile(
              fileName: att.fileName,
              fileType: att.fileType,
              fileUrl: att.fileUrl,
              onDelete: () => onDelete(att.attachmentId),
            ),
          ),
      ],
    );
  }
}
