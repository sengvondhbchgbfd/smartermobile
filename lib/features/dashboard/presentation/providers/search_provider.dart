import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontendmobile/config/routes/route_names.dart';
import 'package:frontendmobile/features/dashboard/presentation/searching/search_item.dart';
import 'package:frontendmobile/features/hr/staff/presentation/providers/staff_notifier.dart';
import 'package:frontendmobile/features/inventory/product/presentation/providers/product_provider.dart';

// ---------------------------------------------------------------------------
// Dynamic items
// ---------------------------------------------------------------------------
final searchDynamicItemsProvider = Provider<List<SearchItem>>((ref) {
  final items = <SearchItem>[];
  // ── Staff ─────────────────────────────────────────────────────────────────
  final staffList = ref.watch(staffNotifierProvider).valueOrNull ?? [];
  for (final staff in staffList) {
    items.add(
      SearchItem(
        title: staff.name,
        subtitle:
            staff.staffRole?.roleName ??
            staff.email ??
            staff.phone ??
            'Staff member',
        icon: Icons.person_outline,
        iconColor: Colors.orange,
        category: SearchCategory.staff,
        route: RouteNames.staffDetail,
        extra: staff.id,
      ),
    );
  }

  // ── Products ──────────────────────────────────────────────────────────────
  final products = ref.watch(productNotifierProvider).products;
  for (final product in products) {
    items.add(
      SearchItem(
        title: product.name,
        subtitle:
            '\$${product.price?.toStringAsFixed(2)} · Stock: ${product.stockQuantity}',
        icon: Icons.inventory_2_outlined,
        iconColor: Colors.indigo,
        category: SearchCategory.product,
        route: RouteNames.productDetail,
        extra: product.productId,
      ),
    );
  }
  return items;
});
// ---------------------------------------------------------------------------
// Providers
// ---------------------------------------------------------------------------
final searchQueryProvider = StateProvider<String>((ref) => '');
final selectedCategoryProvider = StateProvider<SearchCategory?>((ref) => null);
final searchResultsProvider = Provider<List<SearchItem>>((ref) {
  final query = ref.watch(searchQueryProvider);
  final dynamicItems = ref.watch(searchDynamicItemsProvider);

  if (query.trim().isEmpty) return dynamicItems;
  return dynamicItems.where((item) => item.matches(query)).toList();
});
final filteredSearchResultsProvider = Provider<List<SearchItem>>((ref) {
  final results = ref.watch(searchResultsProvider);
  final category = ref.watch(selectedCategoryProvider);
  if (category == null) return results;
  return results.where((i) => i.category == category).toList();
});
