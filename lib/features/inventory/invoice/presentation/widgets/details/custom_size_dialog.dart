import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:frontendmobile/core/themes/app_pallets.dart';

Future<PdfPageFormat?> showCustomSizeDialog(BuildContext context) {
  final widthCtrl = TextEditingController(text: '100');
  final heightCtrl = TextEditingController(text: '150');
  final isDark = Theme.of(context).brightness == Brightness.dark;
  final dialogBg = isDark ? Pallets.surfaceCard : Pallets.surfaceLight;
  final textPrimary = isDark ? Pallets.textPrimaryDark : Pallets.textPrimaryLight;
  final textSecondary = isDark ? Pallets.textSecondaryDark : Pallets.textSecondaryLight;
  final borderColor = isDark ? Pallets.borderDark : Pallets.borderLight;
  final accent = Pallets.blurple;

  final inputBorder = OutlineInputBorder(
    borderRadius: BorderRadius.circular(10),
    borderSide: BorderSide(color: borderColor),
  );

  return showDialog<PdfPageFormat>(
    context: context,
    builder: (ctx) => AlertDialog(
      backgroundColor: dialogBg,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: Text('Custom paper size', style: TextStyle(color: textPrimary)),
      content: Row(
        children: [
          Expanded(
            child: TextField(
              controller: widthCtrl,
              style: TextStyle(color: textPrimary),
              cursorColor: accent,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: InputDecoration(
                labelText: 'Width (mm)',
                labelStyle: TextStyle(color: textSecondary),
                border: inputBorder,
                enabledBorder: inputBorder,
                focusedBorder: inputBorder.copyWith(
                  borderSide: BorderSide(color: accent, width: 1.5),
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: TextField(
              controller: heightCtrl,
              style: TextStyle(color: textPrimary),
              cursorColor: accent,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: InputDecoration(
                labelText: 'Height (mm)',
                labelStyle: TextStyle(color: textSecondary),
                border: inputBorder,
                enabledBorder: inputBorder,
                focusedBorder: inputBorder.copyWith(
                  borderSide: BorderSide(color: accent, width: 1.5),
                ),
              ),
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(ctx),
          style: TextButton.styleFrom(foregroundColor: textSecondary),
          child: const Text('Cancel'),
        ),
        FilledButton(
          style: FilledButton.styleFrom(
            backgroundColor: accent,
            foregroundColor: Pallets.onAccent,
          ),
          onPressed: () {
            final w = double.tryParse(widthCtrl.text) ?? 100;
            final h = double.tryParse(heightCtrl.text) ?? 150;
            Navigator.pop(
              ctx,
              PdfPageFormat(w * PdfPageFormat.mm, h * PdfPageFormat.mm, marginAll: 6 * PdfPageFormat.mm),
            );
          },
          child: const Text('Use size'),
        ),
      ],
    ),
  );
}