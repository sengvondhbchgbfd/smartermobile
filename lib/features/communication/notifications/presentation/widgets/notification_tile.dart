import 'package:flutter/material.dart';
import 'package:frontendmobile/core/themes/app_pallets.dart';
import 'package:frontendmobile/features/communication/notifications/domain/entities/notification_entity.dart';
import 'package:frontendmobile/features/communication/notifications/presentation/widgets/notification_type_badge.dart';
import 'package:frontendmobile/features/communication/notifications/presentation/widgets/palette.dart';

class NotificationTile extends StatelessWidget {
  final NotificationEntity notification;
  final bool isSelecting;
  final bool isSelected;
  final VoidCallback onTap;
  final VoidCallback onLongPress;
  final VoidCallback onDismissed;

  final VoidCallback? onConfirm;

  final VoidCallback? onReject;

  const NotificationTile({
    super.key,
    required this.notification,
    required this.isSelecting,
    required this.isSelected,
    required this.onTap,
    required this.onLongPress,
    required this.onDismissed,
    this.onConfirm,
    this.onReject,
  });

  // ── Which reference types show action buttons ─────────────────────────────
  bool get _isActionable {
    if (onConfirm == null && onReject == null) return false;
    final ref = notification.referenceType?.toLowerCase();
    return ref == 'leave_request' || ref == 'invoice' || ref == 'quotation';
  }

  // ── Label per reference type ──────────────────────────────────────────────
  String get _confirmLabel {
    return switch (notification.referenceType?.toLowerCase()) {
      'leave_request' => 'Approve',
      'invoice' => 'Confirm',
      'quotation' => 'Accept',
      _ => 'Confirm',
    };
  }

  String get _rejectLabel {
    return switch (notification.referenceType?.toLowerCase()) {
      'leave_request' => 'Reject',
      'invoice' => 'Decline',
      'quotation' => 'Decline',
      _ => 'Reject',
    };
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final p = PaletteScreen.of(isDark);

    final unreadBg = isDark
        ? Pallets.surfaceCard.withValues(alpha: 0.6)
        : Pallets.infoTint;

    return Dismissible(
      key: Key('notif_${notification.notificationId}'),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        color: Pallets.error,
        child: const Icon(Icons.delete_outline, color: Colors.white),
      ),
      onDismissed: (_) => onDismissed(),
      child: InkWell(
        onTap: onTap,
        onLongPress: onLongPress,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          color: isSelected
              ? Pallets.gradient2.withValues(alpha: 0.15)
              : notification.isRead
              ? Colors.transparent
              : unreadBg,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Checkbox or type icon ──────────────────────────────────
              if (isSelecting)
                Padding(
                  padding: const EdgeInsets.only(right: 12, top: 2),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 150),
                    width: 22,
                    height: 22,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isSelected
                          ? Pallets.gradient2
                          : Colors.transparent,
                      border: Border.all(
                        color: isSelected ? Pallets.gradient2 : p.border,
                        width: 2,
                      ),
                    ),
                    child: isSelected
                        ? const Icon(Icons.check, color: Colors.white, size: 14)
                        : null,
                  ),
                )
              else
                Padding(
                  padding: const EdgeInsets.only(right: 12, top: 2),
                  child: NotificationTypeBadge(type: notification.type.name),
                ),

              // ── Content ───────────────────────────────────────────────
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // title + unread dot
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            notification.title,
                            style: TextStyle(
                              color: p.text,
                              fontWeight: notification.isRead
                                  ? FontWeight.normal
                                  : FontWeight.w600,
                              fontSize: 14,
                            ),
                          ),
                        ),
                        if (!notification.isRead)
                          Container(
                            width: 8,
                            height: 8,
                            margin: const EdgeInsets.only(left: 8),
                            decoration: BoxDecoration(
                              color: Pallets.gradient2,
                              shape: BoxShape.circle,
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 4),

                    // message
                    Text(
                      notification.message,
                      style: TextStyle(color: p.subText, fontSize: 13),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 6),

                    // timestamp
                    Text(
                      _formatTime(notification.createdAt),
                      style: TextStyle(
                        color: p.subText.withValues(alpha: 0.7),
                        fontSize: 11,
                      ),
                    ),

                    // ── Action buttons (approve / reject) ────────────────
                    if (_isActionable && !isSelecting) ...[
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          // Confirm / Approve
                          _ActionButton(
                            label: _confirmLabel,
                            icon: Icons.check_rounded,
                            bg: Pallets.successTint,
                            fg: Pallets.success,
                            onTap: onConfirm!,
                          ),
                          const SizedBox(width: 8),
                          // Reject / Decline
                          _ActionButton(
                            label: _rejectLabel,
                            icon: Icons.close_rounded,
                            bg: Pallets.errorTint,
                            fg: Pallets.error,
                            onTap: onReject!,
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatTime(DateTime? dt) {
    if (dt == null) return '';
    final now = DateTime.now();
    final diff = now.difference(dt);
    if (diff.inSeconds < 60) return 'Just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    if (diff.inDays < 7) return '${diff.inDays}d ago';
    return '${dt.day}/${dt.month}/${dt.year}';
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// _ActionButton
// ─────────────────────────────────────────────────────────────────────────────
class _ActionButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color bg, fg;
  final VoidCallback onTap;

  const _ActionButton({
    required this.label,
    required this.icon,
    required this.bg,
    required this.fg,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: fg.withValues(alpha: 0.3)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: fg, size: 13),
            const SizedBox(width: 4),
            Text(
              label,
              style: TextStyle(
                color: fg,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
