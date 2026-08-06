import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

class KhmerText {
  //////////////////////////////////////////////
  ///
  /////////////////////////////////////////////
  static bool _khmerRegistered = false;
  static bool _cjkRegistered = false;
  static const _khmerFamily = 'InvoiceKhmerFont';
  static const _cjkFamily = 'InvoiceCjkFont';
  //////////////////////////////////////////////
  ///  LOADING KHMER FONT
  /////////////////////////////////////////////
  static Future<void> ensureRegistered(Uint8List fontBytes) async {
    if (_khmerRegistered) return;
    await ui.loadFontFromList(fontBytes, fontFamily: _khmerFamily);
    _khmerRegistered = true;
  }
  //////////////////////////////////////////////
  ///  LOADING FONT CHIENES
  /////////////////////////////////////////////

  static Future<void> ensureCjkRegistered(Uint8List fontBytes) async {
    if (_cjkRegistered) return;
    await ui.loadFontFromList(fontBytes, fontFamily: _cjkFamily);
    _cjkRegistered = true;
  }
  //////////////////////////////////////////////
  ///
  /////////////////////////////////////////////

  static Future<pw.Widget> render(
    ///////////////////////////////////////////
    ///
    //////////////////////////////////////////
    String text, {
    required double fontSize,
    bool bold = false,
    PdfColor color = PdfColors.black,
    double scale = 6,
    double? maxWidthPt,
    bool useCjkFont = false,
  }) async {
    final uiColor = ui.Color.fromARGB(
      255,
      (color.red * 255).round(),
      (color.green * 255).round(),
      (color.blue * 255).round(),
    );
    ///////////////////////////////////////////
    ///
    //////////////////////////////////////////

    final layoutWidthPx = (maxWidthPt ?? 1000) * scale;
    final builder =
        ui.ParagraphBuilder(
            ui.ParagraphStyle(
              fontFamily: useCjkFont ? _cjkFamily : _khmerFamily,
              fontSize: fontSize * scale,
            ),
          )
          ..pushStyle(
            ui.TextStyle(
              color: uiColor,
              fontWeight: bold ? ui.FontWeight.bold : ui.FontWeight.normal,
            ),
          )
          ..addText(text);

    final paragraph = builder.build()
      ..layout(ui.ParagraphConstraints(width: layoutWidthPx));

    final lineWidth = paragraph.longestLine.ceil().clamp(
      1,
      layoutWidthPx.toInt(),
    );

    ///////////////////////////////////////////
    ///
    //////////////////////////////////////////

    final lineHeight = paragraph.height.ceil().clamp(1, 100000);
    final padY = (fontSize * scale * 0.5).ceil();
    final padX = (fontSize * scale * 0.15).ceil();
    final width = lineWidth + padX * 2;
    final height = lineHeight + padY * 2;
    final recorder = ui.PictureRecorder();

    ///////////////////////////////////////////
    ///
    //////////////////////////////////////////
    final canvas = ui.Canvas(
      recorder,
      ui.Rect.fromLTWH(0, 0, width.toDouble(), height.toDouble()),
    );
    ///////////////////////////////////////////
    ///
    //////////////////////////////////////////
    canvas.drawParagraph(
      paragraph,
      ui.Offset(padX.toDouble(), padY.toDouble()),
    );
    ///////////////////////////////////////////
    ///
    //////////////////////////////////////////
    final picture = recorder.endRecording();
    final image = await picture.toImage(width, height);
    final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    final png = byteData!.buffer.asUint8List();
    ///////////////////////////////////////////
    ///
    //////////////////////////////////////////
    return pw.Image(
      pw.MemoryImage(png),
      width: width / scale,
      height: height / scale,
    );
    ///////////////////////////////////////////
    ///
    //////////////////////////////////////////
  }
}
