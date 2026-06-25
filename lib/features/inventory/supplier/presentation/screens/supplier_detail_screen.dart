import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontendmobile/core/themes/supplier_color.dart';
import 'package:frontendmobile/features/inventory/supplier/domain/entities/supplier.dart';
import 'package:frontendmobile/features/inventory/supplier/presentation/widgets/supplier_form_screen.dart';
import 'package:frontendmobile/features/inventory/supplier/presentation/widgets/supplier_info_tile.dart';
import 'package:frontendmobile/features/inventory/supplier_product_price/presentation/screens/supplier_product_price_list_screen.dart';
import 'package:frontendmobile/features/inventory/supplier_product_price/presentation/providers/supplier_product_price_provider.dart';
import 'package:frontendmobile/features/inventory/product/presentation/providers/product_provider.dart';
import '../providers/supplier_provider.dart';

class SupplierDetailScreen extends ConsumerStatefulWidget {
  final int supplierId;
  const SupplierDetailScreen({super.key, required this.supplierId});

  @override
  ConsumerState<SupplierDetailScreen> createState() =>
      _SupplierDetailScreenState();
}

class _SupplierDetailScreenState extends ConsumerState<SupplierDetailScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => ref.read(variantLabelsProvider.future));
  }

  void _openEdit(SupplierEntity supplier) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => SupplierFormScreen(existing: supplier)),
    );
  }

  void _openAddPrice(SupplierEntity supplier) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => SupplierProductPriceListScreen(
          supplierId: supplier.supplierId,
          supplierNames: {supplier.supplierId: supplier.name},
          variantLabels: ref.read(variantLabelsProvider).value ?? {},
        ),
      ),
    );
  }




  @override
  Widget build(BuildContext context) {



    final theme = Theme.of(context);
    final c = SupplierColors.of(context);
    final colors = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;
    final borderColor = isDark
        ? const Color(0xFF2C2C2C)
        : const Color(0xFFE8E6E1);
    final subText = isDark ? const Color(0xFF8E8E93) : const Color(0xFF6B6B6B);

    final state = ref.watch(supplierNotifierProvider);
    final supplier = state.suppliers.cast<SupplierEntity?>().firstWhere(
      (s) => s?.supplierId == widget.supplierId,
      orElse: () => null,
    );

    if (supplier == null) {
      return Scaffold(
        backgroundColor: c.background,
        appBar: AppBar(
          backgroundColor: c.background,
          elevation: 0,
          title: Text('Detail view', style: TextStyle(color: c.textPrimary)),
        ),
        body: Center(
          child: Text(
            'Supplier not found or has been removed.',
            style: TextStyle(color: c.textSecondary),
          ),
        ),
      );
    }

    final isWorking = state.loadingIds.contains(supplier.supplierId);

    return Scaffold(
      backgroundColor: c.background,
      appBar: AppBar(
        backgroundColor: c.background,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        title: Text(
          supplier.name,
          style: TextStyle(color: c.textPrimary, fontWeight: FontWeight.w600),
        ),
        actions: [
          if (!isWorking)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: TextButton.icon(
                onPressed: () => _openEdit(supplier),
                icon: const Icon(Icons.edit_outlined, size: 15),
                label: const Text('Edit', style: TextStyle(fontSize: 13)),
                style: TextButton.styleFrom(
                  foregroundColor: const Color(0xFF3B82F6),
                  backgroundColor: const Color(0xFFE6F1FB),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 6,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Avatar / Header ──────────────────────────────────────────
            Container(
              width: double.infinity,
              color: c.surfaceMuted,
              padding: const EdgeInsets.symmetric(vertical: 40),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 52,
                    backgroundColor: c.accentMuted,
                    backgroundImage: supplier.avatarUrl != null
                        ? NetworkImage(supplier.avatarUrl!)
                        : null,
                    child: supplier.avatarUrl == null
                        ? Text(
                            supplier.name.isNotEmpty
                                ? supplier.name[0].toUpperCase()
                                : '?',
                            style: TextStyle(
                              fontSize: 32,
                              color: c.accent,
                              fontWeight: FontWeight.w600,
                            ),
                          )
                        : null,
                  ),
                  const SizedBox(height: 18),
                  Text(
                    supplier.name,
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: c.textPrimary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),

            // ── Info card ────────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 16),
              child: Container(
                decoration: BoxDecoration(
                  color: c.surface,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: c.border),
                ),
                child: Column(
                  children: [
                    InfoTile(
                      icon: Icons.person_outline,
                      label: 'Contact person',
                      value: supplier.contactPerson,
                      c: c,
                    ),
                    Divider(height: 1, color: c.border, indent: 56),
                    InfoTile(
                      icon: Icons.phone_outlined,
                      label: 'Phone',
                      value: supplier.phone,
                      c: c,
                    ),
                    if (supplier.phone2 != null) ...[
                      Divider(height: 1, color: c.border, indent: 56),
                      InfoTile(
                        icon: Icons.phone_outlined,
                        label: 'Phone 2',
                        value: supplier.phone2,
                        c: c,
                      ),
                    ],
                    Divider(height: 1, color: c.border, indent: 56),
                    InfoTile(
                      icon: Icons.email_outlined,
                      label: 'Email',
                      value: supplier.email,
                      c: c,
                    ),
                    Divider(height: 1, color: c.border, indent: 56),
                    InfoTile(
                      icon: Icons.location_on_outlined,
                      label: 'Address',
                      value: supplier.address,
                      maxLines: 3,
                      c: c,
                    ),
                  ],
                ),
              ),
            ),

            // ── Prices section header ─────────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 8, 16, 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'SUPPLIER PRICES',
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: subText,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.7,
                    ),
                  ),
                  TextButton.icon(
                    onPressed: () => _openAddPrice(supplier),
                    icon: const Icon(Icons.add, size: 15),
                    label: const Text('Add', style: TextStyle(fontSize: 13)),
                    style: TextButton.styleFrom(
                      foregroundColor: colors.primary,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // ── Inline prices list ────────────────────────────────────────
            _SupplierPriceInlineList(
              supplierId: supplier.supplierId,
              supplierName: supplier.name,
              onManage: () => _openAddPrice(supplier),
            ),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────

class _SupplierPriceInlineList extends ConsumerStatefulWidget {
  final int supplierId;
  final String supplierName;
  final VoidCallback onManage;

  const _SupplierPriceInlineList({
    required this.supplierId,
    required this.supplierName,
    required this.onManage,
  });

  @override
  ConsumerState<_SupplierPriceInlineList> createState() =>
      _SupplierPriceInlineListState();
}

class _SupplierPriceInlineListState
    extends ConsumerState<_SupplierPriceInlineList> {
  @override
  void initState() {
    super.initState();
    // ✅ actually call loadAll with supplierId
    Future.microtask(
      () => ref
          .read(supplierProductPriceNotifierProvider.notifier)
          .loadAll(supplierId: widget.supplierId),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(supplierProductPriceNotifierProvider);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final cardBg = isDark ? const Color(0xFF2C2C2E) : Colors.white;
    final borderColor = isDark
        ? const Color(0xFF3A3A3C)
        : const Color(0xFFE0DED8);
    final subText = isDark ? const Color(0xFF8E8E93) : const Color(0xFF6B6B6B);
    final colors = theme.colorScheme;

    if (state.isLoading && state.prices.isEmpty) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 32),
        child: Center(child: CircularProgressIndicator()),
      );
    }

    final prices = state.prices
        .where((p) => p.supplierId == widget.supplierId)
        .toList();

    if (prices.isEmpty) {
      return Padding(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 8),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 28),
          decoration: BoxDecoration(
            color: cardBg,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: borderColor),
          ),
          child: Column(
            children: [
              Icon(Icons.price_change_outlined, size: 32, color: subText),
              const SizedBox(height: 8),
              Text(
                'No prices yet',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: subText,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Tap Add to set a supplier price',
                style: theme.textTheme.bodySmall?.copyWith(color: subText),
              ),
            ],
          ),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 8),
      child: Container(
        decoration: BoxDecoration(
          color: cardBg,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: borderColor),
        ),
        child: ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: prices.length,
          separatorBuilder: (_, __) =>
              Divider(height: 1, color: borderColor, indent: 16, endIndent: 16),
          itemBuilder: (_, i) {
            final price = prices[i];
            final isBusy = state.loadingIds.contains(price.priceId);

            return ListTile(
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 6,
              ),
              leading: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: colors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  Icons.inventory_2_outlined,
                  size: 20,
                  color: colors.primary,
                ),
              ),
              title: Text(
                price.productName,
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              subtitle: price.sku != null
                  ? Text(
                      price.sku!,
                      style: TextStyle(color: subText, fontSize: 12),
                    )
                  : price.note != null
                  ? Text(
                      price.note!,
                      style: TextStyle(color: subText, fontSize: 12),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    )
                  : null,
              trailing: isBusy
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : Text(
                      '\$${price.unitPrice.toStringAsFixed(2)}',
                      style: theme.textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: colors.primary,
                      ),
                    ),
            );
          },
        ),
      ),
    );
  }
}
