import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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

  // ── Lifecycle ──────────────────────────────────────────────────────────────
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

  // ── Create ─────────────────────────────────────────────────────────────────
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

  // ── Edit ───────────────────────────────────────────────────────────────────
  Future<void> _openEdit(int id) async {
    final category = ref
        .read(categoryNotifierProvider)
        .categories
        .firstWhere((c) => c.categoryId == id);
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

  // ── Delete ─────────────────────────────────────────────────────────────────
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

  // ── Bottom sheet options ───────────────────────────────────────────────────

  void _showOptions(int id, String name) {
    showModalBottomSheet(
      context: context,
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
                color: Colors.grey.shade300,
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
                  style: const TextStyle(
                    fontSize: 13,
                    color: Color(0xFF8E8E93),
                  ),
                ),
              ),
            ),
            const Divider(height: 16),
            ListTile(
              leading: const Icon(Icons.edit_outlined, size: 20),
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
                color: Color(0xFFA32D2D),
              ),
              title: const Text(
                'Delete',
                style: TextStyle(fontSize: 14, color: Color(0xFFA32D2D)),
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

  // ── Build ──────────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    ////////////////////////////////////////////////////////////////////////////
    ///
    ////////////////////////////////////////////////////////////////////////////
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = isDark ? const Color(0xFF1C1C1E) : const Color(0xFFF5F5F4);
    final cardBg = isDark ? const Color(0xFF2C2C2E) : Colors.white;
    final borderColor = isDark
        ? const Color(0xFF3A3A3C)
        : const Color(0xFFE0DED8);
    final searchBg = isDark ? const Color(0xFF3A3A3C) : const Color(0xFFEFEFED);
    final subText = isDark ? const Color(0xFF8E8E93) : const Color(0xFF6B6B6B);
    final state = ref.watch(categoryNotifierProvider);
    final notifier = ref.read(categoryNotifierProvider.notifier);

    final filtered = state.categories
        .where(
          (c) =>
              _query.isEmpty ||
              c.categoryName.toLowerCase().contains(_query.toLowerCase()),
        )
        .toList();
    ////////////////////////////////////////////////////////////////////////////
    ///
    ////////////////////////////////////////////////////////////////////////////

    return Scaffold(
      backgroundColor: bg,
      //////////////////////////////////////////////////////////////////////////
      ///
      //////////////////////////////////////////////////////////////////////////
      appBar: AppBar(
        backgroundColor: cardBg,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        title: const Text(
          'Categories',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(0.5),
          child: Divider(height: 0.5, thickness: 0.5, color: borderColor),
        ),
      ),
      //////////////////////////////////////////////////////////////////////////
      ///
      //////////////////////////////////////////////////////////////////////////
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _openCreate,
        backgroundColor: const Color(0xFF3B82F6),
        foregroundColor: Colors.white,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        icon: const Icon(Icons.add_rounded),
        label: const Text(
          'Add Category',
          style: TextStyle(fontWeight: FontWeight.w500),
        ),
      ),

      //////////////////////////////////////////////////////////////////////////
      ///
      //////////////////////////////////////////////////////////////////////////
      body: Column(
        children: [
          if (state.error != null)
            ErrorBanner(message: state.error!, onDismiss: notifier.clearError),
          Container(
            color: cardBg,
            padding: const EdgeInsets.fromLTRB(16, 10, 16, 12),

            child: Container(
              //////////////////////////////////////////////////////////////////
              ///
              //////////////////////////////////////////////////////////////////
              decoration: BoxDecoration(
                color: searchBg,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: borderColor, width: 0.5),
              ),
              //////////////////////////////////////////////////////////////////
              ///
              //////////////////////////////////////////////////////////////////
              child: TextField(
                controller: _searchCtrl,
                style: const TextStyle(fontSize: 14),
                decoration: InputDecoration(
                  hintText: 'Search categories…',
                  hintStyle: TextStyle(fontSize: 14, color: subText),
                  prefixIcon: const Icon(Icons.search_rounded, size: 18),
                  suffixIcon: _query.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.close_rounded, size: 16),
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
          ///
          //////////////////////////////////////////////////////////////////////
          Divider(height: 0.5, thickness: 0.5, color: borderColor),
          Expanded(
            child: state.isLoading
                ////////////////////////////////////////////////////////////////
                ///
                ////////////////////////////////////////////////////////////////
                ? CategoryGridShimmer(cardBg: cardBg, borderColor: borderColor)
                ////////////////////////////////////////////////////////////////
                ///
                ////////////////////////////////////////////////////////////////
                : filtered.isEmpty
                ? EmptyState(
                    icon: Icons.category_outlined,
                    title: 'No categories yet',
                    message: 'Add your first category to organize products.',
                    actionLabel: 'Add Category',
                    onAction: _openCreate,
                  )
                ////////////////////////////////////////////////////////////////
                ///
                ////////////////////////////////////////////////////////////////
                : RefreshIndicator(
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

                        ////////////////////////////////////////////////////////
                        ///
                        ////////////////////////////////////////////////////////
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
