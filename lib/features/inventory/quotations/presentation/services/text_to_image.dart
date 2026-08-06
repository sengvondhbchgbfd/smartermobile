import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';

class TextToImage {
  static Future<Uint8List> render(
    String text, {
    required double fontSize,
    Color color = Colors.black,
    FontWeight fontWeight = FontWeight.normal,
    String? fontFamily,
    double maxWidth = 600,
    double pixelRatio = 3.0, 
  }) async {
    final textSpan = TextSpan(
      text: text,
      style: TextStyle(
        fontSize: fontSize,
        color: color,
        fontWeight: fontWeight,
        fontFamily: fontFamily,
      ),
    );
    final painter = TextPainter(
      text: textSpan,
      textDirection: TextDirection.ltr,
      maxLines: null,
    );
    painter.layout(maxWidth: maxWidth);

    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder);
    painter.paint(canvas, Offset.zero);

    final picture = recorder.endRecording();
    final image = await picture.toImage(
      (painter.width * pixelRatio).ceil(),
      (painter.height * pixelRatio).ceil(),
    );

    final recorder2 = ui.PictureRecorder();
    final canvas2 = Canvas(recorder2)..scale(pixelRatio);
    painter.paint(canvas2, Offset.zero);
    final picture2 = recorder2.endRecording();
    final image2 = await picture2.toImage(
      (painter.width * pixelRatio).ceil(),
      (painter.height * pixelRatio).ceil(),
    );

    final byteData = await image2.toByteData(format: ui.ImageByteFormat.png);
    image.dispose();
    image2.dispose();
    return byteData!.buffer.asUint8List();
  }

  static Future<(Uint8List bytes, double width, double height)> renderSized(
    String text, {
    required double fontSize,
    Color color = Colors.black,
    FontWeight fontWeight = FontWeight.normal,
    String? fontFamily,
    double maxWidth = 600,
    double pixelRatio = 3.0,
  }) async {
    final textSpan = TextSpan(
      text: text,
      style: TextStyle(
        fontSize: fontSize,
        color: color,
        fontWeight: fontWeight,
        fontFamily: fontFamily,
      ),
    );
    final painter = TextPainter(
      text: textSpan,
      textDirection: TextDirection.ltr,
      maxLines: null,
    )..layout(maxWidth: maxWidth);

    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder)..scale(pixelRatio);
    painter.paint(canvas, Offset.zero);
    final picture = recorder.endRecording();
    final image = await picture.toImage(
      (painter.width * pixelRatio).ceil(),
      (painter.height * pixelRatio).ceil(),
    );
    final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    image.dispose();

    return (byteData!.buffer.asUint8List(), painter.width, painter.height);
  }
}
