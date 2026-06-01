import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:frontendmobile/core/utils/attendance_location_helper.dart';
import 'package:frontendmobile/core/utils/attendance_token_session.dart';
import 'package:frontendmobile/features/hr/attendance/presentation/providers/attendance_notifier.dart';

class AttendanceScanSheet extends ConsumerStatefulWidget {
  const AttendanceScanSheet({
    super.key,
    required this.isCheckIn,
    required this.companyId,
  });

  final bool isCheckIn;
  final String companyId;

  static Future<bool?> show({
    required BuildContext context,
    required bool isCheckIn,
    required String companyId,
  }) {
    return showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) =>
          AttendanceScanSheet(isCheckIn: isCheckIn, companyId: companyId),
    );
  }

  @override
  ConsumerState<AttendanceScanSheet> createState() =>
      _AttendanceScanSheetState();
}

class _AttendanceScanSheetState extends ConsumerState<AttendanceScanSheet> {
  final MobileScannerController _scanner = MobileScannerController(
    detectionSpeed: DetectionSpeed.normal,
    facing: CameraFacing.back,
  );

  bool _processing = false;
  bool _done = false;
  String? _errorMessage;

  @override
  void dispose() {
    _scanner.dispose();
    super.dispose();
  }

  // ── QR detected ───────────────────────────────────────────────────────────

  Future<void> _onDetect(BarcodeCapture capture) async {
    if (_processing || _done || !mounted) return;

    final raw = capture.barcodes.firstOrNull?.rawValue;
    if (raw == null || raw.isEmpty) return;

    setState(() {
      _processing = true;
      _errorMessage = null;
    });
    await _scanner.stop();

    final session = AttendanceTokenSession.instance;
    if (!session.isValid) {
      _setError('Session expired. Please authenticate again.');
      if (mounted) Navigator.pop(context, false);
      return;
    }

    ////////////////////////////////////////////////////////////////////////////
    // GPS
    ////////////////////////////////////////////////////////////////////////////
    final position = await AttendanceLocationHelper.getCurrentPosition(context);
    if (!mounted) return;
    if (position == null) {
      _setError('Could not get location. Please enable GPS and try again.');
      await _scanner.start();
      setState(() => _processing = false);
      return;
    }
    ////////////////////////////////////////////////////////////////////////////
    // Check in / out
    ////////////////////////////////////////////////////////////////////////////

    final notifier = ref.read(scanAttendanceProvider.notifier);
    if (widget.isCheckIn) {
      await notifier.checkIn(
        scanToken: session.scanToken!,
        officeQrToken: session.officeQrToken!,
        latitude: position.latitude.toString(),
        longitude: position.longitude.toString(),
        companyId: widget.companyId,
      );
    } else {
      await notifier.checkOut(
        scanToken: session.scanToken!,
        officeQrToken: session.officeQrToken!,
        latitude: position.latitude.toString(),
        longitude: position.longitude.toString(),
        companyId: widget.companyId,
      );
    }

    if (!mounted) return;

    final error = ref.read(scanAttendanceProvider).value?.error;
    if (error != null) {
      _setError(error);
      await _scanner.start();
      setState(() => _processing = false);
      return;
    }
    ////////////////////////////////////////////////////////////////////////////
    // ── Success ──────────────────────────────────────────────────────────────
    ////////////////////////////////////////////////////////////////////////////

    setState(() {
      _processing = false;
      _done = true;
    });
    await Future.delayed(const Duration(milliseconds: 2000));
    if (mounted) Navigator.pop(context, true);
  }

  void _setError(String msg) {
    if (!mounted) return;
    setState(() => _errorMessage = msg);
  }

  // ── Build ─────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final isCheckIn = widget.isCheckIn;
    final accentColor = isCheckIn ? Colors.green : Colors.red;
    final label = isCheckIn ? 'Check In' : 'Check Out';

    return DraggableScrollableSheet(
      initialChildSize: 0.92,
      minChildSize: 0.6,
      maxChildSize: 0.95,
      builder: (_, __) => Container(
        decoration: const BoxDecoration(
          color: Color(0xFF1A1A1A),
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          children: [
            // ── Drag handle ──────────────────────────────────────────────
            const SizedBox(height: 12),
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.white24,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 20),

            // ── Header ───────────────────────────────────────────────────
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: accentColor.withOpacity(0.15),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    isCheckIn ? Icons.login : Icons.logout,
                    color: accentColor,
                    size: 22,
                  ),
                ),
                const SizedBox(width: 10),
                Text(
                  'Scan QR to $label',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            const Text(
              'Point your camera at the office QR code',
              style: TextStyle(color: Colors.white54, fontSize: 13),
            ),
            const SizedBox(height: 24),

            // ── Scanner OR success ───────────────────────────────────────
            Expanded(
              child: _done
                  ? _SuccessView(isCheckIn: isCheckIn)
                  : _ScannerView(
                      controller: _scanner,
                      processing: _processing,
                      accentColor: accentColor,
                      errorMessage: _errorMessage,
                      onDetect: _onDetect,
                    ),
            ),

            // ── Cancel ───────────────────────────────────────────────────
            if (!_done)
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 4, 24, 36),
                child: SizedBox(
                  width: double.infinity,
                  child: TextButton(
                    onPressed: () => Navigator.pop(context, false),
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.white38,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    child: const Text('Cancel', style: TextStyle(fontSize: 15)),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

// ── Scanner view ──────────────────────────────────────────────────────────────

class _ScannerView extends StatelessWidget {
  const _ScannerView({
    required this.controller,
    required this.processing,
    required this.accentColor,
    required this.errorMessage,
    required this.onDetect,
  });

  final MobileScannerController controller;
  final bool processing;
  final Color accentColor;
  final String? errorMessage;
  final void Function(BarcodeCapture) onDetect;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: [
          // ── Camera box ─────────────────────────────────────────────────
          Expanded(
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Camera feed
                ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: MobileScanner(
                    controller: controller,
                    onDetect: onDetect,
                  ),
                ),

                // Dark overlay with transparent center window
                IgnorePointer(
                  child: CustomPaint(
                    size: const Size(double.infinity, double.infinity),
                    painter: _OverlayPainter(windowSize: 220),
                  ),
                ),

                // Corner brackets
                CustomPaint(
                  size: const Size(220, 220),
                  painter: _BracketPainter(color: accentColor),
                ),

                // Processing spinner
                if (processing)
                  Container(
                    width: 220,
                    height: 220,
                    decoration: BoxDecoration(
                      color: Colors.black54,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          CircularProgressIndicator(color: Colors.white),
                          SizedBox(height: 12),
                          Text(
                            'Processing…',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // ── Error message ──────────────────────────────────────────────
          if (errorMessage != null)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.red.withOpacity(0.15),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.red.withOpacity(0.4)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.error_outline, color: Colors.red, size: 18),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      errorMessage!,
                      style: const TextStyle(color: Colors.red, fontSize: 13),
                    ),
                  ),
                ],
              ),
            )
          else
            const Text(
              'Align the QR code within the frame',
              style: TextStyle(color: Colors.white38, fontSize: 12),
            ),

          const SizedBox(height: 8),
        ],
      ),
    );
  }
}

// ── Success view ──────────────────────────────────────────────────────────────

class _SuccessView extends StatelessWidget {
  const _SuccessView({required this.isCheckIn});
  final bool isCheckIn;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 96,
            height: 96,
            decoration: BoxDecoration(
              color: Colors.green.withOpacity(0.15),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.check_circle_outline,
              color: Colors.green,
              size: 60,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            isCheckIn ? '✅ Checked In!' : '✅ Checked Out!',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            isCheckIn
                ? 'Your attendance has been recorded.'
                : 'Your check-out has been recorded.',
            style: const TextStyle(color: Colors.white54, fontSize: 14),
          ),
          const SizedBox(height: 32),
          const SizedBox(
            width: 28,
            height: 28,
            child: CircularProgressIndicator(
              strokeWidth: 2.5,
              color: Colors.white24,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Closing…',
            style: TextStyle(color: Colors.white24, fontSize: 12),
          ),
        ],
      ),
    );
  }
}

// ── Painters ──────────────────────────────────────────────────────────────────

class _OverlayPainter extends CustomPainter {
  const _OverlayPainter({required this.windowSize});
  final double windowSize;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.black.withOpacity(0.55);
    final cx = size.width / 2;
    final cy = size.height / 2;
    final half = windowSize / 2;

    // Four dark rectangles around the transparent center
    canvas.drawRect(Rect.fromLTRB(0, 0, size.width, cy - half), paint);
    canvas.drawRect(
      Rect.fromLTRB(0, cy + half, size.width, size.height),
      paint,
    );
    canvas.drawRect(Rect.fromLTRB(0, cy - half, cx - half, cy + half), paint);
    canvas.drawRect(
      Rect.fromLTRB(cx + half, cy - half, size.width, cy + half),
      paint,
    );
  }

  @override
  bool shouldRepaint(_OverlayPainter old) => old.windowSize != windowSize;
}

class _BracketPainter extends CustomPainter {
  const _BracketPainter({required this.color});
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 3.5
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    const len = 30.0;
    final w = size.width;
    final h = size.height;

    // Top-left
    canvas.drawLine(const Offset(0, len), const Offset(0, 0), paint);
    canvas.drawLine(const Offset(0, 0), const Offset(len, 0), paint);
    // Top-right
    canvas.drawLine(Offset(w - len, 0), Offset(w, 0), paint);
    canvas.drawLine(Offset(w, 0), Offset(w, len), paint);
    // Bottom-left
    canvas.drawLine(Offset(0, h - len), Offset(0, h), paint);
    canvas.drawLine(Offset(0, h), Offset(len, h), paint);
    // Bottom-right
    canvas.drawLine(Offset(w - len, h), Offset(w, h), paint);
    canvas.drawLine(Offset(w, h - len), Offset(w, h), paint);
  }

  @override
  bool shouldRepaint(_BracketPainter old) => old.color != color;
}
