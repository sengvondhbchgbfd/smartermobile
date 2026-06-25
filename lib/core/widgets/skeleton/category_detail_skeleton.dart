import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class CategoryDetailSkeleton extends StatelessWidget {
  const CategoryDetailSkeleton({super.key});

  Widget _box({double? width, required double height, double radius = 6}) =>
      Shimmer.fromColors(
        baseColor: Colors.grey.shade300,
        highlightColor: Colors.grey.shade100,
        child: Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(radius),
          ),
        ),
      );

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Hero image
          _box(width: double.infinity, height: 220, radius: 0),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title row
                Row(
                  children: [
                    Expanded(child: _box(height: 20)),
                    const SizedBox(width: 12),
                    _box(width: 60, height: 28, radius: 20),
                  ],
                ),
                const SizedBox(height: 12),
                // Subtitle
                _box(width: 140, height: 14),
                const SizedBox(height: 20),
                // Description lines
                _box(width: double.infinity, height: 12),
                const SizedBox(height: 6),
                _box(width: double.infinity, height: 12),
                const SizedBox(height: 6),
                _box(width: 240, height: 12),
                const SizedBox(height: 24),
                // CTA buttons
                Row(
                  children: [
                    Expanded(child: _box(height: 44, radius: 10)),
                    const SizedBox(width: 12),
                    Expanded(child: _box(height: 44, radius: 10)),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
