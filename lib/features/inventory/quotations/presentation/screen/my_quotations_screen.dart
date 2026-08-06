import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontendmobile/core/themes/app_pallets.dart';
import 'package:frontendmobile/core/widgets/shimmer/app_list_shimmer.dart';
import '../providers/quotation_provider.dart';
import '../widgets/quotation_card.dart';
import 'quotation_detail_screen.dart';

class MyQuotationsScreen extends ConsumerWidget {
  const MyQuotationsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final quotationsAsync = ref.watch(myQuotationsNotifierProvider);

    return Scaffold(
      backgroundColor: isDark
          ? Pallets.backgroundDark
          : Pallets.backgroundLight,
      appBar: AppBar(
        title: const Text('My Quotations'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: RefreshIndicator(
        onRefresh: () =>
            ref.read(myQuotationsNotifierProvider.notifier).refresh(),
        child: quotationsAsync.when(
          loading: () => const AppListShimmer(itemCount: 6),
          error: (error, _) => Center(
            child: Text('$error', style: TextStyle(color: Pallets.error)),
          ),
          data: (quotations) {
            if (quotations.isEmpty) {
              return ListView(
                children: [
                  const SizedBox(height: 120),
                  Center(
                    child: Text(
                      'No quotations assigned to you yet',
                      style: TextStyle(color: Pallets.textMuted),
                    ),
                  ),
                ],
              );
            }
            return ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: quotations.length,
              separatorBuilder: (_, __) => const SizedBox(height: 10),
              itemBuilder: (context, index) {
                final q = quotations[index];
                return QuotationCard(
                  quotation: q,
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) =>
                          QuotationDetailScreen(quotationId: q.quotationId),
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
