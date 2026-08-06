import 'package:flutter/material.dart' as material;
import 'package:frontendmobile/core/utils/pdf_color_utils.dart';
import 'package:frontendmobile/features/inventory/quotations/presentation/services/text_to_image.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

class KhmerTextRenderer {
  //////////////////////////////////////////////////////////////////////////////
  ///
  //////////////////////////////////////////////////////////////////////////////
  static final RegExp khmerPattern = RegExp(r'[\u1780-\u17FF\u19E0-\u19FF]');
  static bool hasKhmer(String text) => khmerPattern.hasMatch(text);
  //////////////////////////////////////////////////////////////////////////////
  ///
  //////////////////////////////////////////////////////////////////////////////
  static Future<pw.Widget> autoText(
    ////////////////////////////////////////////////////////////////////////////
    ///
    ////////////////////////////////////////////////////////////////////////////
    String text, {
    double fontSize = 22,
    pw.FontWeight fontWeight = pw.FontWeight.normal,
    PdfColor color = PdfColors.black,
    double maxWidth = 480,
  }) async {
    ////////////////////////////////////////////////////////////////////////////
    ///
    ////////////////////////////////////////////////////////////////////////////
    if (text.isEmpty) return pw.SizedBox.shrink();
    if (!hasKhmer(text)) {
      return pw.Text(
        text,
        style: pw.TextStyle(
          fontSize: fontSize,
          fontWeight: fontWeight,
          color: color,
        ),
      );
    }
    ////////////////////////////////////////////////////////////////////////////
    ///
    ////////////////////////////////////////////////////////////////////////////

    final (bytes, width, height) = await TextToImage.renderSized(
      text,
      fontSize: fontSize,
      fontWeight: fontWeight == pw.FontWeight.bold
          ? material.FontWeight.bold
          : material.FontWeight.normal,
      color: toMaterialColor(color),
      maxWidth: maxWidth,
    );
    ////////////////////////////////////////////////////////////////////////////
    ///
    ////////////////////////////////////////////////////////////////////////////
    return pw.Image(pw.MemoryImage(bytes), width: width, height: height);
  }
}
