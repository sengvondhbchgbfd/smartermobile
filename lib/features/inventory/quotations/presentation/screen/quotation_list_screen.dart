import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontendmobile/core/themes/app_pallets.dart';
import 'package:frontendmobile/core/widgets/shimmer/app_list_shimmer.dart';
import '../providers/quotation_provider.dart';
import '../providers/quotation_filter_provider.dart';
import '../widgets/quotation_card.dart';
import '../widgets/quotation_summary_card.dart';
import '../widgets/quotation_filter_sheet.dart';
import 'quotation_detail_screen.dart';
import 'quotation_form_screen.dart';

class QuotationListScreen extends ConsumerStatefulWidget {
  const QuotationListScreen({super.key});
  @override
  ConsumerState<QuotationListScreen> createState() =>
      _QuotationListScreenState();
}

////////////////////////////////////////////////////////////////////////////////
///
////////////////////////////////////////////////////////////////////////////////

class _QuotationListScreenState extends ConsumerState<QuotationListScreen> {
  final _searchCtrl = TextEditingController();

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

  @override
  Widget build(BuildContext context) {
    ////////////////////////////////////////////////////////////////////////////
    ///
    ////////////////////////////////////////////////////////////////////////////
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final quotationsAsync = ref.watch(quotationListNotifierProvider);
    final summaryAsync = ref.watch(quotationSummaryProvider);
    final filter = ref.watch(quotationFilterNotifierProvider);

    ////////////////////////////////////////////////////////////////////////////
    ///
    ////////////////////////////////////////////////////////////////////////////

    return Scaffold(
      backgroundColor: isDark
          ? Pallets.backgroundDark
          : Pallets.backgroundLight,

      //////////////////////////////////////////////////////////////////////////
      ///
      //////////////////////////////////////////////////////////////////////////
      appBar: AppBar(
        title: const Text('Quotations'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: Badge(
              isLabelVisible: filter.hasActiveFilters,
              child: const Icon(Icons.tune_rounded),
            ),
            onPressed: () => showQuotationFilterSheet(context),
          ),
        ],
      ),
      //////////////////////////////////////////////////////////////////////////
      ///
      //////////////////////////////////////////////////////////////////////////
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Pallets.blurple,
        foregroundColor: Pallets.onAccent,
        icon: const Icon(Icons.add),
        label: const Text('New Quotation'),
        onPressed: () => Navigator.of(
          context,
        ).push(MaterialPageRoute(builder: (_) => const QuotationFormScreen())),
      ),
      //////////////////////////////////////////////////////////////////////////
      ///
      //////////////////////////////////////////////////////////////////////////
      body: RefreshIndicator(
        onRefresh: () =>
            ref.read(quotationListNotifierProvider.notifier).refresh(),
        child: CustomScrollView(
          slivers: [
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
              sliver: SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    summaryAsync.when(
                      data: (summary) => QuotationSummaryCard(summary: summary),

                      ///////////////////////////////
                      ///
                      //////////////////////////////
                      loading: () => const AppListShimmer(itemCount: 1),
                      error: (_, __) => const SizedBox.shrink(),

                      ///////////////////////////////
                      ///
                      //////////////////////////////
                    ),
                    const SizedBox(height: 16),
                    ///////////////////////////////
                    ///
                    //////////////////////////////
                    TextField(
                      controller: _searchCtrl,
                      onChanged: (value) => ref
                          .read(quotationFilterNotifierProvider.notifier)
                          .setSearchQuery(value),

                      //////////////////////////
                      ///
                      /////////////////////////
                      decoration: InputDecoration(
                        hintText: 'Search by ref number or customer...',
                        prefixIcon: const Icon(Icons.search),
                        filled: true,
                        fillColor: isDark
                            ? Pallets.surfaceElevated
                            : Pallets.surfaceLight,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: BorderSide.none,
                        ),
                      ),

                      //////////////////////////
                      ///
                      /////////////////////////
                    ),
                  ],
                ),
              ),
            ),

            ////////////////////////////////////////////////////////////////////
            ///
            ////////////////////////////////////////////////////////////////////
            quotationsAsync.when(
              data: (quotations) {
                if (quotations.isEmpty) {
                  return const SliverFillRemaining(child: _EmptyState());
                }

                ///////////////////////////////
                ///
                //////////////////////////////
                return SliverPadding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 100),
                  sliver: SliverList.separated(
                    itemCount: quotations.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 10),

                    ///////////////////////
                    ///
                    //////////////////////
                    itemBuilder: (context, index) {
                      final q = quotations[index];
                      return QuotationCard(
                        quotation: q,
                        onTap: () => Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => QuotationDetailScreen(
                              quotationId: q.quotationId,
                            ),
                          ),
                        ),
                      );
                    },

                    ///////////////////////
                    ///
                    //////////////////////
                  ),
                );
              },

              ///////////////////////////////
              ///
              //////////////////////////////
              loading: () => SliverPadding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 100),
                sliver: SliverToBoxAdapter(
                  child: AppListShimmer(
                    itemCount: 6,
                    style: ShimmerItemStyle.quotationCard,
                  ),
                ),
              ),

              ///////////////////////////////
              ///
              //////////////////////////////
              error: (error, _) => SliverFillRemaining(
                child: _ErrorState(
                  message: error.toString(),
                  onRetry: () => ref
                      .read(quotationListNotifierProvider.notifier)
                      .refresh(),
                ),
              ),
              ///////////////////////////////
              ///
              //////////////////////////////
            ),
          ],
        ),
      ),
    );
  }
}

////////////////////////////////////////////////////////////////////
///
////////////////////////////////////////////////////////////////////

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.description_outlined, size: 56, color: Pallets.textMuted),
          const SizedBox(height: 12),
          Text(
            'No quotations found',
            style: TextStyle(color: Pallets.textMuted, fontSize: 15),
          ),
        ],
      ),
    );
  }
}
////////////////////////////////////////////////////////////////////
///
////////////////////////////////////////////////////////////////////

class _ErrorState extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _ErrorState({required this.message, required this.onRetry});
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.error_outline, size: 48, color: Pallets.error),
            const SizedBox(height: 12),
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(color: Pallets.textMuted, fontSize: 13),
            ),
            const SizedBox(height: 12),
            ElevatedButton(onPressed: onRetry, child: const Text('Retry')),
          ],
        ),
      ),
    );
  }
}
