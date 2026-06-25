import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../domain/entities/audit_log_entity.dart';

class AuditLogTile extends StatelessWidget {
  final AuditLogEntity log;
  final VoidCallback? onTap;

  const AuditLogTile({super.key, required this.log, this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: const Color(0xFF2C2C2E),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _ActionBadge(action: log.action),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          log.tableName,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      if (log.recordId != null)
                        Text(
                          '#${log.recordId}',
                          style: const TextStyle(color: Color(0xFF8E8E93), fontSize: 12),
                        ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.person_outline, size: 12, color: Color(0xFF8E8E93)),
                      const SizedBox(width: 4),
                      Text(
                        log.userId != null ? 'User ${log.userId}' : 'System',
                        style: const TextStyle(color: Color(0xFF8E8E93), fontSize: 12),
                      ),
                      if (log.ipAddress != null) ...[
                        const SizedBox(width: 10),
                        const Icon(Icons.wifi_outlined, size: 12, color: Color(0xFF8E8E93)),
                        const SizedBox(width: 4),
                        Text(
                          log.ipAddress!,
                          style: const TextStyle(color: Color(0xFF8E8E93), fontSize: 12),
                        ),
                      ],
                      const Spacer(),
                      Text(
                        DateFormat('MMM d, HH:mm').format(log.createdAt.toLocal()),
                        style: const TextStyle(color: Color(0xFF8E8E93), fontSize: 12),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ActionBadge extends StatelessWidget {
  final String action;
  const _ActionBadge({required this.action});

  @override
  Widget build(BuildContext context) {
    final (color, bg, label) = switch (action.toUpperCase()) {
      'INSERT' => (const Color(0xFF30D158), const Color(0xFF1C3A24), 'INS'),
      'UPDATE' => (const Color(0xFFFFD60A), const Color(0xFF3A3010), 'UPD'),
      'DELETE' => (const Color(0xFFFF453A), const Color(0xFF3A1C1C), 'DEL'),
      _ => (const Color(0xFF8E8E93), const Color(0xFF2C2C2E), action.substring(0, 3).toUpperCase()),
    };

    return Container(
      width: 42,
      height: 42,
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(8)),
      alignment: Alignment.center,
      child: Text(
        label,
        style: TextStyle(color: color, fontSize: 11, fontWeight: FontWeight.w700, letterSpacing: 0.5),
      ),
    );
  }
}