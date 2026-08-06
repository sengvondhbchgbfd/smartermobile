import 'package:flutter/material.dart';
import 'package:frontendmobile/core/utils/scann/segment_button.dart';

class ConfirmView extends StatelessWidget {
  const ConfirmView({
    super.key,
    required this.isCheckIn,
    required this.submitting,
    required this.errorMessage,
    required this.onSelect,
    required this.onConfirm,
    required this.onRetryScan,
  });

  final bool isCheckIn;
  final bool submitting;
  final String? errorMessage;
  final ValueChanged<bool> onSelect;
  final VoidCallback onConfirm;
  final VoidCallback onRetryScan;

  @override
  Widget build(BuildContext context) {
    final accentColor = isCheckIn ? Colors.green : Colors.red;

    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 36),
      child: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    width: 84,
                    height: 84,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.08),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.qr_code_scanner_rounded,
                      color: Colors.white70,
                      size: 40,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'QR verified',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Choose an action to continue',
                    style: TextStyle(color: Colors.white54, fontSize: 13),
                  ),
                  const SizedBox(height: 28),

                  // ── Segmented Check In / Check Out selector ──────────
                  Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.06),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: SegmentButton(
                            label: 'Check In',
                            icon: Icons.login,
                            color: Colors.green,
                            selected: isCheckIn,
                            onTap: submitting ? null : () => onSelect(true),
                          ),
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: SegmentButton(
                            label: 'Check Out',
                            icon: Icons.logout,
                            color: Colors.red,
                            selected: !isCheckIn,
                            onTap: submitting ? null : () => onSelect(false),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),

          if (errorMessage != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: Colors.red.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.red.withOpacity(0.4)),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.error_outline,
                      color: Colors.red,
                      size: 18,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        errorMessage!,
                        style: const TextStyle(color: Colors.red, fontSize: 13),
                      ),
                    ),
                  ],
                ),
              ),
            ),

          // ── Confirm button ────────────────────────────────────────────
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: submitting ? null : onConfirm,
              style: ElevatedButton.styleFrom(
                backgroundColor: accentColor,
                disabledBackgroundColor: accentColor.withOpacity(0.5),
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              child: submitting
                  ? const SizedBox(
                      width: 22,
                      height: 22,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.5,
                        color: Colors.white,
                      ),
                    )
                  : Text(
                      'Confirm ${isCheckIn ? "Check In" : "Check Out"}',
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
            ),
          ),
          const SizedBox(height: 10),
          if (!submitting)
            TextButton(
              onPressed: onRetryScan,
              style: TextButton.styleFrom(foregroundColor: Colors.white38),
              child: const Text('Rescan', style: TextStyle(fontSize: 14)),
            ),
        ],
      ),
    );
  }
}
