import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontendmobile/core/themes/app_pallets.dart';
import 'package:frontendmobile/core/utils/confirm_delete_dialog.dart';
import 'package:frontendmobile/core/utils/error_banner.dart';
import 'package:frontendmobile/core/widgets/alertmessage/app_snacker.dart';
import 'package:frontendmobile/core/widgets/shimmer/app_list_shimmer.dart';
import 'package:frontendmobile/features/inventory/product/presentation/screens/product_form_screen.dart';
import 'package:frontendmobile/features/inventory/product/presentation/widgets/category_chip.dart'
    show CategoryChip;
import 'package:frontendmobile/features/inventory/stock_movements/presentation/screens/stock_movement_report_screen.dart';
import '../providers/product_provider.dart';
import '../widgets/product_tile.dart';
import '../../../categories/presentation/providers/category_provider.dart';
import 'product_detail_screen.dart';

class ProductsScreen extends ConsumerStatefulWidget {
  const ProductsScreen({super.key});

  @override
  ConsumerState<ProductsScreen> createState() => _ProductsScreenState();
}

class _ProductsScreenState extends ConsumerState<ProductsScreen> {
  final _searchCtrl = TextEditingController();
  String _query = '';
  int? _categoryFilter;

  bool get _isDark => Theme.of(context).brightness == Brightness.dark;
  Color get _bg => _isDark ? Pallets.backgroundDark : Pallets.backgroundLight;
  Color get _card => _isDark ? Pallets.surfaceCard : Pallets.surfaceLight;
  Color get _border => _isDark ? Pallets.borderDark : Pallets.borderLight;
  Color get _searchBg =>
      _isDark ? Pallets.surfaceElevated : Pallets.backgroundLight;
  Color get _sub =>
      _isDark ? Pallets.textSecondaryDark : Pallets.textSecondaryLight;
  Color get _textPrimary =>
      _isDark ? Pallets.textPrimaryDark : Pallets.textPrimaryLight;

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(productNotifierProvider.notifier).loadAll();
      ref.read(categoryNotifierProvider.notifier).loadAll();
    });
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  Future<void> _openCreate() async {
    final categories = ref.read(categoryNotifierProvider).categories;
    final result = await Navigator.of(context).push<Map<String, dynamic>>(
      MaterialPageRoute(
        builder: (_) => ProductFormScreen(categories: categories),
      ),
    );
    if (result == null || !mounted) return;

    final ok = await ref
        .read(productNotifierProvider.notifier)
        .create(
          name: result['name'],
          categoryId: result['category_id'],
          description: result['description'],
        );
    if (!mounted) return;
    AppSnackBar.show(
      context,
      message: ok
          ? 'Product created successfully.'
          : 'Failed to create product.',
      type: ok ? SnackType.success : SnackType.error,
    );
  }

  Future<void> _openEdit(int id) async {
    final product = ref
        .read(productNotifierProvider)
        .products
        .where((p) => p.productId == id)
        .firstOrNull;
    final categories = ref.read(categoryNotifierProvider).categories;

    final result = await Navigator.of(context).push<Map<String, dynamic>>(
      MaterialPageRoute(
        builder: (_) =>
            ProductFormScreen(existing: product, categories: categories),
      ),
    );
    if (result == null || !mounted) return;

    final ok = await ref
        .read(productNotifierProvider.notifier)
        .updateProduct(
          productId: id,
          name: result['name'],
          categoryId: result['category_id'],
          description: result['description'],
        );
    if (!mounted) return;
    AppSnackBar.show(
      context,
      message: ok
          ? 'Product updated successfully.'
          : 'Failed to update product.',
      type: ok ? SnackType.success : SnackType.error,
    );
  }

  Future<void> _confirmDelete(int id, String name) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => ConfirmDeleteDialog(
        title: 'Delete Product',
        message:
            'Are you sure you want to delete "$name"? This will also remove all its images.',
      ),
    );
    if (confirmed != true || !mounted) return;

    final ok = await ref.read(productNotifierProvider.notifier).delete(id);
    if (!mounted) return;
    AppSnackBar.show(
      context,
      message: ok ? 'Product "$name" deleted.' : 'Failed to delete product.',
      type: ok ? SnackType.success : SnackType.error,
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(productNotifierProvider);
    final notifier = ref.read(productNotifierProvider.notifier);
    final categories = ref.watch(categoryNotifierProvider).categories;

    final filtered = state.products.where((p) {
      final matchesQuery =
          _query.isEmpty || p.name.toLowerCase().contains(_query.toLowerCase());
      final matchesCategory =
          _categoryFilter == null || p.categoryId == _categoryFilter;
      return matchesQuery && matchesCategory;
    }).toList();

    return Scaffold(
      backgroundColor: _bg,
      appBar: AppBar(
        backgroundColor: _card,
        elevation: 0,
        surfaceTintColor: Pallets.transparent,
        title: Text(
          'Products',
          style: TextStyle(fontWeight: FontWeight.w600, color: _textPrimary),
        ),
        actions: [
          TextButton.icon(
            icon: Icon(Icons.bar_chart_outlined, color: _textPrimary, size: 18),
            label: Text(
              'Stock Report',
              style: TextStyle(
                color: _textPrimary,
                fontWeight: FontWeight.w600,
              ),
            ),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => const StockMovementReportScreen(),
                ),
              );
            },
          ),
        ],
      ),
      floatingActionButton: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: Pallets.brandGradient,
          boxShadow: [
            BoxShadow(
              color: Pallets.blurple.withOpacity(0.35),
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: FloatingActionButton.extended(
          onPressed: state.isCreating ? null : _openCreate,
          backgroundColor: Pallets.transparent,
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          icon: const Icon(Icons.add),
          label: const Text(
            'Add Product',
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
        ),
      ),
      body: Column(
        children: [
          if (state.error != null)
            ErrorBanner(message: state.error!, onDismiss: notifier.clearError),

          // Search bar
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
            child: Container(
              decoration: BoxDecoration(
                color: _searchBg,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: _border, width: 0.5),
              ),
              child: TextField(
                controller: _searchCtrl,
                style: TextStyle(fontSize: 15, color: _textPrimary),
                decoration: InputDecoration(
                  hintText: 'Search products…',
                  hintStyle: TextStyle(color: _sub, fontSize: 15),
                  prefixIcon: Icon(Icons.search, color: _sub, size: 20),
                  suffixIcon: _query.isNotEmpty
                      ? IconButton(
                          icon: Icon(Icons.close, color: _sub, size: 18),
                          onPressed: () {
                            _searchCtrl.clear();
                            setState(() => _query = '');
                          },
                        )
                      : null,
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(vertical: 12),
                ),
                onChanged: (v) => setState(() => _query = v),
              ),
            ),
          ),

          // Category chips
          if (categories.isNotEmpty)
            SizedBox(
              height: 40,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                children: [
                  CategoryChip(
                    label: 'All',
                    selected: _categoryFilter == null,
                    onTap: () => setState(() => _categoryFilter = null),
                    selectedColor: Pallets.blurple,
                    border: _border,
                    sub: _sub,
                  ),
                  ...categories.map(
                    (c) => CategoryChip(
                      label: c.categoryName,
                      selected: _categoryFilter == c.categoryId,
                      onTap: () => setState(
                        () => _categoryFilter = _categoryFilter == c.categoryId
                            ? null
                            : c.categoryId,
                      ),
                      selectedColor: Pallets.blurple,
                      border: _border,
                      sub: _sub,
                    ),
                  ),
                ],
              ),
            ),

          const SizedBox(height: 4),

          // Product list
          Expanded(
            child: state.isLoading
                ? const AppListShimmer(itemCount: 6)
                : filtered.isEmpty
                ? Center(
                    child: Text(
                      _query.isNotEmpty
                          ? 'No products match "$_query".'
                          : 'No products yet.',
                      style: TextStyle(fontSize: 14, color: _sub),
                    ),
                  )
                : RefreshIndicator(
                    color: Pallets.blurple,
                    backgroundColor: _card,
                    onRefresh: notifier.loadAll,
                    child: ListView.separated(
                      padding: const EdgeInsets.fromLTRB(16, 4, 16, 100),
                      itemCount: filtered.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 10),
                      itemBuilder: (_, i) {
                        final p = filtered[i];
                        final isWorking = state.loadingIds.contains(
                          p.productId,
                        );
                        return ProductTile(
                          product: p,
                          isWorking: isWorking,
                          onEdit: isWorking
                              ? null
                              : () => _openEdit(p.productId),
                          onDelete: isWorking
                              ? null
                              : () => _confirmDelete(p.productId, p.name),
                          onTap: isWorking
                              ? null
                              : () => Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (_) => ProductDetailScreen(
                                      productId: p.productId,
                                    ),
                                  ),
                                ),
                        );
                      },
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
