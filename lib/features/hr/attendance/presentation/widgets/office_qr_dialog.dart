import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:saver_gallery/saver_gallery.dart';

class OfficeQrDialog extends StatefulWidget {
  final String? token;
  final String? expiresAt;
  final VoidCallback onRefresh;

  final bool showDownload;
  const OfficeQrDialog({
    super.key,
    required this.token,
    required this.expiresAt,
    required this.onRefresh,
    this.showDownload = true,
  });

  @override
  State<OfficeQrDialog> createState() => _OfficeQrDialogState();
}

class _OfficeQrDialogState extends State<OfficeQrDialog> {
  final GlobalKey _qrBoundaryKey = GlobalKey();
  bool _isSaving = false;

  // ─────────────────────────────────────────────────────────────
  // Permission
  // ─────────────────────────────────────────────────────────────
  Future<bool> _requestPermission() async {
    if (await Permission.photos.isGranted ||
        await Permission.storage.isGranted) {
      return true;
    }
    final photos = await Permission.photos.request();
    if (photos.isGranted) return true;
    // Fallback for Android ≤12
    final storage = await Permission.storage.request();
    return storage.isGranted;
  }

  // ─────────────────────────────────────────────────────────────
  // Save QR to gallery
  // ─────────────────────────────────────────────────────────────
  Future<void> _saveToGallery() async {
    if (_isSaving) return;
    setState(() => _isSaving = true);

    try {
      final permitted = await _requestPermission();
      if (!permitted) {
        _showSnack('Storage permission denied.', isError: true);
        return;
      }
      final boundary =
          _qrBoundaryKey.currentContext?.findRenderObject()
              as RenderRepaintBoundary?;

      if (boundary == null) {
        _showSnack('Could not capture QR image.', isError: true);
        return;
      }

      final ui.Image image = await boundary.toImage(pixelRatio: 3.0);
      final ByteData? byteData = await image.toByteData(
        format: ui.ImageByteFormat.png,
      );

      if (byteData == null) {
        _showSnack('Failed to encode image.', isError: true);
        return;
      }

      final Uint8List pngBytes = byteData.buffer.asUint8List();

      final tempDir = await getTemporaryDirectory();
      final fileName = 'office_qr_${DateTime.now().millisecondsSinceEpoch}.png';
      final file = File('${tempDir.path}/$fileName');
      await file.writeAsBytes(pngBytes);

      // ✅ saver_gallery API
      final result = await SaverGallery.saveFile(
        filePath: file.path,
        fileName: fileName,
        androidRelativePath: 'Pictures/OfficeQR',
        skipIfExists: false,
      );

      _showSnack(
        result.isSuccess ? '✅ QR saved to gallery!' : '❌ Failed to save image.',
        isError: !result.isSuccess,
      );
    } catch (e) {
      _showSnack('Error: $e', isError: true);
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  // ─────────────────────────────────────────────────────────────
  // Snackbar
  // ─────────────────────────────────────────────────────────────
  void _showSnack(String message, {required bool isError}) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : Colors.green,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    final hasToken = widget.token != null && widget.token!.isNotEmpty;

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      insetPadding: const EdgeInsets.symmetric(horizontal: 32, vertical: 48),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // ── Header ──────────────────────────────────────────
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade50,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    Icons.qr_code_2,
                    size: 26,
                    color: Colors.blue.shade700,
                  ),
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Office QR Code',
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Staff scan this to check in',
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close, size: 20),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),

            const SizedBox(height: 20),

            if (!hasToken) ...[
              // ── Empty state ──────────────────────────────────
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 24),
                child: Column(
                  children: [
                    Icon(Icons.qr_code, size: 60, color: Colors.grey),
                    SizedBox(height: 12),
                    Text(
                      'No QR data available.',
                      style: TextStyle(color: Colors.grey),
                    ),
                    Text(
                      'Tap Refresh to generate one.',
                      style: TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                  ],
                ),
              ),
            ] else ...[
              // ── QR widget ────────────────────────────────────
              RepaintBoundary(
                key: _qrBoundaryKey,
                child: Container(
                  color: Colors.white,
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      QrImageView(
                        data: widget.token!,
                        version: QrVersions.auto,
                        size: 200,
                        backgroundColor: Colors.white,
                        errorCorrectionLevel: QrErrorCorrectLevel.H,
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        'OFFICE ATTENDANCE',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.2,
                          color: Colors.black87,
                        ),
                      ),
                      if (widget.expiresAt != null) ...[
                        const SizedBox(height: 4),
                        Text(
                          'Expires: ${widget.expiresAt}',
                          style: const TextStyle(
                            fontSize: 10,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 14),

              // ── Token string ─────────────────────────────────
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: SelectableText(
                  widget.token!,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontFamily: 'monospace',
                    fontSize: 11,
                    color: Colors.black87,
                  ),
                ),
              ),

              const SizedBox(height: 6),

              Text(
                'Long-press token above to copy',
                style: TextStyle(fontSize: 11, color: Colors.grey.shade500),
              ),
            ],

            const SizedBox(height: 20),

            // ── Action buttons ───────────────────────────────────
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    icon: const Icon(Icons.refresh, size: 18),
                    label: const Text('Refresh'),
                    onPressed: widget.onRefresh,
                  ),
                ),

                if (widget.showDownload) ...[
                  const SizedBox(width: 10),
                  Expanded(
                    flex: 2,
                    child: ElevatedButton.icon(
                      icon: _isSaving
                          ? const SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : const Icon(Icons.download_rounded, size: 20),
                      label: Text(_isSaving ? 'Saving…' : 'Save to Gallery'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue.shade700,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 13),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        elevation: 0,
                      ),
                      // ✅ actually calls _saveToGallery
                      onPressed: (!hasToken || _isSaving)
                          ? null
                          : _saveToGallery,
                    ),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }
}
