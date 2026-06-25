// import 'package:flutter/material.dart';

// class ProductGridShimmer extends StatefulWidget {
//   const ProductGridShimmer({super.key});

//   @override
//   State<ProductGridShimmer> createState() => _ProductGridShimmerState();
// }

// class _ProductGridShimmerState extends State<ProductGridShimmer>
//     with SingleTickerProviderStateMixin {
//   late AnimationController _controller;
//   late Animation<double> _animation;

//   @override
//   void initState() {
//     super.initState();
//     _controller = AnimationController(
//       vsync: this,
//       duration: const Duration(milliseconds: 900),
//     )..repeat(reverse: true);
//     _animation = Tween(
//       begin: 1.0,
//       end: 0.4,
//     ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
//   }

//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return FadeTransition(
//       opacity: _animation,
//       child: GridView.builder(
//         padding: const EdgeInsets.all(16),
//         gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//           crossAxisCount: 2,
//           crossAxisSpacing: 12,
//           mainAxisSpacing: 12,
//           childAspectRatio: 0.75,
//         ),
//         itemCount: 6,
//         itemBuilder: (_, __) => Container(
//           decoration: BoxDecoration(
//             color: Colors.grey.shade200,
//             borderRadius: BorderRadius.circular(12),
//           ),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               // Image placeholder
//               Expanded(
//                 child: Container(
//                   decoration: BoxDecoration(
//                     color: Colors.grey.shade300,
//                     borderRadius: const BorderRadius.vertical(
//                       top: Radius.circular(12),
//                     ),
//                   ),
//                 ),
//               ),
//               Padding(
//                 padding: const EdgeInsets.all(10),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Container(
//                       height: 12,
//                       color: Colors.grey.shade300,
//                       width: double.infinity,
//                     ),
//                     const SizedBox(height: 6),
//                     Container(
//                       height: 10,
//                       color: Colors.grey.shade300,
//                       width: 80,
//                     ),
//                     const SizedBox(height: 6),
//                     Container(
//                       height: 10,
//                       color: Colors.grey.shade300,
//                       width: 60,
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
