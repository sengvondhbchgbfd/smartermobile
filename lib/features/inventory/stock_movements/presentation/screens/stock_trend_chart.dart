import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../domain/entities/stock_movement_report_entity.dart';

class StockTrendChart extends StatelessWidget {
  final List<StockMovementTrendPoint> points;
  final Color inColor;
  final Color outColor;
  final Color subText;
  final Color gridColor;

  const StockTrendChart({
    super.key,
    required this.points,
    required this.inColor,
    required this.outColor,
    required this.subText,
    required this.gridColor,
  });
  static const double _groupWidth = 46;

  @override
  Widget build(BuildContext context) {
    if (points.isEmpty) {
      return SizedBox(
        height: 180,
        child: Center(
          child: Text(
            'No movement data for this range.',
            style: TextStyle(fontSize: 13, color: subText),
          ),
        ),
      );
    }

    final maxVal = points
        .map((p) => p.qtyIn > p.qtyOut ? p.qtyIn : p.qtyOut)
        .fold<int>(0, (a, b) => a > b ? a : b)
        .toDouble();
    final maxY = maxVal == 0 ? 10.0 : maxVal * 1.25;





    return LayoutBuilder(
      builder: (context, constraints) {
        final contentWidth = _groupWidth * points.length;
        final needsScroll = contentWidth > constraints.maxWidth;
        final chartWidth = needsScroll ? contentWidth : constraints.maxWidth;

        final chart = SizedBox(
          width: chartWidth,
          height: 200,
          child: BarChart(
            BarChartData(
              maxY: maxY,
              alignment: BarChartAlignment.spaceAround,
              gridData: FlGridData(
                show: true,
                drawVerticalLine: false,
                horizontalInterval: maxY / 4,
                getDrawingHorizontalLine: (_) =>
                    FlLine(color: gridColor, strokeWidth: 0.6),
              ),
              borderData: FlBorderData(show: false),
              titlesData: FlTitlesData(
                leftTitles: const AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                rightTitles: const AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                topTitles: const AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 26,
                    getTitlesWidget: (value, meta) {
                      final i = value.toInt();
                      if (i < 0 || i >= points.length) {
                        return const SizedBox.shrink();
                      }
                      final raw = points[i].label;
                      final short = raw.length > 7 ? raw.substring(0, 7) : raw;
                      return Padding(
                        padding: const EdgeInsets.only(top: 6),
                        child: Text(
                          short,
                          style: TextStyle(fontSize: 9, color: subText),
                        ),
                      );
                    },
                  ),
                ),
              ),
              barTouchData: BarTouchData(
                touchTooltipData: BarTouchTooltipData(
                  getTooltipItem: (group, groupIndex, rod, rodIndex) {
                    final p = points[group.x.toInt()];
                    final label = rodIndex == 0
                        ? 'In: ${p.qtyIn}'
                        : 'Out: ${p.qtyOut}';
                    return BarTooltipItem(
                      label,
                      const TextStyle(color: Colors.white, fontSize: 11),
                    );
                  },
                ),
              ),
              barGroups: List.generate(points.length, (i) {
                final p = points[i];
                return BarChartGroupData(
                  x: i,
                  barRods: [
                    BarChartRodData(
                      toY: p.qtyIn.toDouble(),
                      color: inColor,
                      width: 7,
                      borderRadius: BorderRadius.circular(3),
                    ),
                    BarChartRodData(
                      toY: p.qtyOut.toDouble(),
                      color: outColor,
                      width: 7,
                      borderRadius: BorderRadius.circular(3),
                    ),
                  ],
                  barsSpace: 3,
                );
              }),
            ),
          ),
        );

        if (!needsScroll) return chart;

        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          physics: const BouncingScrollPhysics(),
          child: chart,
        );
      },
    );
  }
}
