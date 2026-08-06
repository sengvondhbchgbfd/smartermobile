import 'dart:typed_data';
import 'package:image/image.dart' as img;
import 'package:printing/printing.dart';

class QuotationImageExport {
  static Future<Uint8List> pdfToPng(Uint8List pdfBytes, {double dpi = 200}) async {
    final pages = Printing.raster(pdfBytes, dpi: dpi, pages: [0]);
    final raster = await pages.first;
    return raster.toPng();
  }

  static img.Image composeAsPaperSheet(
    img.Image page, {
    int margin = 50,
    int shadowBlur = 16,
    int shadowOffset = 8,
  }) {
    final canvasW = page.width + margin * 2;
    final canvasH = page.height + margin * 2;

    final surface = img.Image(width: canvasW, height: canvasH, numChannels: 3);
    img.fill(surface, color: img.ColorRgb8(237, 237, 234));

    final shadow = img.Image(width: canvasW, height: canvasH, numChannels: 4);
    img.fillRect(
      shadow,
      x1: margin + shadowOffset,
      y1: margin + shadowOffset,
      x2: margin + shadowOffset + page.width,
      y2: margin + shadowOffset + page.height,
      color: img.ColorRgba8(0, 0, 0, 110),
    );
    img.gaussianBlur(shadow, radius: shadowBlur);
    img.compositeImage(surface, shadow);

    final paper = img.Image(width: page.width, height: page.height, numChannels: 3);
    img.fill(paper, color: img.ColorRgb8(255, 255, 255));
    img.compositeImage(paper, page);
    img.compositeImage(surface, paper, dstX: margin, dstY: margin);
    return surface;
  }

  static Future<Uint8List> pdfToJpg(
    Uint8List pdfBytes, {
    double dpi = 200,
    int quality = 90,
    bool asPaperSheet = true,
  }) async {
    final png = await pdfToPng(pdfBytes, dpi: dpi);
    final decoded = img.decodePng(png);
    if (decoded == null) {
      throw StateError('Failed to decode the rendered PDF page as PNG');
    }
    final finalImage = asPaperSheet ? composeAsPaperSheet(decoded) : decoded;
    return Uint8List.fromList(img.encodeJpg(finalImage, quality: quality));
  }
}