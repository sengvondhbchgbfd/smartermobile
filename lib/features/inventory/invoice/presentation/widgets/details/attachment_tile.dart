import 'package:flutter/material.dart';
import 'package:frontendmobile/core/themes/app_pallets.dart';

class AttachmentTile extends StatelessWidget {
  final String? fileName;
  final String? fileType;
  final String? fileUrl;
  final VoidCallback onDelete;

  const AttachmentTile({
    super.key,
    required this.fileName,
    required this.fileType,
    required this.fileUrl,
    required this.onDelete,
  });

  bool get _isImage {
    final t = fileType?.toLowerCase();
    return t == 'png' || t == 'jpg' || t == 'jpeg' || t == 'webp';
  }

  IconData get _icon {
    switch (fileType?.toLowerCase()) {
      case 'pdf':
        return Icons.picture_as_pdf_outlined;
      case 'png':
      case 'jpg':
      case 'jpeg':
        return Icons.image_outlined;
      default:
        return Icons.insert_drive_file_outlined;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardColor = isDark ? Pallets.surfaceCard : Pallets.surfaceLight;
    final borderColor = isDark ? Pallets.borderDark : Pallets.borderLight;
    final textPrimary = isDark
        ? Pallets.textPrimaryDark
        : Pallets.textPrimaryLight;
    final textSecondary = isDark
        ? Pallets.textSecondaryDark
        : Pallets.textSecondaryLight;
    final accent = Pallets.blurple;
    final errorColor = Pallets.error;

    return Card(
      elevation: 0,
      color: cardColor,
      margin: const EdgeInsets.only(bottom: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: BorderSide(color: borderColor),
      ),
      child: ListTile(
        leading: _isImage && fileUrl != null
            ? ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  fileUrl!,
                  width: 44,
                  height: 44,
                  fit: BoxFit.cover,
                  loadingBuilder: (context, child, progress) {
                    if (progress == null) return child;
                    return SizedBox(
                      width: 44,
                      height: 44,
                      child: Center(
                        child: SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: accent,
                          ),
                        ),
                      ),
                    );
                  },
                  errorBuilder: (context, error, stack) =>
                      Icon(_icon, color: accent),
                ),
              )
            : CircleAvatar(
                backgroundColor: Pallets.infoTint,
                child: Icon(_icon, color: accent),
              ),
        title: Text(
          fileName ?? 'Attachment',
          overflow: TextOverflow.ellipsis,
          style: TextStyle(color: textPrimary),
        ),
        subtitle: Text(fileType ?? '', style: TextStyle(color: textSecondary)),
        trailing: IconButton(
          icon: Icon(Icons.delete_outline, color: errorColor),
          onPressed: onDelete,
        ),
      ),
    );
  }
}
