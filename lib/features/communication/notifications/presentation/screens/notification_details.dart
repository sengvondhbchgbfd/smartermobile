import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontendmobile/core/components/section_label.dart';
import 'package:frontendmobile/core/themes/app_pallets.dart';
import 'package:frontendmobile/core/utils/date_formatter.dart';
import 'package:frontendmobile/features/communication/notifications/domain/entities/notification_entity.dart';
import 'package:frontendmobile/features/communication/notifications/presentation/providers/notification_provider.dart';
import 'package:frontendmobile/features/communication/notifications/presentation/widgets/details/header_card.dart';
import 'package:frontendmobile/features/communication/notifications/presentation/widgets/details/meta_card.dart'
    show MetaCard;
import 'package:frontendmobile/features/communication/notifications/presentation/widgets/details/meta_row.dart';
import 'package:frontendmobile/features/communication/notifications/presentation/widgets/details/status_config.dart';
import 'package:frontendmobile/features/communication/notifications/presentation/widgets/details/type_config.dart';
import 'package:frontendmobile/features/communication/notifications/presentation/widgets/palette.dart';
import 'package:frontendmobile/features/hr/leave/presentation/screens/leave_detail_screen.dart';
import 'package:frontendmobile/features/hr/salaries/presentation/provider/salary_notifier.dart';
import 'package:frontendmobile/features/hr/salaries/presentation/screens/salary_details_screen.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Route
// ─────────────────────────────────────────────────────────────────────────────
class NotificationDetailPage extends ConsumerStatefulWidget {
  const NotificationDetailPage({super.key, required this.notification});
  final NotificationEntity notification;

  static Route<void> route(NotificationEntity n) => MaterialPageRoute(
    builder: (_) => NotificationDetailPage(notification: n),
  );
  @override
  ConsumerState<NotificationDetailPage> createState() =>
      _NotificationDetailPageState();
}

// ─────────────────────────────────────────────────────────────────────────────
// State
// ─────────────────────────────────────────────────────────────────────────────
class _NotificationDetailPageState
    extends ConsumerState<NotificationDetailPage> {
  late NotificationEntity _notif;
  @override
  void initState() {
    super.initState();
    _notif = widget.notification;
  }

  // ── Delete ────────────────────────────────────────────────────────────────

  Future<void> _confirmDelete(bool isDark) async {
    final p = Palette.of(isDark);
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: p.dialogBg,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          'Delete notification',
          style: TextStyle(color: p.textPrimary, fontWeight: FontWeight.w600),
        ),
        content: Text(
          'This notification will be permanently removed.',
          style: TextStyle(color: p.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text('Cancel', style: TextStyle(color: p.textSecondary)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(
              'Delete',
              style: TextStyle(
                color: Pallets.error,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
    if (confirmed == true && mounted) {
      await ref
          .read(notificationNotifierProvider.notifier)
          .deleteOne(_notif.notificationId);
      if (mounted) Navigator.pop(context);
    }
  }

  // ── Reference navigation ──────────────────────────────────────────────────
  void _handleReference(bool isDark) {
    final refType = _notif.referenceType?.toLowerCase();
    final refId = _notif.referenceId;
    if (refId == null) return;
    switch (refType) {
      case 'invoice':
        // context.push(RouteNames.invoiceDetail.replaceAll(':id', '$refId'));
        break;
      case 'quotation':
        // Navigator.push(context, QuotationDetailScreen.route(refId));
        break;
      case 'leave_request':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => LeaveDetailScreen(leaveId: refId)),
        );

        break;
      case 'salary':
        final salaries = ref.read(salaryNotifierProvider).valueOrNull ?? [];
        final salary = salaries.where((s) => s.salaryId == refId).firstOrNull;

        if (salary != null) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => SalaryDetailsScreen(salary: salary),
            ),
          );
        }
        break;
      default:
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Opening $refType #$refId'),
            backgroundColor: Palette.of(isDark).surface,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        );
    }
  }

  // ─────────────────────────────────────────────────────────────────────────
  // Build
  // ─────────────────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final p = Palette.of(isDark);
    final cfg = refConfigFor(_notif.referenceType);
    final statusCfg = statusConfigFor(_notif.type);

    return Scaffold(
      backgroundColor: p.background,

      /////////////////////////////////////////////////////////
      ///
      ////////////////////////////////////////////////////////
      appBar: AppBar(
        backgroundColor: p.surface,
        elevation: 0,
        /////////////////////////////////////////
        // leading: GestureDetector(
        //   onTap: () => Navigator.pop(context),
        //   child: Container(
        //     margin: const EdgeInsets.all(8),
        //     decoration: BoxDecoration(
        //       color: p.background,
        //       borderRadius: BorderRadius.circular(10),
        //     ),
        //     child: Icon(
        //       Icons.arrow_back_ios_new_rounded,
        //       color: p.textPrimary,
        //       size: 18,
        //     ),
        //   ),
        //   ///////////////////////////////////////
        // ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Notification Detail',
              style: TextStyle(
                color: p.textPrimary,
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
            ),
            Text(
              _notif.isRead ? 'Read' : 'Unread',
              style: TextStyle(
                color: _notif.isRead ? p.textSecondary : Pallets.gradient2,
                fontSize: 11,
              ),
            ),
          ],
        ),

        ////////////////////////////////////////////////////////////////////////
        ///
        ////////////////////////////////////////////////////////////////////////
        actions: [
          if (!_notif.isRead)
            IconButton(
              icon: Icon(Icons.done_all, color: p.textPrimary),
              tooltip: 'Mark as read',
              onPressed: () async {
                await ref
                    .read(notificationNotifierProvider.notifier)
                    .markOneRead(_notif.notificationId);

                if (mounted) {
                  setState(() {
                    _notif = _notif.copyWith(isRead: true);
                  });
                }
              },
            ),
          PopupMenuButton<String>(
            icon: Icon(Icons.more_vert, color: p.textPrimary),
            color: p.surface,
            onSelected: (value) {
              if (value == 'delete') _confirmDelete(isDark);
            },
            itemBuilder: (_) => [
              PopupMenuItem(
                value: 'delete',
                child: Row(
                  children: [
                    Icon(Icons.delete_sweep, color: Pallets.error, size: 18),
                    const SizedBox(width: 8),
                    Text('Delete', style: TextStyle(color: Pallets.error)),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),

      //////////////////////////////////////////////////////////////////////////
      ///
      //////////////////////////////////////////////////////////////////////////
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Header card ──────────────────────────────────────────────
            HeaderCard(notif: _notif, cfg: cfg, statusCfg: statusCfg),
            const SizedBox(height: 16),

            // ── Message ──────────────────────────────────────────────────
            SectionLabel(label: 'Message'),
            const SizedBox(height: 8),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: p.surface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: p.border, width: 0.5),
              ),
              child: Text(
                _notif.message,
                style: TextStyle(
                  color: p.textPrimary.withValues(alpha: 0.87),
                  fontSize: 14,
                  height: 1.65,
                ),
              ),
            ),
            const SizedBox(height: 20),

            // ── Details ──────────────────────────────────────────────────
            SectionLabel(label: 'Details'),
            const SizedBox(height: 8),
            MetaCard(
              rows: [
                MetaRow(
                  icon: cfg.icon,
                  label: 'Category',
                  value: cfg.label,
                  valueColor: cfg.color,
                ),
                MetaRow(
                  icon: statusCfg.icon,
                  label: 'Severity',
                  value: statusCfg.label,
                  valueColor: statusCfg.color,
                ),
                MetaRow(
                  icon: _notif.isRead
                      ? Icons.check_circle_outline
                      : Icons.radio_button_checked,
                  label: 'Read status',
                  value: _notif.isRead ? 'Read' : 'Unread',
                  valueColor: _notif.isRead
                      ? p.textSecondary
                      : Pallets.gradient2,
                ),
                MetaRow(
                  icon: Icons.access_time_outlined,
                  label: 'Received',
                  value: formatDateTime(_notif.createdAt),
                ),
                if (_notif.referenceId != null)
                  MetaRow(
                    icon: Icons.link_outlined,
                    label: _notif.referenceType ?? 'Reference',
                    value: '#${_notif.referenceId}',
                    valueColor: Pallets.gradient2,
                    onTap: () => _handleReference(isDark),
                  ),
              ],
            ),
            const SizedBox(height: 24),

            // ── View reference CTA ────────────────────────────────────────
            if (_notif.referenceId != null)
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Pallets.gradient2,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                  onPressed: () => _handleReference(isDark),
                  icon: Icon(cfg.icon, size: 18),
                  label: Text(
                    cfg.ctaLabel,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
