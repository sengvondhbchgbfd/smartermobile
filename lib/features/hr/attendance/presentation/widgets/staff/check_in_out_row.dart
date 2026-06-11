import 'dart:async';
import 'package:flutter/material.dart';
import 'package:frontendmobile/core/utils/attendance_token_session.dart';
import 'package:frontendmobile/features/hr/attendance/presentation/widgets/staff/action_button.dart';

class CheckInOutRow extends StatefulWidget {
  // ← was StatelessWidget
  const CheckInOutRow({
    super.key,
    required this.isLoading,
    required this.onCheckIn,
    required this.onCheckOut,
  });

  final bool isLoading;
  final VoidCallback onCheckIn;
  final VoidCallback onCheckOut;

  @override
  State<CheckInOutRow> createState() => _CheckInOutRowState();
}

class _CheckInOutRowState extends State<CheckInOutRow> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    // Tick every second so the countdown re-renders live
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  String _formatSeconds(int s) {
    final m = s ~/ 60;
    final sec = s % 60;
    return '${m}m ${sec.toString().padLeft(2, '0')}s';
  }

  @override
  Widget build(BuildContext context) {
    final session = AttendanceTokenSession.instance;
    final tokenActive = session.isValid;
    final remaining = session.remainingSeconds;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      color: Theme.of(context).colorScheme.surface,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (tokenActive)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                children: [
                  const Icon(Icons.timer, size: 14, color: Colors.green),
                  const SizedBox(width: 4),
                  Flexible(
                    child: Text(
                      'Session active · expires in ${_formatSeconds(remaining)}',
                      style: const TextStyle(fontSize: 12, color: Colors.green),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          Row(
            children: [
              Expanded(
                child: ActionButton(
                  label: 'Check In',
                  icon: Icons.login,
                  color: Colors.green,
                  isLoading: widget.isLoading,
                  onTap: widget.onCheckIn,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ActionButton(
                  label: 'Check Out',
                  icon: Icons.logout,
                  color: Colors.red,
                  isLoading: widget.isLoading,
                  onTap: widget.onCheckOut,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
