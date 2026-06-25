import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../domain/entities/audit_log_entity.dart';
import '../providers/audit_log_providers.dart'; // ← added

class AuditLogDetailScreen extends ConsumerWidget {
  final int logId;
  const AuditLogDetailScreen({super.key, required this.logId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final logAsync = ref.watch(auditLogDetailProvider(logId));

    return Scaffold(
      backgroundColor: const Color(0xFF1C1C1E),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1C1C1E),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Colors.white,
            size: 18,
          ),
          onPressed: () => context.pop(),
        ),
        title: const Text(
          'Log Detail',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
        ),
      ),
      body: logAsync.when(
        loading: () => const Center(
          child: CircularProgressIndicator(color: Color(0xFF0A84FF)),
        ),
        error: (e, _) => Center(
          child: Text(
            e.toString(),
            style: const TextStyle(color: Color(0xFFFF453A)),
          ),
        ),
        data: (log) => _DetailBody(log: log),
      ),
    );
  }
}

class _DetailBody extends StatelessWidget {
  final AuditLogEntity log;
  const _DetailBody({required this.log});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header card
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF2C2C2E),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    _ActionChip(action: log.action),
                    const Spacer(),
                    Text(
                      '#${log.logId}',
                      style: const TextStyle(
                        color: Color(0xFF8E8E93),
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                _InfoRow(
                  icon: Icons.table_chart_outlined,
                  label: 'Table',
                  value: log.tableName,
                ),
                if (log.recordId != null)
                  _InfoRow(
                    icon: Icons.tag,
                    label: 'Record ID',
                    value: '#${log.recordId}',
                  ),
                _InfoRow(
                  icon: Icons.person_outline,
                  label: 'User',
                  value: log.userId != null ? 'User ${log.userId}' : 'System',
                ),
                if (log.ipAddress != null)
                  _InfoRow(
                    icon: Icons.wifi_outlined,
                    label: 'IP Address',
                    value: log.ipAddress!,
                  ),
                _InfoRow(
                  icon: Icons.access_time_rounded,
                  label: 'Time',
                  value: DateFormat(
                    'MMM d, yyyy — HH:mm:ss',
                  ).format(log.createdAt.toLocal()),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Old value
          if (log.oldValue != null && log.oldValue!.isNotEmpty) ...[
            _SectionLabel(label: 'Before', color: const Color(0xFFFF453A)),
            const SizedBox(height: 8),
            _JsonCard(
              data: log.oldValue!,
              highlightColor: const Color(0xFF3A1C1C),
            ),
            const SizedBox(height: 16),
          ],

          // New value
          if (log.newValue != null && log.newValue!.isNotEmpty) ...[
            _SectionLabel(label: 'After', color: const Color(0xFF30D158)),
            const SizedBox(height: 8),
            _JsonCard(
              data: log.newValue!,
              highlightColor: const Color(0xFF1C3A24),
            ),
            const SizedBox(height: 16),
          ],

          // Diff view when both exist
          if (log.oldValue != null && log.newValue != null) ...[
            _SectionLabel(label: 'Changes', color: const Color(0xFFFFD60A)),
            const SizedBox(height: 8),
            _DiffCard(oldValue: log.oldValue!, newValue: log.newValue!),
          ],
        ],
      ),
    );
  }
}

class _ActionChip extends StatelessWidget {
  final String action;
  const _ActionChip({required this.action});

  @override
  Widget build(BuildContext context) {
    final (color, bg) = switch (action.toUpperCase()) {
      'INSERT' => (const Color(0xFF30D158), const Color(0xFF1C3A24)),
      'UPDATE' => (const Color(0xFFFFD60A), const Color(0xFF3A3010)),
      'DELETE' => (const Color(0xFFFF453A), const Color(0xFF3A1C1C)),
      _ => (const Color(0xFF8E8E93), const Color(0xFF3A3A3C)),
    };
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        action.toUpperCase(),
        style: TextStyle(
          color: color,
          fontSize: 13,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Row(
        children: [
          Icon(icon, size: 14, color: const Color(0xFF8E8E93)),
          const SizedBox(width: 8),
          Text(
            label,
            style: const TextStyle(color: Color(0xFF8E8E93), fontSize: 13),
          ),
          const Spacer(),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  final String label;
  final Color color;
  const _SectionLabel({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 3,
          height: 16,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          label,
          style: TextStyle(
            color: color,
            fontSize: 13,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

class _JsonCard extends StatelessWidget {
  final Map<String, dynamic> data;
  final Color highlightColor;
  const _JsonCard({required this.data, required this.highlightColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: highlightColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: highlightColor.withOpacity(0.5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: data.entries
            .map(
              (e) => Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 120,
                      child: Text(
                        e.key,
                        style: const TextStyle(
                          color: Color(0xFF8E8E93),
                          fontSize: 12,
                          fontFamily: 'monospace',
                        ),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        '${e.value}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontFamily: 'monospace',
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
            .toList(),
      ),
    );
  }
}

class _DiffCard extends StatelessWidget {
  final Map<String, dynamic> oldValue;
  final Map<String, dynamic> newValue;
  const _DiffCard({required this.oldValue, required this.newValue});

  @override
  Widget build(BuildContext context) {
    final changedKeys = newValue.keys
        .where((k) => oldValue[k]?.toString() != newValue[k]?.toString())
        .toList();

    if (changedKeys.isEmpty) {
      return const Text(
        'No field changes detected.',
        style: TextStyle(color: Color(0xFF8E8E93), fontSize: 13),
      );
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFF2C2C2E),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: changedKeys
            .map(
              (k) => Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      k,
                      style: const TextStyle(
                        color: Color(0xFF8E8E93),
                        fontSize: 11,
                        fontFamily: 'monospace',
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFF3A1C1C),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              '${oldValue[k]}',
                              style: const TextStyle(
                                color: Color(0xFFFF453A),
                                fontSize: 12,
                                fontFamily: 'monospace',
                              ),
                            ),
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 8),
                          child: Icon(
                            Icons.arrow_forward_rounded,
                            size: 14,
                            color: Color(0xFF8E8E93),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFF1C3A24),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              '${newValue[k]}',
                              style: const TextStyle(
                                color: Color(0xFF30D158),
                                fontSize: 12,
                                fontFamily: 'monospace',
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            )
            .toList(),
      ),
    );
  }
}
