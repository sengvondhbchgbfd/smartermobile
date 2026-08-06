import 'dart:typed_data';
import 'package:flutter/services.dart' show rootBundle;
import 'package:frontendmobile/core/utils/image_opacity_utils.dart';
import 'package:pdf/widgets.dart' as pw;

class QuotationAssetLoader {
  pw.Font? khmerFont;
  pw.Font? cjkFont;
  Uint8List? logoBytes;
  Uint8List? letterheadBytes;
  Uint8List? letterheadWatermarkBytes;
  Uint8List? sealBytes;
  Uint8List? sealWatermarkBytes;

  Future<void> ensureLoaded({Uint8List? sealBytes}) async {
    khmerFont ??= pw.Font.ttf(
      (await rootBundle.load(
        'assets/fonts/KhmerOSbattambang.ttf',
      )).buffer.asByteData(),
    );
    cjkFont ??= pw.Font.ttf(
      (await rootBundle.load(
        'assets/fonts/NotoSansSC-Bold.ttf',
      )).buffer.asByteData(),
    );
    logoBytes ??= (await rootBundle.load(
      'assets/images/duong_chhiv_logo.png',
    )).buffer.asUint8List();

    if (letterheadBytes == null) {
      letterheadBytes = (await rootBundle.load(
        'assets/images/leaterhet.jpg',
      )).buffer.asUint8List();
      letterheadWatermarkBytes = applyOpacity(letterheadBytes!, 0.10);
    }

    if (sealBytes != null && sealBytes != this.sealBytes) {
      this.sealBytes = sealBytes;
      sealWatermarkBytes = applyOpacity(sealBytes, 0.30);
    }
  }
}
