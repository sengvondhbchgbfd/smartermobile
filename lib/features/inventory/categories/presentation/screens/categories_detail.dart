import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontendmobile/core/widgets/alertmessage/app_snacker.dart';
import 'package:frontendmobile/core/widgets/skeleton/category_detail_skeleton.dart';
import 'package:frontendmobile/features/inventory/categories/domain/entities/category_entity.dart';
import 'package:frontendmobile/features/inventory/categories/presentation/providers/category_provider.dart';
import 'package:frontendmobile/features/inventory/categories/presentation/widgets/categories_details/category_detail_body.dart';
import 'package:frontendmobile/features/inventory/categories/presentation/widgets/category_form_page.dart';
import 'package:frontendmobile/core/utils/confirm_delete_dialog.dart';

class CategoryDetailScreen extends ConsumerWidget {
  final int categoryId;
  const CategoryDetailScreen({required this.categoryId, super.key});

  //////////////////////////////////////////////////////////////////////////////
  ///
  //////////////////////////////////////////////////////////////////////////////

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ////////////////////////////////////////////////////////////////////////////
    ///
    ////////////////////////////////////////////////////////////////////////////
    final state = ref.watch(categoryNotifierProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = isDark ? const Color(0xFF1C1C1E) : const Color(0xFFF5F5F4);
    final cardBg = isDark ? const Color(0xFF2C2C2E) : Colors.white;
    final borderColor = isDark
        ? const Color(0xFF3A3A3C)
        : const Color(0xFFE0DED8);
    final subText = isDark ? const Color(0xFF8E8E93) : const Color(0xFF6B6B6B);
    ////////////////////////////////////////////////////////////////////////////
    ///
    ////////////////////////////////////////////////////////////////////////////

    final category = state.categories
        .where((c) => c.categoryId == categoryId)
        .firstOrNull;

    if (state.isLoading && category == null) {
      return Scaffold(
        backgroundColor: bg,
        appBar: _buildAppBar(context, cardBg, borderColor, null, ref),
        body: const CategoryDetailSkeleton(),
      );
    }

    ////////////////////////////////////////////////////////////////////////////
    ///
    ////////////////////////////////////////////////////////////////////////////

    if (category == null) {
      return Scaffold(
        backgroundColor: bg,
        appBar: _buildAppBar(context, cardBg, borderColor, null, ref),
        body: const Center(child: Text('Category not found.')),
      );
    }
    ////////////////////////////////////////////////////////////////////////////
    ///
    ////////////////////////////////////////////////////////////////////////////

    return Scaffold(
      backgroundColor: bg,
      appBar: _buildAppBar(context, cardBg, borderColor, category, ref),
      body: CategoryDetailBody(
        category: category,
        bg: bg,
        cardBg: cardBg,
        borderColor: borderColor,
        subText: subText,
        isDark: isDark,
      ),
    );
  }

  //////////////////////////////////////////////////////////////////////////////
  ///
  //////////////////////////////////////////////////////////////////////////////

  PreferredSizeWidget _buildAppBar(
    BuildContext context,
    Color cardBg,
    Color borderColor,
    CategoryEntity? category,
    WidgetRef ref,
  ) {
    return AppBar(
      //////////////////////////////////////////////////////////////////////////
      ///
      //////////////////////////////////////////////////////////////////////////
      backgroundColor: cardBg,
      elevation: 0,
      surfaceTintColor: Colors.transparent,
      title: Text(
        category?.categoryName ?? 'Category Detail',
        style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
      ),
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(0.5),
        child: Divider(height: 0.5, thickness: 0.5, color: borderColor),
      ),
      actions: category == null
          ? null
          : [
              IconButton(
                icon: const Icon(Icons.edit_outlined, size: 20),
                onPressed: () => _openEdit(context, ref, category),
              ),
              IconButton(
                icon: const Icon(
                  Icons.delete_outline,
                  size: 20,
                  color: Color(0xFFA32D2D),
                ),
                onPressed: () => _confirmDelete(context, ref, category),
              ),
              const SizedBox(width: 4),
            ],
    );
  }
  //////////////////////////////////////////////////////////////////////////////
  ///
  //////////////////////////////////////////////////////////////////////////////

  Future<void> _openEdit(
    BuildContext context,
    WidgetRef ref,
    CategoryEntity category,
  ) async {
    final result = await Navigator.of(context).push<Map<String, dynamic>>(
      MaterialPageRoute(builder: (_) => CategoryFormPage(existing: category)),
    );
    if (result == null || !context.mounted) return;
    final ok = await ref
        .read(categoryNotifierProvider.notifier)
        .update(
          categoryId: category.categoryId,
          categoryName: result['category_name'],
          image: result['image'],
        );
    if (!context.mounted) return;
    AppSnackBar.show(
      context,
      message: ok
          ? 'Category updated successfully.'
          : 'Failed to update category.',
      type: ok ? SnackType.success : SnackType.error,
    );
  }

  //////////////////////////////////////////////////////////////////////////////
  ///
  //////////////////////////////////////////////////////////////////////////////

  Future<void> _confirmDelete(
    BuildContext context,
    WidgetRef ref,
    CategoryEntity category,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (_) => ConfirmDeleteDialog(
        title: 'Delete Category',
        message:
            'Are you sure you want to delete "${category.categoryName}"?\nThis cannot be undone.',
      ),
    );
    if (confirmed != true || !context.mounted) return;
    final ok = await ref
        .read(categoryNotifierProvider.notifier)
        .delete(category.categoryId);
    if (!context.mounted) return;
    if (ok) Navigator.of(context).pop();
    AppSnackBar.show(
      context,
      message: ok
          ? 'Category "${category.categoryName}" deleted.'
          : 'Failed to delete category.',
      type: ok ? SnackType.success : SnackType.error,
    );
  }

  //////////////////////////////////////////////////////////////////////////////
  ///
  //////////////////////////////////////////////////////////////////////////////
}
