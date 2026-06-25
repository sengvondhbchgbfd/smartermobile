// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:frontendmobile/core/themes/app_pallets.dart';
// import 'package:frontendmobile/features/inventory/invoice/presentation/providers/provider.dart';
// import 'package:frontendmobile/features/inventory/product/presentation/providers/product_provider.dart';

// // ─── Simple bar/line chart built with Canvas — no extra package needed ────────

// class RevenueChartWidget extends ConsumerWidget {
//   const RevenueChartWidget({super.key});

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final invoices = ref.watch(invoiceProvider).invoices;
//     final products = ref.watch(productProvider).products;

//     // Build last-7-days revenue map
//     final now = DateTime.now();
//     final days = List.generate(
//       7,
//       (i) => DateTime(now.year, now.month, now.day - (6 - i)),
//     );

//     final revenueByDay = <DateTime, double>{};
//     for (final d in days) revenueByDay[d] = 0;

//     for (final inv in invoices) {
//       final day = DateTime(
//         inv.createdAt.year,
//         inv.createdAt.month,
//         inv.createdAt.day,
//       );
//       if (revenueByDay.containsKey(day)) {
//         revenueByDay[day] = revenueByDay[day]! + inv.totalAmount;
//       }
//     }

//     final revenueValues = days.map((d) => revenueByDay[d]!).toList();
//     final maxRevenue = revenueValues.fold<double>(0, (m, v) => v > m ? v : m);

//     // Low stock count
//     final lowStockCount = products.where((p) => p.stockQuantity <= 5).length;
//     final totalStock = products.fold<int>(0, (s, p) => s + p.stockQuantity);

//     final dayLabels = days.map((d) => _dayLabel(d)).toList();

//     return Container(
//       padding: const EdgeInsets.all(18),
//       decoration: BoxDecoration(
//         color: Pallets.surfaceDark,
//         borderRadius: BorderRadius.circular(20),
//         border: Border.all(color: Pallets.borderDark),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           // ── Header ──────────────────────────────────────────────────────
//           Row(
//             children: [
//               const Expanded(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       'Revenue · 7 Days',
//                       style: TextStyle(
//                         color: Colors.white,
//                         fontWeight: FontWeight.bold,
//                         fontSize: 15,
//                       ),
//                     ),
//                     SizedBox(height: 2),
//                     Text(
//                       'Live from invoices',
//                       style: TextStyle(
//                         color: Pallets.textSecondaryDark,
//                         fontSize: 11,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               _LiveDot(),
//             ],
//           ),
//           const SizedBox(height: 20),

//           // ── Bar chart ───────────────────────────────────────────────────
//           SizedBox(
//             height: 120,
//             child: _RevenueBarChart(
//               values: revenueValues,
//               labels: dayLabels,
//               maxValue: maxRevenue == 0 ? 1 : maxRevenue,
//             ),
//           ),

//           const SizedBox(height: 20),
//           const Divider(color: Color(0xFF2A2A3E)),
//           const SizedBox(height: 14),

//           // ── Stock summary row ────────────────────────────────────────────
//           Row(
//             children: [
//               _StockPill(
//                 icon: Icons.inventory_2_rounded,
//                 color: Colors.teal,
//                 label: 'Total Stock',
//                 value: '$totalStock units',
//               ),
//               const SizedBox(width: 12),
//               _StockPill(
//                 icon: Icons.warning_amber_rounded,
//                 color: lowStockCount > 0 ? Colors.orange : Colors.green,
//                 label: 'Low Stock',
//                 value: '$lowStockCount items',
//                 highlight: lowStockCount > 0,
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }

//   String _dayLabel(DateTime d) {
//     const labels = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
//     return labels[d.weekday - 1];
//   }
// }

// // ── Bar chart painter ─────────────────────────────────────────────────────────

// class _RevenueBarChart extends StatelessWidget {
//   final List<double> values;
//   final List<String> labels;
//   final double maxValue;

//   const _RevenueBarChart({
//     required this.values,
//     required this.labels,
//     required this.maxValue,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return CustomPaint(
//       painter: _BarChartPainter(
//         values: values,
//         labels: labels,
//         maxValue: maxValue,
//       ),
//       size: const Size(double.infinity, 120),
//     );
//   }
// }

// class _BarChartPainter extends CustomPainter {
//   final List<double> values;
//   final List<String> labels;
//   final double maxValue;

//   _BarChartPainter({
//     required this.values,
//     required this.labels,
//     required this.maxValue,
//   });

//   @override
//   void paint(Canvas canvas, Size size) {
//     final barPaint = Paint()..style = PaintingStyle.fill;
//     final labelStyle = const TextStyle(color: Color(0xFF7A7A9A), fontSize: 10);

//     final count = values.length;
//     final barW = (size.width / count) * 0.5;
//     final spacing = size.width / count;
//     final chartH = size.height - 20; // leave room for labels

//     for (int i = 0; i < count; i++) {
//       final ratio = values[i] / maxValue;
//       final barH = chartH * ratio;
//       final x = spacing * i + spacing / 2 - barW / 2;
//       final y = chartH - barH;

//       // Gradient bar
//       final rect = RRect.fromRectAndRadius(
//         Rect.fromLTWH(x, y, barW, barH),
//         const Radius.circular(6),
//       );

//       barPaint.shader = LinearGradient(
//         begin: Alignment.topCenter,
//         end: Alignment.bottomCenter,
//         colors: [
//           const Color(0xFF00C9A7),
//           const Color(0xFF00C9A7).withOpacity(0.4),
//         ],
//       ).createShader(Rect.fromLTWH(x, y, barW, barH));

//       canvas.drawRRect(rect, barPaint);

//       // Label
//       final tp = TextPainter(
//         text: TextSpan(text: labels[i], style: labelStyle),
//         textDirection: TextDirection.ltr,
//       )..layout();
//       tp.paint(canvas, Offset(x + barW / 2 - tp.width / 2, chartH + 4));
//     }
//   }

//   @override
//   bool shouldRepaint(_BarChartPainter old) =>
//       old.values != values || old.maxValue != maxValue;
// }

// // ── Live dot indicator ────────────────────────────────────────────────────────

// class _LiveDot extends StatefulWidget {
//   @override
//   State<_LiveDot> createState() => _LiveDotState();
// }

// class _LiveDotState extends State<_LiveDot>
//     with SingleTickerProviderStateMixin {
//   late final AnimationController _ctrl;

//   @override
//   void initState() {
//     super.initState();
//     _ctrl = AnimationController(
//       vsync: this,
//       duration: const Duration(seconds: 1),
//     )..repeat(reverse: true);
//   }

//   @override
//   void dispose() {
//     _ctrl.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return FadeTransition(
//       opacity: _ctrl,
//       child: Row(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           Container(
//             width: 7,
//             height: 7,
//             decoration: const BoxDecoration(
//               color: Color(0xFF00C9A7),
//               shape: BoxShape.circle,
//             ),
//           ),
//           const SizedBox(width: 5),
//           const Text(
//             'LIVE',
//             style: TextStyle(
//               color: Color(0xFF00C9A7),
//               fontSize: 10,
//               fontWeight: FontWeight.bold,
//               letterSpacing: 1.2,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// // ── Stock pill ────────────────────────────────────────────────────────────────

// class _StockPill extends StatelessWidget {
//   final IconData icon;
//   final Color color;
//   final String label;
//   final String value;
//   final bool highlight;

//   const _StockPill({
//     required this.icon,
//     required this.color,
//     required this.label,
//     required this.value,
//     this.highlight = false,
//   });
//   @override
//   Widget build(BuildContext context) {
//     return Expanded(
//       child: Container(
//         padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
//         decoration: BoxDecoration(
//           color: color.withOpacity(0.1),
//           borderRadius: BorderRadius.circular(12),
//           border: Border.all(color: color.withOpacity(0.25)),
//         ),
//         child: Row(
//           children: [
//             Icon(icon, color: color, size: 18),
//             const SizedBox(width: 8),
//             Expanded(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     value,
//                     style: TextStyle(
//                       color: color,
//                       fontWeight: FontWeight.bold,
//                       fontSize: 13,
//                     ),
//                   ),
//                   Text(
//                     label,
//                     style: const TextStyle(
//                       color: Pallets.textSecondaryDark,
//                       fontSize: 10,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
