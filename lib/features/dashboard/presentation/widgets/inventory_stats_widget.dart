// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:frontendmobile/core/themes/app_pallets.dart';
// import 'package:frontendmobile/features/inventory/invoice/presentation/providers/provider.dart';
// import 'package:frontendmobile/features/inventory/product/presentation/providers/product_provider.dart';
// import 'package:frontendmobile/features/inventory/customer/presentation/providers/customer_provider.dart';
// import 'package:frontendmobile/features/inventory/supplier/presentation/providers/supplier_provider.dart';

// class InventoryStatsWidget extends ConsumerWidget {
//   const InventoryStatsWidget({super.key});

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final products = ref.watch(productProvider).products;
//     final invoices = ref.watch(invoiceProvider).invoices;

//     final customers = ref.watch(customerNotifierProvider).customers;
//     final suppliers = ref.watch(supplierProvider).suppliers;

//     final totalProducts = products.length;
//     final lowStock = products.where((p) => p.stockQuantity <= 5).length;
//     final totalRevenue = invoices.fold<double>(
//       0,
//       (sum, inv) => sum + inv.totalAmount,
//     );
//     final totalCustomers = customers.length;

//     final stats = [
//       _InventoryStat(
//         title: 'Products',
//         value: '$totalProducts',
//         icon: Icons.inventory_2_rounded,
//         color: Colors.teal,
//       ),
//       _InventoryStat(
//         title: 'Low Stock',
//         value: '$lowStock',
//         icon: Icons.warning_amber_rounded,
//         color: lowStock > 0 ? Colors.orange : Colors.green,
//         highlight: lowStock > 0,
//       ),
//       _InventoryStat(
//         title: 'Revenue',
//         value: '\$${_formatNum(totalRevenue)}',
//         icon: Icons.attach_money_rounded,
//         color: Colors.green,
//       ),
//       _InventoryStat(
//         title: 'Customers',
//         value: '$totalCustomers',
//         icon: Icons.groups_rounded,
//         color: Colors.blue,
//       ),
//     ];

//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         const Text(
//           'Inventory Overview',
//           style: TextStyle(
//             color: Colors.white,
//             fontWeight: FontWeight.bold,
//             fontSize: 17,
//           ),
//         ),
//         const SizedBox(height: 14),
//         GridView.builder(
//           shrinkWrap: true,
//           physics: const NeverScrollableScrollPhysics(),
//           itemCount: stats.length,
//           gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//             crossAxisCount: 2,
//             crossAxisSpacing: 14,
//             mainAxisSpacing: 14,
//             childAspectRatio: 1.5,
//           ),
//           itemBuilder: (_, i) => _StatCard(stat: stats[i], delay: i * 80),
//         ),
//       ],
//     );
//   }

//   String _formatNum(double v) {
//     if (v >= 1000000) return '${(v / 1000000).toStringAsFixed(1)}M';
//     if (v >= 1000) return '${(v / 1000).toStringAsFixed(1)}K';
//     return v.toStringAsFixed(0);
//   }
// }

// class _InventoryStat {
//   final String title;
//   final String value;
//   final IconData icon;
//   final Color color;
//   final bool highlight;

//   const _InventoryStat({
//     required this.title,
//     required this.value,
//     required this.icon,
//     required this.color,
//     this.highlight = false,
//   });
// }

// class _StatCard extends StatefulWidget {
//   final _InventoryStat stat;
//   final int delay;
//   const _StatCard({required this.stat, required this.delay});

//   @override
//   State<_StatCard> createState() => _StatCardState();
// }

// class _StatCardState extends State<_StatCard>
//     with SingleTickerProviderStateMixin {
//   late final AnimationController _ctrl;
//   late final Animation<double> _scale;

//   @override
//   void initState() {
//     super.initState();
//     _ctrl = AnimationController(
//       vsync: this,
//       duration: const Duration(milliseconds: 400),
//     );
//     _scale = CurvedAnimation(parent: _ctrl, curve: Curves.easeOutBack);
//     Future.delayed(Duration(milliseconds: widget.delay), () {
//       if (mounted) _ctrl.forward();
//     });
//   }

//   @override
//   void dispose() {
//     _ctrl.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final s = widget.stat;
//     return ScaleTransition(
//       scale: _scale,
//       child: Container(
//         padding: const EdgeInsets.all(14),
//         decoration: BoxDecoration(
//           color: s.highlight ? s.color.withOpacity(0.12) : Pallets.surfaceDark,
//           borderRadius: BorderRadius.circular(20),
//           border: Border.all(
//             color: s.highlight ? s.color.withOpacity(0.4) : Pallets.borderDark,
//           ),
//         ),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             Container(
//               padding: const EdgeInsets.all(8),
//               decoration: BoxDecoration(
//                 color: s.color.withOpacity(0.15),
//                 borderRadius: BorderRadius.circular(12),
//               ),
//               child: Icon(s.icon, color: s.color, size: 20),
//             ),
//             Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   s.value,
//                   style: const TextStyle(
//                     color: Colors.white,
//                     fontSize: 22,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//                 const SizedBox(height: 2),
//                 Text(
//                   s.title,
//                   style: const TextStyle(
//                     color: Pallets.textSecondaryDark,
//                     fontSize: 12,
//                   ),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
