// import 'package:flutter/material.dart';
// import 'package:go_router/go_router.dart';

// class ShellAppBar extends StatelessWidget implements PreferredSizeWidget {
//   final String title;
//   final List<Widget>? actions;

//   const ShellAppBar({super.key, required this.title, this.actions});

//   @override
//   Size get preferredSize => const Size.fromHeight(kToolbarHeight);

//   @override
//   Widget build(BuildContext context) {
//     return AppBar(
//       backgroundColor: const Color(0xFF121212),
//       elevation: 0,
//       centerTitle: false,
//       automaticallyImplyLeading: false,
//       titleSpacing: 16,
//       title: Row(
//         children: [
//           GestureDetector(
//             onTap: () => context.pop(),
//             child: Container(
//               width: 34,
//               height: 34,
//               decoration: BoxDecoration(
//                 color: Colors.white.withOpacity(0.07),
//                 shape: BoxShape.circle,
//               ),
//               child: const Icon(
//                 Icons.arrow_back_ios_new_rounded,
//                 color: Colors.white,
//                 size: 16,
//               ),
//             ),
//           ),
//           const SizedBox(width: 10),
//           Text(
//             title,
//             style: const TextStyle(
//               color: Colors.white,
//               fontSize: 17,
//               fontWeight: FontWeight.w600,
//             ),
//           ),
//         ],
//       ),
//       actions: actions,
//     );
//   }
// }
