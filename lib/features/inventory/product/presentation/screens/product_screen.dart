import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontendmobile/core/utils/confirm_delete_dialog.dart';
import 'package:frontendmobile/core/utils/error_banner.dart';
import 'package:frontendmobile/core/widgets/alertmessage/app_snacker.dart';
import 'package:frontendmobile/core/widgets/shimmer/app_list_shimmer.dart';
import 'package:frontendmobile/features/inventory/product/presentation/screens/product_form_screen.dart';
import 'package:frontendmobile/features/inventory/product/presentation/widgets/category_chip.dart'
    show CategoryChip;
import '../providers/product_provider.dart';
import '../widgets/product_tile.dart';
import '../../../categories/presentation/providers/category_provider.dart';
import 'product_detail_screen.dart';

class ProductsScreen extends ConsumerStatefulWidget {
  const ProductsScreen({super.key});

  @override
  ConsumerState<ProductsScreen> createState() => _ProductsScreenState();
}

////////////////////////////////////////////////////////////////////////////////
///
////////////////////////////////////////////////////////////////////////////////

class _ProductsScreenState extends ConsumerState<ProductsScreen> {
  //////////////////////////////////////////////////////////////////////////////
  ///
  //////////////////////////////////////////////////////////////////////////////
  final _searchCtrl = TextEditingController();
  String _query = '';
  int? _categoryFilter;

  bool get _isDark => Theme.of(context).brightness == Brightness.dark;
  Color get _bg => _isDark ? const Color(0xFF1C1C1E) : const Color(0xFFF5F5F4);
  Color get _card => _isDark ? const Color(0xFF2C2C2E) : Colors.white;
  Color get _border =>
      _isDark ? const Color(0xFF3A3A3C) : const Color(0xFFE0DED8);
  Color get _searchBg =>
      _isDark ? const Color(0xFF3A3A3C) : const Color(0xFFEFEFED);
  Color get _sub => _isDark ? const Color(0xFF8E8E93) : const Color(0xFF6B6B6B);
  //////////////////////////////////////////////////////////////////////////////
  ///
  //////////////////////////////////////////////////////////////////////////////
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(productNotifierProvider.notifier).loadAll();
      ref.read(categoryNotifierProvider.notifier).loadAll();
    });
  }
  //////////////////////////////////////////////////////////////////////////////
  ///
  //////////////////////////////////////////////////////////////////////////////

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  //////////////////////////////////////////////////////////////////////////////
  ///
  //////////////////////////////////////////////////////////////////////////////

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

  //////////////////////////////////////////////////////////////////////////////
  ///
  //////////////////////////////////////////////////////////////////////////////

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

  //////////////////////////////////////////////////////////////////////////////
  ///
  //////////////////////////////////////////////////////////////////////////////

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

  //////////////////////////////////////////////////////////////////////////////
  ///
  //////////////////////////////////////////////////////////////////////////////

  @override
  Widget build(BuildContext context) {
    ////////////////////////////////////////////////////////////////////////////
    ///
    ////////////////////////////////////////////////////////////////////////////
    final state = ref.watch(productNotifierProvider);
    final notifier = ref.read(productNotifierProvider.notifier);
    final categories = ref.watch(categoryNotifierProvider).categories;
    final colors = Theme.of(context).colorScheme;

    final filtered = state.products.where((p) {
      final matchesQuery =
          _query.isEmpty || p.name.toLowerCase().contains(_query.toLowerCase());
      final matchesCategory =
          _categoryFilter == null || p.categoryId == _categoryFilter;
      return matchesQuery && matchesCategory;
    }).toList();

    ////////////////////////////////////////////////////////////////////////////
    ///
    ////////////////////////////////////////////////////////////////////////////

    return Scaffold(
      backgroundColor: _bg,
      //////////////////////////////////////////////////////////////////////////
      ///
      //////////////////////////////////////////////////////////////////////////
      appBar: AppBar(
        backgroundColor: _card,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        title: const Text(
          'Products',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
      ),
      //////////////////////////////////////////////////////////////////////////
      ///
      //////////////////////////////////////////////////////////////////////////
      floatingActionButton: FloatingActionButton.extended(
        onPressed: state.isCreating ? null : _openCreate,
        backgroundColor: colors.primary,
        foregroundColor: colors.onPrimary,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        icon: const Icon(Icons.add),
        label: const Text(
          'Add Product',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
      ),
      //////////////////////////////////////////////////////////////////////////
      ///
      //////////////////////////////////////////////////////////////////////////
      body: Column(
        children: [
          if (state.error != null)
            ErrorBanner(message: state.error!, onDismiss: notifier.clearError),
          //////////////////////////////////////////////////////////////////////
          // Search bar
          //////////////////////////////////////////////////////////////////////
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
            child: Container(
              decoration: BoxDecoration(
                color: _searchBg,
                borderRadius: BorderRadius.circular(12),
              ),

              //////////////////////////////////////////////////////////////////
              ///
              //////////////////////////////////////////////////////////////////
              child: TextField(
                controller: _searchCtrl,
                style: const TextStyle(fontSize: 15),
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
              //////////////////////////////////////////////////////////////////
              ///
              //////////////////////////////////////////////////////////////////
            ),
          ),
          //////////////////////////////////////////////////////////////////////
          // Category chips
          //////////////////////////////////////////////////////////////////////
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
                    colors: colors,
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
                      colors: colors,
                      border: _border,
                      sub: _sub,
                    ),
                  ),
                ],
              ),
            ),

          const SizedBox(height: 4),
          //////////////////////////////////////////////////////////////////////
          // Product list
          //////////////////////////////////////////////////////////////////////
          Expanded(
            child: state.isLoading
                ? AppListShimmer(itemCount: 6)
                : filtered.isEmpty
                ? Center(
                    child: Text(
                      // ✅ was copy-pasted "No suppliers" text
                      _query.isNotEmpty
                          ? 'No products match "$_query".'
                          : 'No products yet.',
                      style: TextStyle(fontSize: 14, color: _sub),
                    ),
                  )
                : RefreshIndicator(
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
