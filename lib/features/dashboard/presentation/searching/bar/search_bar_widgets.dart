import 'package:flutter/material.dart';
import 'package:frontendmobile/config/routes/route_names.dart';
import 'package:frontendmobile/core/themes/app_pallets.dart';
import 'package:go_router/go_router.dart';

class SearchAppBar extends StatelessWidget {
  final String hint;
  const SearchAppBar({super.key, this.hint = 'Search modules, settings...'});

  @override
  Widget build(BuildContext context) {
    ////////////////////////////////////////////////////////////////////////////
    ///
    ////////////////////////////////////////////////////////////////////////////
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final surfaceColor = isDark ? Pallets.surfaceDark : Pallets.surfaceLight;
    final borderColor = isDark ? Pallets.borderDark : Pallets.borderLight;
    final textSecondary = isDark
        ? Pallets.textSecondaryDark
        : Pallets.textSecondaryLight;
    ////////////////////////////////////////////////////////////////////////////
    ///
    ////////////////////////////////////////////////////////////////////////////

    return GestureDetector(
      onTap: () => context.push(RouteNames.searchPage),
      child: Container(
        height: 50,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: surfaceColor,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: borderColor),
        ),
        ////////////////////////////////////////////////////////////////////////
        ///
        ////////////////////////////////////////////////////////////////////////
        child: Row(
          children: [
            Icon(Icons.search_rounded, color: textSecondary, size: 20),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                hint,
                style: TextStyle(color: textSecondary, fontSize: 13),
              ),
            ),
            ////////////////////////////////////////////////////////////////////
            ///
            ////////////////////////////////////////////////////////////////////
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: borderColor.withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                '⌘ K',
                style: TextStyle(
                  fontSize: 11,
                  color: textSecondary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            ////////////////////////////////////////////////////////////////////
            ///
            ////////////////////////////////////////////////////////////////////
          ],
        ),
      ),
    );
  }
}
