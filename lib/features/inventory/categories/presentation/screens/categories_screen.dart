import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontendmobile/core/themes/app_pallets.dart';
import 'package:frontendmobile/core/utils/error_banner.dart';
import 'package:frontendmobile/core/widgets/alertmessage/app_snacker.dart';
import 'package:frontendmobile/core/widgets/alertmessage/dialog_helper.dart';
import 'package:frontendmobile/core/widgets/shimmer/category_shimmer.dart';
import 'package:go_router/go_router.dart';
import '../../../../../core/utils/emty_state.dart' show EmptyState;
import '../providers/category_provider.dart';
import '../widgets/category_card.dart';
import '../widgets/category_form_page.dart';

class CategoriesScreen extends ConsumerStatefulWidget {
  const CategoriesScreen({super.key});
  @override
  ConsumerState<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends ConsumerState<CategoriesScreen> {
  final _searchCtrl = TextEditingController();
  String _query = '';

  @override
  void initState() {
    super.initState();
    Future.microtask(
      () => ref.read(categoryNotifierProvider.notifier).loadAll(),
    );
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  Future<void> _openCreate() async {
    final result = await Navigator.of(context).push<Map<String, dynamic>>(
      MaterialPageRoute(builder: (_) => const CategoryFormPage()),
    );
    if (result == null || !mounted) return;
    final ok = await ref
        .read(categoryNotifierProvider.notifier)
        .create(categoryName: result['category_name'], image: result['image']);
    if (!mounted) return;
    AppSnackBar.show(
      context,
      message: ok
          ? 'Category created successfully.'
          : 'Failed to create category.',
      type: ok ? SnackType.success : SnackType.error,
    );
  }

  // ── Edit — now with a safe fallback instead of an uncaught throw ──
  Future<void> _openEdit(int id) async {
    final category = ref
        .read(categoryNotifierProvider)
        .categories
        .where((c) => c.categoryId == id)
        .firstOrNull;

    if (category == null) {
      if (!mounted) return;
      AppSnackBar.show(
        context,
        message: 'This category no longer exists.',
        type: SnackType.error,
      );
      return;
    }

    final result = await Navigator.of(context).push<Map<String, dynamic>>(
      MaterialPageRoute(builder: (_) => CategoryFormPage(existing: category)),
    );
    if (result == null || !mounted) return;
    final ok = await ref
        .read(categoryNotifierProvider.notifier)
        .update(
          categoryId: id,
          categoryName: result['category_name'],
          image: result['image'],
        );

    if (!mounted) return;

    if (!ok) {
      AppSnackBar.show(
        context,
        message: 'Failed to update category.',
        type: SnackType.error,
      );
    }
  }

  Future<void> _confirmDelete(int id, String name) async {
    final confirmed = await AppDialog.confirm(
      context,
      title: 'Delete Category',
      message:
          'Are you sure you want to delete "$name"?\nThis cannot be undone.',
      confirmLabel: 'Delete',
      isDanger: true,
    );

    if (confirmed != true || !mounted) return;
    final ok = await ref.read(categoryNotifierProvider.notifier).delete(id);
    if (!mounted) return;
    AppSnackBar.show(
      context,
      message: ok ? 'Category "$name" deleted.' : 'Failed to delete category.',
      type: ok ? SnackType.success : SnackType.error,
    );
  }

  void _showOptions(int id, String name) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final surface = isDark ? Pallets.surfaceOverlay : Pallets.surfaceLight;
    final textSecondary = isDark
        ? Pallets.textSecondaryDark
        : Pallets.textSecondaryLight;
    final border = isDark ? Pallets.borderDark : Pallets.borderLight;

    showModalBottomSheet(
      context: context,
      backgroundColor: surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 8),
            Container(
              width: 36,
              height: 4,
              decoration: BoxDecoration(
                color: border,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  name,
                  style: TextStyle(fontSize: 13, color: textSecondary),
                ),
              ),
            ),
            Divider(height: 16, color: border),
            ListTile(
              leading: const Icon(
                Icons.edit_outlined,
                size: 20,
                color: Pallets.blurple,
              ),
              title: const Text('Edit', style: TextStyle(fontSize: 14)),
              onTap: () {
                Navigator.pop(context);
                _openEdit(id);
              },
            ),
            ListTile(
              leading: const Icon(
                Icons.delete_outline,
                size: 20,
                color: Pallets.error,
              ),
              title: const Text(
                'Delete',
                style: TextStyle(fontSize: 14, color: Pallets.error),
              ),
              onTap: () {
                Navigator.pop(context);
                _confirmDelete(id, name);
              },
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = isDark ? Pallets.backgroundDark : Pallets.backgroundLight;
    final cardBg = isDark ? Pallets.surfaceCard : Pallets.surfaceLight;
    final borderColor = isDark ? Pallets.borderDark : Pallets.borderLight;
    final searchBg = isDark ? Pallets.surfaceElevated : Pallets.backgroundLight;
    final subText = isDark
        ? Pallets.textSecondaryDark
        : Pallets.textSecondaryLight;
    final textPrimary = isDark
        ? Pallets.textPrimaryDark
        : Pallets.textPrimaryLight;

    final state = ref.watch(categoryNotifierProvider);
    final notifier = ref.read(categoryNotifierProvider.notifier);

    final filtered = state.categories
        .where(
          (c) =>
              _query.isEmpty ||
              c.categoryName.toLowerCase().contains(_query.toLowerCase()),
        )
        .toList();

    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        backgroundColor: cardBg,
        elevation: 0,
        surfaceTintColor: Pallets.transparent,
        title: Text(
          'Categories',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: textPrimary,
          ),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(0.5),
          child: Divider(height: 0.5, thickness: 0.5, color: borderColor),
        ),
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
          onPressed: _openCreate,
          backgroundColor: Pallets.transparent,
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          icon: const Icon(Icons.add_rounded),
          label: const Text(
            'Add Category',
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
        ),
      ),
      body: Column(
        children: [
          if (state.error != null)
            ErrorBanner(message: state.error!, onDismiss: notifier.clearError),
          Container(
            color: cardBg,
            padding: const EdgeInsets.fromLTRB(16, 10, 16, 12),
            child: Container(
              decoration: BoxDecoration(
                color: searchBg,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: borderColor, width: 0.5),
              ),
              child: TextField(
                controller: _searchCtrl,
                style: TextStyle(fontSize: 14, color: textPrimary),
                decoration: InputDecoration(
                  hintText: 'Search categories…',
                  hintStyle: TextStyle(fontSize: 14, color: subText),
                  prefixIcon: Icon(
                    Icons.search_rounded,
                    size: 18,
                    color: subText,
                  ),
                  suffixIcon: _query.isNotEmpty
                      ? IconButton(
                          icon: Icon(
                            Icons.close_rounded,
                            size: 16,
                            color: subText,
                          ),
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
          Divider(height: 0.5, thickness: 0.5, color: borderColor),
          Expanded(
            child: state.isLoading
                ? CategoryGridShimmer(cardBg: cardBg, borderColor: borderColor)
                : filtered.isEmpty
                ? EmptyState(
                    icon: Icons.category_outlined,
                    title: 'No categories yet',
                    message: 'Add your first category to organize products.',
                    actionLabel: 'Add Category',
                    onAction: _openCreate,
                  )
                : RefreshIndicator(
                    color: Pallets.blurple,
                    backgroundColor: cardBg,
                    onRefresh: notifier.loadAll,
                    child: GridView.builder(
                      padding: const EdgeInsets.fromLTRB(16, 14, 16, 100),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            mainAxisSpacing: 12,
                            crossAxisSpacing: 12,
                            childAspectRatio: 0.85,
                          ),
                      itemCount: filtered.length,
                      itemBuilder: (_, i) {
                        final c = filtered[i];
                        final isCardLoading = state.loadingIds.contains(
                          c.categoryId,
                        );

                        return CategoryCard(
                          category: c,
                          cardBg: cardBg,
                          borderColor: borderColor,
                          isLoading: isCardLoading,
                          onTap: isCardLoading
                              ? null
                              : () => context.pushNamed(
                                  'categoryDetail',
                                  pathParameters: {
                                    'id': c.categoryId.toString(),
                                  },
                                ),
                          onEdit: isCardLoading
                              ? () {}
                              : () => _openEdit(c.categoryId),
                          onDelete: isCardLoading
                              ? () {}
                              : () => _confirmDelete(
                                  c.categoryId,
                                  c.categoryName,
                                ),
                          onOptions: isCardLoading
                              ? null
                              : () =>
                                    _showOptions(c.categoryId, c.categoryName),
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
