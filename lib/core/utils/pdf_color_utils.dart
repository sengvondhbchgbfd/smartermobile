import 'package:flutter/material.dart' as material;
import 'package:pdf/pdf.dart';
material.Color toMaterialColor(PdfColor c) => material.Color.fromARGB(
      (c.alpha * 255).round(),
      (c.red * 255).round(),
      (c.green * 255).round(),
      (c.blue * 255).round(),
    );