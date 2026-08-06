import 'package:flutter/material.dart';
import 'package:frontendmobile/core/themes/app_pallets.dart';

class ReportExportMenu extends StatelessWidget {
  const ReportExportMenu({
    super.key,
    required this.exporting,
    required this.onSelected,
  });

  final bool exporting;
  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) {
    if (exporting) {
      return const Padding(
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: SizedBox(
          width: 18,
          height: 18,
          child: CircularProgressIndicator(strokeWidth: 2),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.only(right: 4),
      child: PopupMenuButton<String>(
        icon: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Pallets.blurple.withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(
            Icons.ios_share_rounded,
            size: 18,
            color: Pallets.blurple,
          ),
        ),
        tooltip: 'Export',
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        onSelected: onSelected,
        itemBuilder: (_) => const [
          PopupMenuItem(
            value: 'excel',
            child: Row(
              children: [
                Icon(Icons.grid_on_rounded, size: 18),
                SizedBox(width: 10),
                Text('Export to Excel'),
              ],
            ),
          ),
          PopupMenuItem(
            value: 'pdf',
            child: Row(
              children: [
                Icon(Icons.picture_as_pdf_rounded, size: 18),
                SizedBox(width: 10),
                Text('Export to PDF'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
