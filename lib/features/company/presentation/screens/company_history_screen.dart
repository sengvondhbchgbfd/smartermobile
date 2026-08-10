import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontendmobile/features/company/domain/entities/compay_status_history_entity.dart';
import 'package:frontendmobile/features/company/presentation/providers/company_provider.dart';
import 'package:intl/intl.dart';
import 'package:frontendmobile/core/themes/app_pallets.dart';

class CompanyHistoryScreen extends ConsumerStatefulWidget {
  final int companyId;
  const CompanyHistoryScreen({super.key, required this.companyId});

  @override
  ConsumerState<CompanyHistoryScreen> createState() =>
      _CompanyHistoryScreenState();
}

class _CompanyHistoryScreenState extends ConsumerState<CompanyHistoryScreen> {
  @override
  void initState() {
    super.initState();
    // fetch after first frame so ref.read is safe inside initState
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(companyProvider.notifier).fetchStatusHistory(widget.companyId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = isDark ? Pallets.backgroundDark : Pallets.backgroundLight;
    final surface = isDark ? Pallets.surfaceDark : Pallets.surfaceLight;
    final textPrimary = isDark
        ? Pallets.textPrimaryDark
        : Pallets.textPrimaryLight;
    final textSecondary = isDark
        ? Pallets.textSecondaryDark
        : Pallets.textSecondaryLight;
    final border = isDark ? Pallets.borderDark : Pallets.borderLight;

    final companyAsync = ref.watch(companyProvider);

    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        title: Text(
          'Company History',
          style: TextStyle(
            color: textPrimary,
            fontWeight: FontWeight.w700,
            fontSize: 18,
            letterSpacing: -0.3,
          ),
        ),
        backgroundColor: surface,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 1,
        shape: Border(bottom: BorderSide(color: border, width: 1)),
        iconTheme: IconThemeData(color: textPrimary),
      ),
      body: companyAsync.when(
        loading: () =>
            Center(child: CircularProgressIndicator(color: Pallets.blurple)),
        error: (e, _) => Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.error_outline, color: Pallets.error, size: 32),
              const SizedBox(height: 8),
              Text(
                'Error: $e',
                textAlign: TextAlign.center,
                style: TextStyle(color: textSecondary),
              ),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: () => ref
                    .read(companyProvider.notifier)
                    .fetchStatusHistory(widget.companyId),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Pallets.blurple,
                ),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
        data: (state) {
          // history-specific loading (isUpdating/isLoadingHistory), while
          // outer AsyncValue is already "data" because build() resolved.
          if (state.isLoadingHistory && state.history.isEmpty) {
            return Center(
              child: CircularProgressIndicator(color: Pallets.blurple),
            );
          }

          if (state.error != null && state.history.isEmpty) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.error_outline, color: Pallets.error, size: 32),
                  const SizedBox(height: 8),
                  Text(
                    'Error: ${state.error}',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: textSecondary),
                  ),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: () => ref
                        .read(companyProvider.notifier)
                        .fetchStatusHistory(widget.companyId),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Pallets.blurple,
                    ),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          if (state.history.isEmpty) {
            return Center(
              child: Text(
                'No status changes recorded yet.',
                style: TextStyle(color: textSecondary),
              ),
            );
          }

          return RefreshIndicator(
            color: Pallets.blurple,
            backgroundColor: surface,
            onRefresh: () => ref
                .read(companyProvider.notifier)
                .fetchStatusHistory(widget.companyId),
            child: ListView.separated(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
              itemCount: state.history.length,
              separatorBuilder: (_, __) => const SizedBox(height: 10),
              itemBuilder: (context, index) => _HistoryTile(
                entry: state.history[index],
                surface: surface,
                border: border,
                textPrimary: textPrimary,
                textSecondary: textSecondary,
              ),
            ),
          );
        },
      ),
    );
  }
}

class _HistoryTile extends StatelessWidget {
  final CompanyStatusHistoryEntity entry;
  final Color surface;
  final Color border;
  final Color textPrimary;
  final Color textSecondary;

  const _HistoryTile({
    required this.entry,
    required this.surface,
    required this.border,
    required this.textPrimary,
    required this.textSecondary,
  });

  Color _statusColor(String status) {
    switch (status.toLowerCase()) {
      case 'active':
        return Pallets.success;
      case 'suspended':
        return Colors.orange;
      case 'cancelled':
        return Pallets.error;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: border, width: 0.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _StatusChip(
                label: entry.oldStatus,
                color: _statusColor(entry.oldStatus),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 6),
                child: Icon(
                  Icons.arrow_forward_rounded,
                  size: 14,
                  color: textSecondary,
                ),
              ),
              _StatusChip(
                label: entry.newStatus,
                color: _statusColor(entry.newStatus),
              ),
              const Spacer(),
              Text(
                DateFormat('dd MMM yyyy, HH:mm').format(entry.changedAt),
                style: TextStyle(fontSize: 11, color: textSecondary),
              ),
            ],
          ),
          if (entry.reason != null && entry.reason!.isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(
              entry.reason!,
              style: TextStyle(fontSize: 12.5, color: textPrimary),
            ),
          ],
          const SizedBox(height: 6),
          Text(
            'Changed by user #${entry.changedBy}',
            style: TextStyle(fontSize: 11, color: textSecondary),
          ),
        ],
      ),
    );
  }
}

class _StatusChip extends StatelessWidget {
  final String label;
  final Color color;
  const _StatusChip({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: color,
        ),
      ),
    );
  }
}
