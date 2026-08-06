import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';

enum PrintSize { a4, letter, thermal80, thermal58, custom }

class PrintSizeOption {
  final PrintSize size;
  final String label;
  final String subtitle;
  final IconData icon;
  const PrintSizeOption({required this.size, required this.label, required this.subtitle, required this.icon});
}

const printSizeOptions = [
  PrintSizeOption(size: PrintSize.a4, label: 'A4', subtitle: '210 × 297 mm — standard office printer', icon: Icons.description_outlined),
  PrintSizeOption(size: PrintSize.letter, label: 'Letter', subtitle: '216 × 279 mm — US standard', icon: Icons.description_outlined),
  PrintSizeOption(size: PrintSize.thermal80, label: '80mm Receipt', subtitle: 'Thermal printer roll', icon: Icons.receipt_long_outlined),
  PrintSizeOption(size: PrintSize.thermal58, label: '58mm Receipt', subtitle: 'Compact thermal printer roll', icon: Icons.receipt_outlined),
  PrintSizeOption(size: PrintSize.custom, label: 'Custom size', subtitle: 'Enter your own width and height (mm)', icon: Icons.straighten_outlined),
];

PdfPageFormat formatForPrintSize(PrintSize size) {
  switch (size) {
    case PrintSize.a4:
      return PdfPageFormat.a4;
    case PrintSize.letter:
      return PdfPageFormat.letter;
    case PrintSize.thermal80:
      return PdfPageFormat(80 * PdfPageFormat.mm, double.infinity, marginAll: 6 * PdfPageFormat.mm);
    case PrintSize.thermal58:
      return PdfPageFormat(58 * PdfPageFormat.mm, double.infinity, marginAll: 4 * PdfPageFormat.mm);
    case PrintSize.custom:
      return PdfPageFormat.a4;
  }
}