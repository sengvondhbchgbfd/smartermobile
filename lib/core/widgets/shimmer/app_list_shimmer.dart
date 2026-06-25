import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class AppListShimmer extends StatelessWidget {
  final int itemCount;
  const AppListShimmer({this.itemCount = 6, super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final base = isDark ? const Color(0xFF3A3A3C) : Colors.grey.shade300;
    final highlight = isDark ? const Color(0xFF4A4A4C) : Colors.grey.shade100;

    return ListView.builder(
      itemCount: itemCount,
      padding: const EdgeInsets.all(16),
      itemBuilder: (_, __) => Shimmer.fromColors(
        baseColor: base,
        highlightColor: highlight,
        child: Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 12,
                      width: double.infinity,
                      color: Colors.white,
                    ),
                    const SizedBox(height: 6),
                    Container(height: 10, width: 180, color: Colors.white),
                    const SizedBox(height: 6),
                    Container(height: 10, width: 120, color: Colors.white),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Usage anywhere:
// const AppListShimmer()           // default 6 items
// const AppListShimmer(itemCount: 8) // custom count
