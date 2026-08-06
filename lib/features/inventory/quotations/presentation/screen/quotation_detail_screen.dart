import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontendmobile/core/themes/app_pallets.dart';
import 'package:frontendmobile/core/widgets/shimmer/quotation_detail_shimmer.dart';
import 'package:frontendmobile/features/inventory/quotations/presentation/widgets/details/quotation_header_card.dart';
import 'package:frontendmobile/features/inventory/quotations/presentation/widgets/details/quotation_items_section.dart';
import 'package:frontendmobile/features/inventory/quotations/presentation/widgets/details/quotation_totals_card.dart';
import 'package:frontendmobile/features/inventory/quotations/presentation/widgets/quotation_export_sheet.dart';
import '../../domain/entities/quotation_enums.dart';
import '../providers/quotation_provider.dart';
import '../widgets/quotation_item_form_sheet.dart';
import 'quotation_form_screen.dart';

class QuotationDetailScreen extends ConsumerWidget {
  final int quotationId;
  const QuotationDetailScreen({super.key, required this.quotationId});

  Future<void> _confirmDelete(BuildContext context, WidgetRef ref) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete quotation?'),
        content: const Text('This action cannot be undone. Continue?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text('Delete', style: TextStyle(color: Pallets.error)),
          ),
        ],
      ),
    );
    if (confirmed == true) {
      await ref
          .read(quotationListNotifierProvider.notifier)
          .deleteQuotation(quotationId);
      if (context.mounted) Navigator.pop(context);
    }
  }

  Future<void> _changeStatus(
    BuildContext context,
    WidgetRef ref,
    QuotationStatus current,
  ) async {
    final selected = await showModalBottomSheet<QuotationStatus>(
      context: context,
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            for (final s in QuotationStatus.values)
              ListTile(
                leading: Icon(Icons.circle, size: 12, color: s.color),
                title: Text(s.label),
                trailing: s == current ? const Icon(Icons.check) : null,
                onTap: () => Navigator.pop(ctx, s),
              ),
          ],
        ),
      ),
    );
    if (selected != null && selected != current && context.mounted) {
      try {
        final usecase = await ref.read(quotationUsecaseProvider.future);
        await usecase.updateStatus(quotationId, selected);
        ref.invalidate(quotationDetailNotifierProvider(quotationId));
        ref.invalidate(quotationListNotifierProvider);
      } catch (e) {
        if (context.mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('$e')));
        }
      }
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final quotationAsync = ref.watch(
      quotationDetailNotifierProvider(quotationId),
    );

    return Scaffold(
      backgroundColor: isDark
          ? Pallets.backgroundDark
          : Pallets.backgroundLight,
      appBar: AppBar(
        title: const Text('Quotation Details'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          quotationAsync.maybeWhen(
            data: (q) => Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.ios_share_rounded),
                  tooltip: 'Send to client',
                  onPressed: () => showQuotationExportSheet(
                    context,
                    ref,
                    quotation: q,
                    items: q.items,
                  ),
                ),
                if (q.isEditable)
                  IconButton(
                    icon: const Icon(Icons.edit_outlined),
                    onPressed: () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => QuotationFormScreen(existing: q),
                      ),
                    ),
                  ),
                PopupMenuButton<String>(
                  onSelected: (value) {
                    if (value == 'status') {
                      _changeStatus(context, ref, q.status);
                    } else if (value == 'delete' && q.isDeletable) {
                      _confirmDelete(context, ref);
                    }
                  },
                  itemBuilder: (ctx) => [
                    const PopupMenuItem(
                      value: 'status',
                      child: Text('Change status'),
                    ),
                    if (q.isDeletable)
                      PopupMenuItem(
                        value: 'delete',
                        child: Text(
                          'Delete',
                          style: TextStyle(color: Pallets.error),
                        ),
                      ),
                  ],
                ),
              ],
            ),
            orElse: () => const SizedBox.shrink(),
          ),
        ],
      ),
      floatingActionButton: quotationAsync.maybeWhen(
        data: (q) => FloatingActionButton.extended(
          backgroundColor: Pallets.blurple,
          foregroundColor: Pallets.onAccent,
          icon: const Icon(Icons.add),
          label: const Text('Add Item'),
          onPressed: () async {
            final nextOrder = q.items.length + 1;
            final item = await showQuotationItemFormSheet(
              context,
              nextSortOrder: nextOrder,
            );
            if (item == null) return;
            try {
              final usecase = await ref.read(quotationUsecaseProvider.future);
              await usecase.addItem(
                quotationId,
                sortOrder: item.sortOrder,
                itemName: item.itemName,
                size: item.size,
                pages: item.pages,
                printSide: item.printSide,
                colorSpec: item.colorSpec,
                finishing: item.finishing,
                quantity: item.quantity,
                unitPrice: item.unitPrice,
                note: item.note,
              );
              ref.invalidate(quotationDetailNotifierProvider(quotationId));
              ref.invalidate(quotationListNotifierProvider);
            } catch (e) {
              if (context.mounted) {
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text('$e')));
              }
            }
          },
        ),
        orElse: () => null,
      ),
      body: quotationAsync.when(
        loading: () => const QuotationDetailShimmer(itemCount: 3),
        error: (error, _) => Center(
          child: Text('$error', style: TextStyle(color: Pallets.error)),
        ),
        data: (q) => RefreshIndicator(
          onRefresh: () => ref
              .read(quotationDetailNotifierProvider(quotationId).notifier)
              .refresh(),
          child: ListView(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 100),
            children: [
              QuotationHeaderCard(quotation: q),
              const SizedBox(height: 20),
              QuotationItemsSection(
                items: q.items,
                onEdit: (item) async {
                  final updated = await showQuotationItemFormSheet(
                    context,
                    initial: item,
                    nextSortOrder: item.sortOrder,
                  );
                  if (updated == null) return;
                  try {
                    final usecase = await ref.read(
                      quotationUsecaseProvider.future,
                    );
                    await usecase.updateItem(
                      quotationId,
                      item.itemId,
                      itemName: updated.itemName,
                      size: updated.size,
                      pages: updated.pages,
                      printSide: updated.printSide,
                      colorSpec: updated.colorSpec,
                      finishing: updated.finishing,
                      quantity: updated.quantity,
                      unitPrice: updated.unitPrice,
                      note: updated.note,
                    );
                    ref.invalidate(
                      quotationDetailNotifierProvider(quotationId),
                    );
                    ref.invalidate(quotationListNotifierProvider);
                  } catch (e) {
                    if (context.mounted) {
                      ScaffoldMessenger.of(
                        context,
                      ).showSnackBar(SnackBar(content: Text('$e')));
                    }
                  }
                },
                onDelete: (item) async {
                  try {
                    final usecase = await ref.read(
                      quotationUsecaseProvider.future,
                    );
                    await usecase.deleteItem(quotationId, item.itemId);
                    ref.invalidate(
                      quotationDetailNotifierProvider(quotationId),
                    );
                    ref.invalidate(quotationListNotifierProvider);
                  } catch (e) {
                    if (context.mounted) {
                      ScaffoldMessenger.of(
                        context,
                      ).showSnackBar(SnackBar(content: Text('$e')));
                    }
                  }
                },
              ),
              const SizedBox(height: 20),
              QuotationTotalsCard(quotation: q),
            ],
          ),
        ),
      ),
    );
  }
}
