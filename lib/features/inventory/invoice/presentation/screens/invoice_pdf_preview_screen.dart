import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';
import 'package:frontendmobile/core/themes/app_pallets.dart';

class InvoicePdfPreviewScreen extends StatefulWidget {
  final String invoiceName;
  final Future<Uint8List> Function(PdfPageFormat format) buildPdf;
  final PdfPageFormat initialFormat;

  const InvoicePdfPreviewScreen({
    required this.invoiceName,
    required this.buildPdf,
    required this.initialFormat,
    super.key,
  });

  @override
  State<InvoicePdfPreviewScreen> createState() =>
      _InvoicePdfPreviewScreenState();
}

class _InvoicePdfPreviewScreenState extends State<InvoicePdfPreviewScreen> {
  Uint8List? _pdfBytes;
  final List<Uint8List> _pageImages = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _render();
  }

  Future<void> _render() async {
    final bytes = await widget.buildPdf(widget.initialFormat);

    await for (final page in Printing.raster(bytes, dpi: 220)) {
      _pageImages.add(await page.toPng());
    }

    if (!mounted) return;
    setState(() {
      _pdfBytes = bytes;
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final aspectRatio =
        widget.initialFormat.width / widget.initialFormat.height;

    final isDark = Theme.of(context).brightness == Brightness.dark;
    final Color bgColor = isDark
        ? Pallets.backgroundDark
        : Pallets.backgroundLight;
    final Color textPrimary = isDark
        ? Pallets.textPrimaryDark
        : Pallets.textPrimaryLight;

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: bgColor,
        foregroundColor: textPrimary,
        title: Text(widget.invoiceName),
        actions: [
          IconButton(
            tooltip: 'Share',
            icon: const Icon(Icons.share_outlined),
            onPressed: _pdfBytes == null
                ? null
                : () => Printing.sharePdf(
                    bytes: _pdfBytes!,
                    filename: '${widget.invoiceName}.pdf',
                  ),
          ),
          IconButton(
            tooltip: 'Print',
            icon: const Icon(Icons.print_outlined),
            onPressed: _pdfBytes == null
                ? null
                : () => Printing.layoutPdf(
                    name: widget.invoiceName,
                    onLayout: (_) async => _pdfBytes!,
                    format: widget.initialFormat,
                  ),
          ),
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : PageView.builder(
              itemCount: _pageImages.length,
              itemBuilder: (context, index) => InteractiveViewer(
                minScale: 1.0,
                maxScale: 6.0,
                child: Center(
                  child: AspectRatio(
                    aspectRatio: aspectRatio,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors
                            .white, // page itself stays white — paper color, not app theme
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(
                              isDark ? 0.5 : 0.25,
                            ),
                            blurRadius: 8,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Image.memory(
                        _pageImages[index],
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ),
              ),
            ),
    );
  }
}
