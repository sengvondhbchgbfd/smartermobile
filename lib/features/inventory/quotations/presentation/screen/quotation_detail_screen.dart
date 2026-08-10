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

class QuotationDetailScreen extends ConsumerStatefulWidget {
  final int quotationId;
  const QuotationDetailScreen({super.key, required this.quotationId});

  @override
  ConsumerState<QuotationDetailScreen> createState() =>
      _QuotationDetailScreenState();
}

class _QuotationDetailScreenState extends ConsumerState<QuotationDetailScreen> {
  // Guards against double-tap firing the same add/edit/delete request twice
  // while the previous one is still in flight.
  bool _itemSubmitting = false;

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
          .deleteQuotation(widget.quotationId);
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
        await usecase.updateStatus(widget.quotationId, selected);
        ref.invalidate(quotationDetailNotifierProvider(widget.quotationId));
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

  // ── Add item: creates a brand-new item via addItem — correct as-is ──────
  Future<void> _addItem(BuildContext context, int nextOrder) async {
    if (_itemSubmitting) return;
    final item = await showQuotationItemFormSheet(
      context,
      nextSortOrder: nextOrder,
    );
    if (item == null) return;

    setState(() => _itemSubmitting = true);
    try {
      final usecase = await ref.read(quotationUsecaseProvider.future);
      await usecase.addItem(
        widget.quotationId,
        sortOrder: item.sortOrder,
        itemName: item.itemName,
        size: item.size,
        pages: item.pages,
        printSide: item.printSide,
        colorSpec: item.colorSpec,
        paperCover: item.paperCover,
        paperInside: item.paperInside,
        finishing: item.finishing,
        language: item.language,
        quantity: item.quantity,
        unitPrice: item.unitPrice,
        note: item.note,
        priceTiers: item.priceTiers,
      );
      ref.invalidate(quotationDetailNotifierProvider(widget.quotationId));
      ref.invalidate(quotationListNotifierProvider);
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('$e')));
      }
    } finally {
      if (mounted) setState(() => _itemSubmitting = false);
    }
  }

  // ── Edit item: MUST call updateItem (PATCH), using `updated` values ─────
  // This was previously calling `usecase.addItem(...)` with the stale
  // `item` values, which is why every "edit" created a brand-new duplicate
  // row instead of modifying the existing one, and tier/field edits never
  // actually saved.
  Future<void> _editItem(
    BuildContext context,
    dynamic item, // QuotationItemEntity — kept dynamic-free below
  ) async {
    if (_itemSubmitting) return;
    final updated = await showQuotationItemFormSheet(
      context,
      initial: item,
      nextSortOrder: item.sortOrder,
    );
    if (updated == null) return;

    setState(() => _itemSubmitting = true);
    try {
      final usecase = await ref.read(quotationUsecaseProvider.future);
      await usecase.updateItem(
        widget.quotationId,
        item.itemId,
        sortOrder: updated.sortOrder,
        itemName: updated.itemName,
        size: updated.size,
        pages: updated.pages,
        printSide: updated.printSide,
        colorSpec: updated.colorSpec,
        paperCover: updated.paperCover,
        paperInside: updated.paperInside,
        finishing: updated.finishing,
        language: updated.language,
        quantity: updated.quantity,
        unitPrice: updated.unitPrice,
        note: updated.note,
        priceTiers: updated.priceTiers,
      );
      ref.invalidate(quotationDetailNotifierProvider(widget.quotationId));
      ref.invalidate(quotationListNotifierProvider);
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('$e')));
      }
    } finally {
      if (mounted) setState(() => _itemSubmitting = false);
    }
  }

  Future<void> _deleteItem(BuildContext context, int itemId) async {
    if (_itemSubmitting) return;
    setState(() => _itemSubmitting = true);
    try {
      final usecase = await ref.read(quotationUsecaseProvider.future);
      await usecase.deleteItem(widget.quotationId, itemId);
      ref.invalidate(quotationDetailNotifierProvider(widget.quotationId));
      ref.invalidate(quotationListNotifierProvider);
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('$e')));
      }
    } finally {
      if (mounted) setState(() => _itemSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final quotationAsync = ref.watch(
      quotationDetailNotifierProvider(widget.quotationId),
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
          onPressed: _itemSubmitting
              ? null
              : () => _addItem(context, q.items.length + 1),
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
              .read(
                quotationDetailNotifierProvider(widget.quotationId).notifier,
              )
              .refresh(),
          child: ListView(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 100),
            children: [
              QuotationHeaderCard(quotation: q),
              const SizedBox(height: 20),
              QuotationItemsSection(
                items: q.items,
                onEdit: (item) => _editItem(context, item),
                onDelete: (item) => _deleteItem(context, item.itemId),
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
