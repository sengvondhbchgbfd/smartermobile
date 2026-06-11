import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class AttendanceLocationHelper {
  const AttendanceLocationHelper._();

  // ── Entry point ────────────────────────────────────────────────────────────

  /// Returns the current [Position], or `null` if the user denied permission
  /// or location services are off.  Shows in-app error dialogs automatically.
  static Future<Position?> getCurrentPosition(BuildContext context) async {
    // 1. Service enabled?
    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      if (context.mounted) {
        _showError(
          context,
          title: 'Location Disabled',
          message:
              'Please enable location services on your device to check in/out.',
          onSettings: Geolocator.openLocationSettings,
        );
      }
      return null;
    }

    // 2. Permission
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        if (context.mounted) {
          _showError(
            context,
            title: 'Location Permission Denied',
            message:
                'Location access is required to verify you are at the office.',
          );
        }
        return null;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      if (context.mounted) {
        _showError(
          context,
          title: 'Location Permission Permanently Denied',
          message:
              'Please enable location permission in your app settings.',
          onSettings: Geolocator.openAppSettings,
        );
      }
      return null;
    }

    // 3. Fetch
    return Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
  }

  // ── Private dialog ─────────────────────────────────────────────────────────

  static void _showError(
    BuildContext context, {
    required String title,
    required String message,
    VoidCallback? onSettings,
  }) {
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            const Icon(Icons.location_off, color: Colors.orange),
            const SizedBox(width: 10),
            Expanded(child: Text(title)),
          ],
        ),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          if (onSettings != null)
            ElevatedButton(
              onPressed: () {
                Navigator.pop(ctx);
                onSettings();
              },
              child: const Text('Open Settings'),
            ),
        ],
      ),
    );
  }
}