import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:ui' as ui;

// ─────────────────────────────────────────────────────────────────────────────
// Result model
// ─────────────────────────────────────────────────────────────────────────────

class OfficeLocationResult {
  const OfficeLocationResult({required this.latitude, required this.longitude});

  final double latitude;
  final double longitude;
}

// ─────────────────────────────────────────────────────────────────────────────
// Office Location Picker
// ─────────────────────────────────────────────────────────────────────────────

class OfficeLocationPicker extends StatefulWidget {
  const OfficeLocationPicker({super.key, this.initial});

  final LatLng? initial;

  static Future<OfficeLocationResult?> show(
    BuildContext context, {
    LatLng? initial,
  }) {
    return Navigator.push<OfficeLocationResult>(
      context,
      MaterialPageRoute(
        fullscreenDialog: true,
        builder: (_) => OfficeLocationPicker(initial: initial),
      ),
    );
  }

  @override
  State<OfficeLocationPicker> createState() => _OfficeLocationPickerState();
}

class _OfficeLocationPickerState extends State<OfficeLocationPicker> {
  late final MapController _mapController;
  late LatLng _picked;

  bool _locating = false;
  String? _locationError;

  static const _defaultCenter = LatLng(11.5564, 104.9282);
  static const _defaultZoom = 15.0;

  @override
  void initState() {
    super.initState();
    _mapController = MapController();
    _picked = widget.initial ?? _defaultCenter;
  }

  @override
  void dispose() {
    _mapController.dispose();
    super.dispose();
  }

  Future<void> _useMyLocation() async {
    setState(() {
      _locating = true;
      _locationError = null;
    });

    try {
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }
      if (permission == LocationPermission.deniedForever ||
          permission == LocationPermission.denied) {
        setState(() {
          _locationError = 'Location permission denied.';
          _locating = false;
        });
        return;
      }

      final serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        setState(() {
          _locationError = 'Location services are disabled.';
          _locating = false;
        });
        return;
      }

      final pos = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      if (!mounted) return;

      final ll = LatLng(pos.latitude, pos.longitude);
      setState(() {
        _picked = ll;
        _locating = false;
      });

      _mapController.move(ll, _defaultZoom);
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _locationError = 'Could not get location: $e';
        _locating = false;
      });
    }
  }

  void _confirm() {
    Navigator.pop(
      context,
      OfficeLocationResult(
        latitude: _picked.latitude,
        longitude: _picked.longitude,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    // Respect system bottom insets (home bar, keyboard, etc.)
    final bottomInset = MediaQuery.of(context).padding.bottom;
    // Total bottom panel height: coords card + gps button + spacing
    final bottomPanelHeight = 56.0 + 12.0 + 52.0 + 12.0 + bottomInset;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Set Office Location'),
        actions: [
          TextButton.icon(
            onPressed: _confirm,
            icon: const Icon(Icons.check),
            label: const Text(
              'Confirm',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          // ── Map ───────────────────────────────────────────────────────────
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: _picked,
              initialZoom: _defaultZoom,
              onTap: (_, ll) => setState(() => _picked = ll),
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.example.frontendmobile',
              ),
              CircleLayer(
                circles: [
                  CircleMarker(
                    point: _picked,
                    radius: 80,
                    useRadiusInMeter: true,
                    color: colorScheme.primary.withValues(alpha: 0.15),
                    borderColor: colorScheme.primary.withValues(alpha: 0.5),
                    borderStrokeWidth: 2,
                  ),
                ],
              ),
              MarkerLayer(
                markers: [
                  Marker(
                    point: _picked,
                    width: 48,
                    height: 58,
                    alignment: Alignment.topCenter,
                    child: const _OfficePin(),
                  ),
                ],
              ),
            ],
          ),

          // ── Instruction banner ────────────────────────────────────────────
          Positioned(top: 12, left: 16, right: 16, child: _InstructionBanner()),

          // ── Zoom controls — placed above bottom panel ─────────────────────
          Positioned(
            right: 16,
            bottom: bottomPanelHeight + 12,
            child: _ZoomControls(mapController: _mapController),
          ),

          // ── Bottom panel: coords + GPS button ─────────────────────────────
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: _BottomPanel(
              picked: _picked,
              isLocating: _locating,
              error: _locationError,
              onGpsTap: _useMyLocation,
              bottomInset: bottomInset,
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Bottom panel — coords card + GPS button in a single surface
// ─────────────────────────────────────────────────────────────────────────────

class _BottomPanel extends StatelessWidget {
  const _BottomPanel({
    required this.picked,
    required this.isLocating,
    required this.error,
    required this.onGpsTap,
    required this.bottomInset,
  });

  final LatLng picked;
  final bool isLocating;
  final String? error;
  final VoidCallback onGpsTap;
  final double bottomInset;

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;

    return Container(
      padding: EdgeInsets.fromLTRB(16, 14, 16, 14 + bottomInset),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.10),
            blurRadius: 16,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Drag handle
          Container(
            width: 36,
            height: 4,
            margin: const EdgeInsets.only(bottom: 12),
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // Coordinates row
          Row(
            children: [
              Icon(Icons.location_on, color: primary, size: 18),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Selected Location',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey.shade500,
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: 1),
                    Text(
                      'Lat ${picked.latitude.toStringAsFixed(6)}  ·  Lng ${picked.longitude.toStringAsFixed(6)}',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // Error message
          if (error != null) ...[
            Container(
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.red.shade50,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.red.shade200),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.error_outline,
                    color: Colors.red.shade600,
                    size: 16,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      error!,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.red.shade700,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],

          // GPS button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: isLocating ? null : onGpsTap,
              style: ElevatedButton.styleFrom(
                backgroundColor: primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 13),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
              ),
              icon: isLocating
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : const Icon(Icons.my_location, size: 20),
              label: Text(
                isLocating ? 'Getting location…' : 'Use My Current Location',
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Sub-widgets (unchanged visual logic, opacity API updated)
// ─────────────────────────────────────────────────────────────────────────────

class _OfficePin extends StatelessWidget {
  const _OfficePin();

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme.primary;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: color.withValues(alpha: 0.4),
                blurRadius: 8,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: const Icon(Icons.business, color: Colors.white, size: 20),
        ),
        CustomPaint(size: const Size(12, 10), painter: _PinTailPainter(color)),
      ],
    );
  }
}

class _PinTailPainter extends CustomPainter {
  const _PinTailPainter(this.color);
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color;
    final path = ui.Path()
      ..moveTo(0, 0)
      ..lineTo(size.width / 2, size.height)
      ..lineTo(size.width, 0)
      ..close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(_PinTailPainter old) => old.color != color;
}

class _InstructionBanner extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.95),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.touch_app_outlined, size: 18, color: Colors.grey.shade600),
          const SizedBox(width: 8),
          Text(
            'Tap on the map to place the office pin',
            style: TextStyle(fontSize: 13, color: Colors.grey.shade700),
          ),
        ],
      ),
    );
  }
}

class _ZoomControls extends StatelessWidget {
  const _ZoomControls({required this.mapController});
  final MapController mapController;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.10),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _ZoomBtn(
            icon: Icons.add,
            onTap: () => mapController.move(
              mapController.camera.center,
              mapController.camera.zoom + 1,
            ),
          ),
          Container(height: 1, color: Colors.grey.shade200),
          _ZoomBtn(
            icon: Icons.remove,
            onTap: () => mapController.move(
              mapController.camera.center,
              mapController.camera.zoom - 1,
            ),
          ),
        ],
      ),
    );
  }
}

class _ZoomBtn extends StatelessWidget {
  const _ZoomBtn({required this.icon, required this.onTap});
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: SizedBox(
        width: 40,
        height: 40,
        child: Icon(icon, size: 20, color: Colors.grey.shade700),
      ),
    );
  }
}
