import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontendmobile/features/inventory/invoice/presentation/widgets/invoice_theme_color.dart';
import 'package:frontendmobile/features/inventory/quotations/domain/entities/quotation_entity.dart';
import 'package:frontendmobile/features/inventory/quotations/presentation/providers/quotation_provider.dart';
import 'quotation_card.dart';

class QuotationListView extends ConsumerWidget {
  final int? expandedQuotationId;
  final bool converting;
  final ValueChanged<int?> onToggleExpanded;
  final ValueChanged<QuotationEntity> onConvert;

  const QuotationListView({
    required this.expandedQuotationId,
    required this.converting,
    required this.onToggleExpanded,
    required this.onConvert,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.invoiceColors;
    final quotationsAsync = ref.watch(quotationListNotifierProvider);

    return quotationsAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, _) => Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.error_outline, size: 30, color: colors.error),
              const SizedBox(height: 8),
              Text(
                'Failed to load quotations',
                style: TextStyle(
                  color: colors.textPrimary,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '$err',
                style: TextStyle(color: colors.textSecondary, fontSize: 12),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
      data: (quotations) {
        // Only accepted, not-yet-converted quotations are eligible — matches
        // the backend's own validation in InvoiceService.create_from_quotation,
        // so picking one here won't just fail server-side a step later.
        final eligible = quotations
            .where(
              (q) =>
                  q.invoiceId == null &&
                  q.status.name.toLowerCase() == 'accepted',
            )
            .toList();

        if (eligible.isEmpty) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.request_quote_outlined,
                    size: 30,
                    color: colors.textSecondary,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'No accepted quotations',
                    style: TextStyle(
                      color: colors.textPrimary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Accepted quotations that haven\'t been converted yet will show up here.',
                    style: TextStyle(color: colors.textSecondary, fontSize: 12),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
          itemCount: eligible.length,
          itemBuilder: (_, i) {
            final q = eligible[i];
            return QuotationCard(
              quotation: q,
              expanded: expandedQuotationId == q.quotationId,
              converting: converting,
              onToggleExpanded: () => onToggleExpanded(
                expandedQuotationId == q.quotationId ? null : q.quotationId,
              ),
              onConvert: () => onConvert(q),
            );
          },
        );
      },
    );
  }
}
