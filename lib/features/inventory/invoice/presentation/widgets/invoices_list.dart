import 'package:flutter/material.dart';
import 'package:frontendmobile/core/themes/app_pallets.dart';
import 'package:frontendmobile/core/utils/emty_state.dart' show EmptyState;
import 'package:frontendmobile/core/widgets/shimmer/app_list_shimmer.dart';
import '../widgets/invoice_widgets.dart';

class InvoicesList extends StatelessWidget {
  final bool isLoading;
  final bool isProductLoading;
  final bool isButtonDisabled;
  final List<dynamic> invoices;
  final String Function(int?) customerName;
  final void Function(dynamic invoice) onTapInvoice;
  final void Function(int invoiceId) onDeleteInvoice;
  final VoidCallback onCreate;
  final Future<void> Function() onRefresh;

  const InvoicesList({
    super.key,
    required this.isLoading,
    required this.isProductLoading,
    required this.isButtonDisabled,
    required this.invoices,
    required this.customerName,
    required this.onTapInvoice,
    required this.onDeleteInvoice,
    required this.onCreate,
    required this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardColor = isDark ? Pallets.surfaceCard : Pallets.surfaceLight;
    final accent = Pallets.blurple;
    return RefreshIndicator(
      color: accent,
      backgroundColor: cardColor,
      onRefresh: onRefresh,
      child: isLoading
          ? const AppListShimmer(itemCount: 6)
          : invoices.isEmpty
          ? ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.6,
                  child: EmptyState(
                    icon: Icons.receipt_long_outlined,
                    title: 'No invoices yet',
                    message: 'Create your first invoice to start selling.',
                    actionLabel: isProductLoading
                        ? 'Syncing...'
                        : 'New Invoice',
                    onAction: isButtonDisabled ? () {} : onCreate,
                  ),
                ),
              ],
            )
          : ListView.separated(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 110),
              itemCount: invoices.length,
              separatorBuilder: (_, __) => const SizedBox(height: 10),
              itemBuilder: (_, i) {
                final inv = invoices[i];
                return Container(
                  decoration: BoxDecoration(
                    color: cardColor,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: isDark
                        ? []
                        : [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.04),
                              blurRadius: 10,
                              offset: const Offset(0, 3),
                            ),
                          ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: InvoiceTile(
                      invoice: inv,
                      customerName: customerName(inv.customerId),
                      onTap: () => onTapInvoice(inv),
                      onDelete: () => onDeleteInvoice(inv.invoiceId),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
