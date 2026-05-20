import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

/// Push this screen via:
///   final File? photo = await Navigator.push<File>(
///     context,
///     MaterialPageRoute(builder: (_) => const InAppCameraScreen()),
///   );
///   if (photo != null) { /* use photo */ }

class InAppCameraScreen extends StatefulWidget {
  const InAppCameraScreen({super.key});

  @override
  State<InAppCameraScreen> createState() => _InAppCameraScreenState();
}

class _InAppCameraScreenState extends State<InAppCameraScreen>
    with WidgetsBindingObserver {
  CameraController? _controller;
  List<CameraDescription> _cameras = [];
  int _selectedCamera = 0; // 0 = back, 1 = front
  bool _isReady = false;
  bool _isTaking = false;
  FlashMode _flashMode = FlashMode.off;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _initCamera();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _controller?.dispose();
    super.dispose();
  }

  // Pause/resume camera when app goes background/foreground
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final ctrl = _controller;
    if (ctrl == null || !ctrl.value.isInitialized) return;
    if (state == AppLifecycleState.inactive) {
      ctrl.dispose();
    } else if (state == AppLifecycleState.resumed) {
      _initCameraAt(_selectedCamera);
    }
  }

  // ─── Init ────────────────────────────────────────────────────

  Future<void> _initCamera() async {
    _cameras = await availableCameras();
    if (_cameras.isEmpty) return;
    await _initCameraAt(0);
  }

  Future<void> _initCameraAt(int index) async {
    await _controller?.dispose();
    final ctrl = CameraController(
      _cameras[index],
      ResolutionPreset.high,
      enableAudio: false,
      imageFormatGroup: ImageFormatGroup.jpeg,
    );
    _controller = ctrl;
    try {
      await ctrl.initialize();
      await ctrl.setFlashMode(_flashMode);
      if (mounted) setState(() => _isReady = true);
    } catch (e) {
      debugPrint('Camera init error: $e');
    }
  }

  // ─── Actions ─────────────────────────────────────────────────

  Future<void> _takePhoto() async {
    final ctrl = _controller;
    if (ctrl == null || !ctrl.value.isInitialized || _isTaking) return;
    setState(() => _isTaking = true);
    try {
      final dir = await getTemporaryDirectory();
      final path = p.join(dir.path, '${DateTime.now().millisecondsSinceEpoch}.jpg');
      final xFile = await ctrl.takePicture();
      final file = File(xFile.path);
      await file.copy(path);
      if (mounted) Navigator.pop(context, File(path));
    } catch (e) {
      debugPrint('Take photo error: $e');
      if (mounted) setState(() => _isTaking = false);
    }
  }

  Future<void> _toggleFlash() async {
    final ctrl = _controller;
    if (ctrl == null) return;
    final next = _flashMode == FlashMode.off ? FlashMode.torch : FlashMode.off;
    await ctrl.setFlashMode(next);
    setState(() => _flashMode = next);
  }

  Future<void> _flipCamera() async {
    if (_cameras.length < 2) return;
    setState(() => _isReady = false);
    _selectedCamera = _selectedCamera == 0 ? 1 : 0;
    await _initCameraAt(_selectedCamera);
  }

  // ─── UI ──────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: _isReady ? _buildCamera() : _buildLoading(),
    );
  }

  Widget _buildLoading() {
    return const Center(
      child: CircularProgressIndicator(color: Colors.white),
    );
  }

  Widget _buildCamera() {
    final ctrl = _controller!;
    return Stack(
      fit: StackFit.expand,
      children: [
        // ── Camera preview (fills screen, clipped to aspect ratio) ──
        Center(
          child: CameraPreview(ctrl),
        ),

        // ── Top bar: close + flash ──
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _CircleButton(
                    icon: Icons.close,
                    onTap: () => Navigator.pop(context, null),
                  ),
                  _CircleButton(
                    icon: _flashMode == FlashMode.off
                        ? Icons.flash_off
                        : Icons.flash_on,
                    onTap: _toggleFlash,
                    active: _flashMode != FlashMode.off,
                  ),
                ],
              ),
            ),
          ),
        ),

        // ── Bottom bar: flip + shutter ──
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 32, top: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Placeholder to balance the flip button
                  const SizedBox(width: 56),

                  // ── Shutter button ──
                  GestureDetector(
                    onTap: _takePhoto,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 100),
                      width: _isTaking ? 68 : 72,
                      height: _isTaking ? 68 : 72,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 4),
                        color: _isTaking
                            ? Colors.white54
                            : Colors.white.withOpacity(0.15),
                      ),
                      child: _isTaking
                          ? const Padding(
                              padding: EdgeInsets.all(20),
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            )
                          : const SizedBox.shrink(),
                    ),
                  ),

                  // ── Flip camera ──
                  if (_cameras.length > 1)
                    _CircleButton(
                      icon: Icons.flip_camera_ios_outlined,
                      onTap: _flipCamera,
                    )
                  else
                    const SizedBox(width: 56),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// ─── Small reusable icon button ──────────────────────────────────

class _CircleButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final bool active;

  const _CircleButton({
    required this.icon,
    required this.onTap,
    this.active = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: active
              ? Colors.amber.withOpacity(0.85)
              : Colors.black.withOpacity(0.45),
          border: Border.all(
            color: Colors.white.withOpacity(0.3),
            width: 1,
          ),
        ),
        child: Icon(
          icon,
          color: active ? Colors.black : Colors.white,
          size: 22,
        ),
      ),
    );
  }
}