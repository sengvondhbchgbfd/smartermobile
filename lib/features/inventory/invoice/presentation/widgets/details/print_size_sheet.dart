import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:frontendmobile/core/themes/app_pallets.dart';
import 'print_size_tile.dart';
import 'print_size_options.dart';

Future<void> showPrintSizeSheet(
  BuildContext context, {
  required Future<PdfPageFormat?> Function() promptCustomSize,
  required void Function(PdfPageFormat format) onFormatChosen,
}) {
  final isDark = Theme.of(context).brightness == Brightness.dark;
  final sheetColor = isDark ? Pallets.surfaceOverlay : Pallets.surfaceLight;
  final textPrimary = isDark ? Pallets.textPrimaryDark : Pallets.textPrimaryLight;
  final textSecondary = isDark ? Pallets.textSecondaryDark : Pallets.textSecondaryLight;
  final borderColor = isDark ? Pallets.borderDark : Pallets.borderLight;

  return showModalBottomSheet(
    context: context,
    backgroundColor: sheetColor,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (ctx) => SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(color: borderColor, borderRadius: BorderRadius.circular(2)),
              ),
            ),
            Text('Print invoice', style: TextStyle(color: textPrimary, fontSize: 17, fontWeight: FontWeight.w700)),
            const SizedBox(height: 2),
            Text('Choose a paper size', style: TextStyle(color: textSecondary, fontSize: 13)),
            const SizedBox(height: 8),
            ...printSizeOptions.map(
              (opt) => PrintSizeTile(
                option: opt,
                textPrimary: textPrimary,
                textSecondary: textSecondary,
                onTap: () async {
                  Navigator.pop(ctx);
                  if (opt.size == PrintSize.custom) {
                    final format = await promptCustomSize();
                    if (format == null) return;
                    onFormatChosen(format);
                  } else {
                    onFormatChosen(formatForPrintSize(opt.size));
                  }
                },
              ),
            ),
          ],
        ),
      ),
    ),
  );
}