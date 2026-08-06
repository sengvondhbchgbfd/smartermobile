import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontendmobile/config/routes/route_names.dart';
import 'package:frontendmobile/core/themes/app_pallets.dart';
import 'package:frontendmobile/features/dashboard/presentation/providers/search_provider.dart';
import 'package:frontendmobile/features/dashboard/presentation/searching/bar/search_page_app_bar.dart';
import 'package:frontendmobile/features/dashboard/presentation/searching/search_home.dart';
import 'package:frontendmobile/features/dashboard/presentation/searching/search_item.dart';
import 'package:frontendmobile/features/dashboard/presentation/searching/results/search_results.dart';
import 'package:go_router/go_router.dart';

class SearchPage extends ConsumerStatefulWidget {
  const SearchPage({super.key});
  @override
  ConsumerState<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends ConsumerState<SearchPage>
    with SingleTickerProviderStateMixin {
  final _controller = TextEditingController();
  final _focus = FocusNode();
  late final TabController _tabController;

  static const _shellRoutes = {
    RouteNames.dashboard,
    RouteNames.attendance,
    RouteNames.chat,
    RouteNames.users,
    RouteNames.settings,
  };

  static const _tabs = [('Staff', false), ('Products', false)];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabs.length, vsync: this);

    /////////////////////////////////////////////////////////////////////
    ///
    ////////////////////////////////////////////////////////////////////
    _tabController.addListener(() {
      if (_tabController.indexIsChanging) return;
      final category = _tabController.index == 0
          ? SearchCategory.staff
          : SearchCategory.product;
      ref.read(selectedCategoryProvider.notifier).state = category;
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _focus.requestFocus();
      ref.read(selectedCategoryProvider.notifier).state = SearchCategory.staff;
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _focus.dispose();
    _tabController.dispose();
    super.dispose();
  }

  void _goBack() {
    _focus.unfocus();
    ref.read(searchQueryProvider.notifier).state = '';
    ref.read(selectedCategoryProvider.notifier).state = null;
    _tabController.animateTo(0);
    context.pop();
  }

  void _onItemTap(SearchItem item) {
    _focus.unfocus();
    if (_shellRoutes.contains(item.route)) {
      context.go(item.resolvedRoute);
    } else {
      context.pop();
      context.push(item.resolvedRoute);
    }
  }

  @override
  Widget build(BuildContext context) {
    ////////////////////////////////////////////////////////////////////////////
    ///
    ////////////////////////////////////////////////////////////////////////////

    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = isDark ? Pallets.backgroundDark : Pallets.backgroundLight;
    final surface = isDark ? Pallets.surfaceDark : Pallets.surfaceLight;
    final border = isDark ? Pallets.borderDark : Pallets.borderLight;
    final tp = isDark ? Pallets.textPrimaryDark : Pallets.textPrimaryLight;
    final ts = isDark ? Pallets.textSecondaryDark : Pallets.textSecondaryLight;

    final allResults = ref.watch(searchResultsProvider);
    final filtered = ref.watch(filteredSearchResultsProvider);
    final query = ref.watch(searchQueryProvider);
    final selectedCat = ref.watch(selectedCategoryProvider);

    final grouped = <SearchCategory, List<SearchItem>>{};
    for (final item in filtered) {
      grouped.putIfAbsent(item.category, () => []).add(item);
    }
    ////////////////////////////////////////////////////////////////////////////
    ///
    ////////////////////////////////////////////////////////////////////////////
    return PopScope(
      canPop: false,

      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) _goBack();
      },

      child: Scaffold(
        backgroundColor: bg,
        ////////////////////////////////////////////////////////////////////////
        ///
        ////////////////////////////////////////////////////////////////////////
        appBar: SearchPageAppBar(
          bg: bg,
          surface: surface,
          border: border,
          textPrimary: tp,
          textSecondary: ts,
          query: query,
          controller: _controller,
          focusNode: _focus,
          onChanged: (v) => ref.read(searchQueryProvider.notifier).state = v,
          onClear: () {
            _controller.clear();
            ref.read(searchQueryProvider.notifier).state = '';
          },
          onBack: _goBack,
        ),
        ////////////////////////////////////////////////////////////////////////
        ///
        ////////////////////////////////////////////////////////////////////////
        body: query.isEmpty
            ? SearchHome(
                tabController: _tabController,
                tabs: _tabs,
                textPrimary: tp,
                textSecondary: ts,
                border: border,
                onItemTap: _onItemTap,
              )
            : SearchResults(
                grouped: grouped,
                query: query,
                allResults: allResults,
                filtered: filtered,
                textPrimary: tp,
                textSecondary: ts,
                border: border,
                surface: surface,
                selectedCategory: selectedCat,
                onCategorySelected: (cat) =>
                    ref.read(selectedCategoryProvider.notifier).state = cat,
                onItemTap: _onItemTap,
              ),
      ),
    );
  }
}
