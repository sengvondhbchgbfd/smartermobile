import 'package:flutter/material.dart';
import 'package:frontendmobile/core/utils/scann/overlay_bracket_painter.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class ScannerView extends StatefulWidget {
  const ScannerView({
    super.key,
    required this.controller,
    required this.errorMessage,
    required this.onDetect,
  });

  final MobileScannerController controller;
  final String? errorMessage;
  final void Function(BarcodeCapture) onDetect;

  @override
  State<ScannerView> createState() => _ScannerViewState();
}

class _ScannerViewState extends State<ScannerView>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animController;
  late final Animation<double> _lineAnimation;
  late final Animation<double> _pulseAnimation;

  static const double _windowSize = 240;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    )..repeat(reverse: true);

    _lineAnimation = Tween<double>(begin: 0, end: _windowSize - 4).animate(
      CurvedAnimation(parent: _animController, curve: Curves.easeInOut),
    );

    _pulseAnimation = Tween<double>(begin: 0.55, end: 1.0).animate(
      CurvedAnimation(parent: _animController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
      child: Column(
        children: [
          const SizedBox(height: 8),
          const Text(
            'Scan the office QR code',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'Point your camera at the QR code',
            style: TextStyle(color: Colors.white54, fontSize: 13),
          ),
          const SizedBox(height: 24),
          Expanded(
            child: Stack(
              alignment: Alignment.center,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: MobileScanner(
                    controller: widget.controller,
                    onDetect: widget.onDetect,
                  ),
                ),
                IgnorePointer(
                  child: CustomPaint(
                    size: const Size(double.infinity, double.infinity),
                    painter: OverlayPainter(windowSize: _windowSize),
                  ),
                ),
                // ✅ Animated pulsing corner brackets
                AnimatedBuilder(
                  animation: _pulseAnimation,
                  builder: (context, _) => CustomPaint(
                    size: const Size(_windowSize, _windowSize),
                    painter: BracketPainter(
                      color: Colors.white.withOpacity(_pulseAnimation.value),
                    ),
                  ),
                ),
                IgnorePointer(
                  child: AnimatedBuilder(
                    animation: _lineAnimation,
                    builder: (context, _) {
                      return SizedBox(
                        width: _windowSize,
                        height: _windowSize,
                        child: Stack(
                          children: [
                            Positioned(
                              top: _lineAnimation.value,
                              left: 4,
                              right: 4,
                              child: Container(
                                height: 2.5,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(2),
                                  gradient: LinearGradient(
                                    colors: [
                                      Colors.greenAccent.withOpacity(0),
                                      Colors.greenAccent,
                                      Colors.greenAccent.withOpacity(0),
                                    ],
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.greenAccent.withOpacity(
                                        0.6,
                                      ),
                                      blurRadius: 8,
                                      spreadRadius: 1,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          if (widget.errorMessage != null)
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
                      widget.errorMessage!,
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
        ],
      ),
    );
  }
}
