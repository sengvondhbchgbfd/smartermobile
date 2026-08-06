import 'dart:typed_data';
import 'package:image/image.dart' as img;

Uint8List applyOpacity(Uint8List bytes, double opacity) {
  final decoded = img.decodeImage(bytes);
  if (decoded == null) return bytes;
  final faded = decoded.convert(numChannels: 4);
  for (final pixel in faded) {
    pixel.a = (pixel.a * opacity).round();
  }
  return Uint8List.fromList(img.encodePng(faded));
}
