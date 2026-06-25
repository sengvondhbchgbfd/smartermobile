import 'package:flutter/material.dart';
import 'package:frontendmobile/features/dashboard/presentation/searching/category_chip.dart';
import 'package:frontendmobile/features/dashboard/presentation/searching/search_item.dart';
import 'package:frontendmobile/features/dashboard/presentation/searching/results/search_result_tile.dart';

class SearchResults extends StatelessWidget {
  final Map<SearchCategory, List<SearchItem>> grouped;
  final String query;
  final List<SearchItem> allResults;
  final List<SearchItem> filtered;
  final Color textPrimary;
  final Color textSecondary;
  final Color border;
  final Color surface;
  final SearchCategory? selectedCategory;
  final ValueChanged<SearchCategory?> onCategorySelected;
  final ValueChanged<SearchItem> onItemTap;

  const SearchResults({
    super.key,
    required this.grouped,
    required this.query,
    required this.allResults,
    required this.filtered,
    required this.textPrimary,
    required this.textSecondary,
    required this.border,
    required this.surface,
    required this.selectedCategory,
    required this.onCategorySelected,
    required this.onItemTap,
  });

  @override
  Widget build(BuildContext context) {
    ////////////////////////////////////////////////////////////////////////////
    ///
    ////////////////////////////////////////////////////////////////////////////
    final categories = allResults.map((i) => i.category).toSet().toList();
    ////////////////////////////////////////////////////////////////////////////
    ///
    ////////////////////////////////////////////////////////////////////////////

    return ListView(
      padding: const EdgeInsets.only(bottom: 24),

      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 14, 16, 8),
          //////////////////////////////////////////////////////////////////////
          // SHOW LIST SEARCH
          //////////////////////////////////////////////////////////////////////
          child: Text(
            '${filtered.length} result${filtered.length == 1 ? '' : 's'} for "$query"',
            style: TextStyle(
              fontSize: 12,
              color: textSecondary,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        ////////////////////////////////////////////////////////////////////////
        // Horizontally scrollable category chips  TAB
        ////////////////////////////////////////////////////////////////////////
        SizedBox(
          height: 36,
          child: ListView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            children: [
              //////////////////////////////////////////////////////////////////
              ///
              //////////////////////////////////////////////////////////////////
              CategoryChip(
                label: 'All',
                isSelected: selectedCategory == null,
                textSecondary: textSecondary,
                surface: surface,
                border: border,
                onTap: () => onCategorySelected(null),
              ),

              //////////////////////////////////////////////////////////////////
              ///
              //////////////////////////////////////////////////////////////////
              ...categories.map((cat) {
                final isSelected = selectedCategory == cat;
                return CategoryChip(
                  label: cat.label,
                  isSelected: isSelected,
                  textSecondary: textSecondary,
                  surface: surface,
                  border: border,
                  onTap: () => onCategorySelected(isSelected ? null : cat),
                );
              }),
              //////////////////////////////////////////////////////////////////
              ///
              //////////////////////////////////////////////////////////////////
            ],
          ),
        ),

        ////////////////////////////////////////////////////////////////////////
        ///  IF NO RESUT
        ////////////////////////////////////////////////////////////////////////
        const SizedBox(height: 12),
        if (filtered.isEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 60),
            child: Center(
              child: Column(
                children: [
                  Icon(
                    Icons.search_off_rounded,
                    size: 48,
                    color: textSecondary,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'No results in this category',
                    style: TextStyle(fontSize: 14, color: textSecondary),
                  ),
                ],
              ),
            ),
          )
        //////////////////////////////////////////////////////////////////////
        /// IF GET DATA SHOW
        //////////////////////////////////////////////////////////////////////
        else
          ...grouped.entries.map(
            (entry) => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ////////////////////////////////////////////////////////////
                ///
                ////////////////////////////////////////////////////////////
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 20, 16, 8),
                  child: Text(
                    entry.key.label.toUpperCase(),
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.9,
                      color: textSecondary,
                    ),
                  ),
                ),

                ////////////////////////////////////////////////////////////
                ///
                ////////////////////////////////////////////////////////////
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Container(
                    decoration: BoxDecoration(
                      color: surface,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: border),
                    ),
                    ///////////////////////////////////////////////////////
                    ///
                    ///////////////////////////////////////////////////////
                    child: Column(
                      children: entry.value.asMap().entries.map((e) {
                        final isLast = e.key == entry.value.length - 1;
                        return SearchResultTile(
                          item: e.value,
                          isLast: isLast,
                          textPrimary: textPrimary,
                          textSecondary: textSecondary,
                          borderColor: border,
                          onTap: () => onItemTap(e.value),
                        );
                      }).toList(),
                    ),
                    /////////////////////////////////////////////////////
                    ///
                    ////////////////////////////////////////////////////
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}
