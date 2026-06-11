import 'package:flutter/material.dart';
import 'package:frontendmobile/features/hr/attendance/presentation/widgets/tool_bar_button.dart';

class ManagerToolbar extends StatelessWidget {
  const ManagerToolbar({
    super.key,
    required this.isScanLoading,
    required this.onShowQr,
    required this.onRefreshQr,
    required this.onExport,
    required this.onRemind,
    required this.onSettings,
  });

  final bool isScanLoading;
  final VoidCallback onShowQr;
  final VoidCallback onRefreshQr;
  final VoidCallback onExport;
  final VoidCallback onRemind;
  final VoidCallback onSettings;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        border: Border(bottom: BorderSide(color: Colors.grey.shade200)),
      ),



      child: Row(
        children: [
          ToolbarButton(
            icon: Icons.qr_code,
            label: 'QR Code',
            color: Colors.blue,
            onTap: onShowQr,
            loading: isScanLoading,
          ),
          const SizedBox(width: 6),
          ToolbarButton(
            icon: Icons.refresh,
            label: 'Refresh',
            color: Colors.teal,
            onTap: onRefreshQr,
            loading: isScanLoading,
          ),
          const Spacer(),
          ToolbarButton(
            icon: Icons.download_outlined,
            label: 'Export',
            color: Colors.green,
            onTap: onExport,
          ),
          const SizedBox(width: 6),
          ToolbarButton(
            icon: Icons.notifications_active_outlined,
            label: 'Remind',
            color: Colors.orange,
            onTap: onRemind,
          ),
          const SizedBox(width: 6),
          ToolbarButton(
            icon: Icons.settings_outlined,
            label: 'Settings',
            color: Colors.grey.shade700,
            onTap: onSettings,
          ),
        ],
      ),
    );
  }
}

