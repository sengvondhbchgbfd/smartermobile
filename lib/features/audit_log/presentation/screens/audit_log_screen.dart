import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/audit_log_providers.dart';
import '../widgets/audit_log_tile.dart';

const _actions = ['ALL', 'INSERT', 'UPDATE', 'DELETE'];
const _tables = ['ALL', 'products', 'product_variants', 'stock_movements', 'invoices', 'staff', 'customers', 'suppliers'];

class AuditLogScreen extends ConsumerWidget {
  const AuditLogScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filter = ref.watch(auditLogFilterNotifierProvider);         // ← fixed
    final logsAsync = ref.watch(auditLogListProvider);

    return Scaffold(
      backgroundColor: const Color(0xFF1C1C1E),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1C1C1E),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 18),
          onPressed: () => context.pop(),
        ),
        title: const Text('Audit Logs', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded, color: Colors.white),
            onPressed: () => ref.invalidate(auditLogListProvider),
          ),
        ],
      ),
      body: Column(
        children: [
          _FilterBar(filter: filter, ref: ref),
          Expanded(
            child: logsAsync.when(
              loading: () => const Center(child: CircularProgressIndicator(color: Color(0xFF0A84FF))),
              error: (e, _) => Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.error_outline, color: Color(0xFFFF453A), size: 48),
                    const SizedBox(height: 12),
                    Text(e.toString(), style: const TextStyle(color: Color(0xFF8E8E93)), textAlign: TextAlign.center),
                    const SizedBox(height: 16),
                    TextButton(
                      onPressed: () => ref.invalidate(auditLogListProvider),
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              ),
              data: (logs) => logs.isEmpty
                  ? const Center(
                      child: Text('No logs found', style: TextStyle(color: Color(0xFF8E8E93))),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      itemCount: logs.length,
                      itemBuilder: (_, i) => AuditLogTile(
                        log: logs[i],
                        onTap: () => context.push('/audit-logs/${logs[i].logId}'),
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}

class _FilterBar extends StatelessWidget {
  final AuditLogFilter filter;
  final WidgetRef ref;
  const _FilterBar({required this.filter, required this.ref});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFF2C2C2E),
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: _actions.map((a) {
                final selected = a == 'ALL' ? filter.action == null : filter.action == a;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: FilterChip(
                    label: Text(a),
                    selected: selected,
                    onSelected: (_) {
                      ref.read(auditLogFilterNotifierProvider.notifier).update( // ← fixed
                            (s) => s.copyWith(clearAction: a == 'ALL', action: a == 'ALL' ? null : a),
                          );
                    },
                    backgroundColor: const Color(0xFF3A3A3C),
                    selectedColor: const Color(0xFF0A84FF).withOpacity(0.25),
                    checkmarkColor: const Color(0xFF0A84FF),
                    labelStyle: TextStyle(
                      color: selected ? const Color(0xFF0A84FF) : const Color(0xFF8E8E93),
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                    side: BorderSide(
                      color: selected ? const Color(0xFF0A84FF) : Colors.transparent,
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 8),
          DropdownButtonFormField<String>(
            value: filter.table ?? 'ALL',
            decoration: InputDecoration(
              isDense: true,
              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              filled: true,
              fillColor: const Color(0xFF3A3A3C),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide.none,
              ),
              prefixIcon: const Icon(Icons.table_chart_outlined, color: Color(0xFF8E8E93), size: 16),
            ),
            dropdownColor: const Color(0xFF3A3A3C),
            style: const TextStyle(color: Colors.white, fontSize: 13),
            icon: const Icon(Icons.keyboard_arrow_down_rounded, color: Color(0xFF8E8E93)),
            items: _tables
                .map((t) => DropdownMenuItem(value: t, child: Text(t)))
                .toList(),
            onChanged: (t) {
              ref.read(auditLogFilterNotifierProvider.notifier).update( // ← fixed
                    (s) => s.copyWith(clearTable: t == 'ALL', table: t == 'ALL' ? null : t),
                  );
            },
          ),
        ],
      ),
    );
  }
}