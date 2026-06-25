import 'package:flutter/material.dart';
import 'package:frontendmobile/features/dashboard/presentation/searching/search_item.dart';

class SearchResultTile extends StatelessWidget {
  final SearchItem item;
  final bool isLast;
  final Color textPrimary;
  final Color textSecondary;
  final Color borderColor;
  final VoidCallback onTap;

  const SearchResultTile({
    super.key,
    required this.item,
    required this.isLast,
    required this.textPrimary,
    required this.textSecondary,
    required this.borderColor,
    required this.onTap,
  });
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ////////////////////////////////////////////////////////////////////////
        ///
        ////////////////////////////////////////////////////////////////////////
        InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(isLast ? 16 : 0),
          ),

          //////////////////////////////////////////////////////////////////////
          ///
          //////////////////////////////////////////////////////////////////////
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            child: Row(
              children: [
                ////////////////////////////////////////////////////////////////
                ///
                ////////////////////////////////////////////////////////////////
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: item.iconColor.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(item.icon, color: item.iconColor, size: 20),
                ),

                ////////////////////////////////////////////////////////////////
                ///
                ////////////////////////////////////////////////////////////////
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    ////////////////////////////////////////////////////////////
                    ///
                    ////////////////////////////////////////////////////////////
                    children: [
                      Text(
                        item.title,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: textPrimary,
                        ),
                      ),
                      const SizedBox(height: 2),

                      //////////////////////////////////////////////////////////
                      ///
                      //////////////////////////////////////////////////////////
                      Text(
                        item.subtitle,
                        style: TextStyle(fontSize: 12, color: textSecondary),
                      ),
                    ],
                  ),
                ),
                ////////////////////////////////////////////////////////////////
                ///
                ////////////////////////////////////////////////////////////////
                Icon(
                  Icons.chevron_right_rounded,
                  color: textSecondary,
                  size: 18,
                ),
              ],
            ),
          ),
        ),

        ////////////////////////////////////////////////////////////////
        ///
        ////////////////////////////////////////////////////////////////
        if (!isLast)
          Divider(
            height: 1,
            indent: 66,
            color: borderColor.withValues(alpha: 0.5),
          ),
      ],
    );
  }
}
