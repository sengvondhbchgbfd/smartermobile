// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:frontendmobile/features/communication/chat/presentation/widgets/components/app_text_field.dart';
// import '../providers/chat_provider.dart';

// class CreateGroupScreen extends ConsumerStatefulWidget {
//   const CreateGroupScreen({super.key});
//   @override
//   ConsumerState<CreateGroupScreen> createState() => _CreateGroupScreenState();
// }
// ////////////////////////////////////////////////////////////////////////////
// ///
// ///////////////////////////////////////////////////////////////////////////

// class _CreateGroupScreenState extends ConsumerState<CreateGroupScreen> {
//   ////////////////////////////////////////////////////////////////////////////
//   /// State variables
//   ///////////////////////////////////////////////////////////////////////////
//   final _nameCtrl = TextEditingController();
//   final _memberCtrl = TextEditingController();
//   final List<int> _memberIds = [];
//   bool _loading = false;
//   String? _error;
//   @override
//   void dispose() {
//     _nameCtrl.dispose();
//     _memberCtrl.dispose();
//     super.dispose();
//   }

//   ////////////////////////////////////////////////////////////////////////////
//   /// Action handlers
//   ///////////////////////////////////////////////////////////////////////////

//   Future<void> _submit() async {
//     final name = _nameCtrl.text.trim();
//     if (name.isEmpty) {
//       setState(() => _error = 'Group name is required.');
//       return;
//     }

//     setState(() {
//       _loading = true;
//       _error = null;
//     });

//     try {
//       final uc = ref.read(createGroupUCProvider);
//       await uc(groupName: name, memberIds: _memberIds);
//       if (mounted) Navigator.pop(context);
//     } catch (e) {
//       setState(() {
//         _error = e.toString();
//         _loading = false;
//       });
//     }
//   }

//   ////////////////////////////////////////////////////////////////////////////
//   /// Helper methods
//   ///////////////////////////////////////////////////////////////////////////

//   void _addMember() {
//     final raw = _memberCtrl.text.trim();
//     final id = int.tryParse(raw);
//     if (id == null) {
//       setState(() => _error = 'Enter a valid staff ID.');
//       return;
//     }
//     if (_memberIds.contains(id)) return;
//     setState(() {
//       _memberIds.add(id);
//       _memberCtrl.clear();
//       _error = null;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       //////////////////////////////////////////////////////////////////////
//       ///  CREATE GROUP ACTION
//       //////////////////////////////////////////////////////////////////////
//       backgroundColor: const Color(0xFF0e1621),
//       appBar: AppBar(
//         backgroundColor: const Color(0xFF17212b),
//         elevation: 0,
//         leading: IconButton(
//           icon: const Icon(Icons.close_rounded, color: Color(0xFF8a9bb0)),
//           onPressed: () => Navigator.pop(context),
//         ),
//         title: const Text(
//           'New Group',
//           style: TextStyle(
//             color: Color(0xFFe8eaed),
//             fontWeight: FontWeight.w600,
//           ),
//         ),
//         actions: [
//           TextButton(
//             onPressed: _loading ? null : _submit,
//             child: _loading
//                 ? const SizedBox(
//                     width: 18,
//                     height: 18,
//                     child: CircularProgressIndicator(
//                       strokeWidth: 2,
//                       color: Color(0xFF5caeff),
//                     ),
//                   )
//                 : const Text(
//                     'Create',
//                     style: TextStyle(
//                       color: Color(0xFF5caeff),
//                       fontWeight: FontWeight.w600,
//                       fontSize: 15,
//                     ),
//                   ),
//           ),
//         ],
//       ),

//       ////////////////////////////////////////////////////////////////////////////
//       /// CREATE GROUP FORM
//       ///////////////////////////////////////////////////////////////////////////
//       body: Padding(
//         padding: const EdgeInsets.all(20),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             AppTextField(
//               controller: _nameCtrl,
//               hintText: 'Group Name',
//               prefixIcon: Icons.group_rounded,
//               autofocus: true,
//             ),

//             ////////////////////////////////////////////////////////////////////////////
//             ///   ADD MEMBERS SECTION
//             ///////////////////////////////////////////////////////////////////////////
//             const SizedBox(height: 20),

//             // Add members section
//             const Text(
//               'Add Members',
//               style: TextStyle(
//                 fontSize: 13,
//                 fontWeight: FontWeight.w600,
//                 color: Color(0xFF8a9bb0),
//                 letterSpacing: 0.5,
//               ),
//             ),
//             ////////////////////////////////////////////////////////////////////////////
//             ///  add member
//             ///////////////////////////////////////////////////////////////////////////
//             const SizedBox(height: 8),
//             Row(
//               children: [
//                 Expanded(
//                   child: AppTextField(
//                     controller: _memberCtrl,
//                     hintText: 'Enter staff ID',
//                     prefixIcon: Icons.person_add_rounded,
//                     onSubmitted: (_) => _addMember(),
//                   ),
//                 ),
//                 ////////////////////////////////////////////////////////////////////////////
//                 /// add member button
//                 ///////////////////////////////////////////////////////////////////////////
//                 const SizedBox(width: 10),
//                 ElevatedButton(
//                   onPressed: _addMember,
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: const Color(0xFF3a7bd5),
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(12),
//                     ),
//                     padding: const EdgeInsets.symmetric(
//                       vertical: 14,
//                       horizontal: 16,
//                     ),
//                   ),
//                   child: const Icon(Icons.add_rounded, color: Colors.white),
//                 ),
//               ],
//             ),

//             ////////////////////////////////////////////////////////////////////////////
//             /// Selected members list
//             ///////////////////////////////////////////////////////////////////////////
//             if (_error != null)
//               Padding(
//                 padding: const EdgeInsets.only(top: 8),
//                 child: Text(
//                   _error!,
//                   style: const TextStyle(color: Colors.redAccent, fontSize: 13),
//                 ),
//               ),

//             if (_memberIds.isNotEmpty) ...[
//               const SizedBox(height: 16),
//               const Text(
//                 'Selected Members',
//                 style: TextStyle(
//                   fontSize: 13,
//                   fontWeight: FontWeight.w600,
//                   color: Color(0xFF8a9bb0),
//                   letterSpacing: 0.5,
//                 ),
//               ),
//               ////////////////////////////////////////////////////////////////////////////
//               /// Selected members list
//               ///////////////////////////////////////////////////////////////////////////
//               const SizedBox(height: 8),
//               Wrap(
//                 spacing: 8,
//                 runSpacing: 8,
//                 children: _memberIds
//                     .map(
//                       (id) => Chip(
//                         label: Text(
//                           'Staff #$id',
//                           style: const TextStyle(
//                             color: Color(0xFFe8eaed),
//                             fontSize: 13,
//                           ),
//                         ),
//                         backgroundColor: const Color(0xFF17212b),
//                         deleteIconColor: const Color(0xFF8a9bb0),
//                         side: const BorderSide(color: Color(0xFF1f3040)),
//                         onDeleted: () => setState(() => _memberIds.remove(id)),
//                       ),
//                     )
//                     .toList(),
//               ),
//             ],
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontendmobile/features/communication/chat/presentation/widgets/components/app_text_field.dart';
import '../providers/chat_provider.dart';

class CreateGroupScreen extends ConsumerStatefulWidget {
  const CreateGroupScreen({super.key});
  @override
  ConsumerState<CreateGroupScreen> createState() => _CreateGroupScreenState();
}

class _CreateGroupScreenState extends ConsumerState<CreateGroupScreen> {
  final _nameCtrl = TextEditingController();
  final _memberCtrl = TextEditingController();
  final List<int> _memberIds = [];
  bool _loading = false;
  String? _error;

  @override
  void dispose() {
    _nameCtrl.dispose();
    _memberCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final name = _nameCtrl.text.trim();
    if (name.isEmpty) {
      setState(() => _error = 'Group name is required.');
      return;
    }
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final uc = ref.read(createGroupUCProvider);
      await uc(groupName: name, memberIds: _memberIds);
      if (mounted) Navigator.pop(context);
    } catch (e) {
      setState(() {
        _error = e.toString();
        _loading = false;
      });
    }
  }

  void _addMember() {
    final id = int.tryParse(_memberCtrl.text.trim());
    if (id == null) {
      setState(() => _error = 'Enter a valid staff ID.');
      return;
    }
    if (!_memberIds.contains(id)) {
      setState(() {
        _memberIds.add(id);
        _memberCtrl.clear();
        _error = null;
      });
    }
  }

@override
Widget build(BuildContext context) {
  return Scaffold(
    backgroundColor: const Color(0xFF0e1621),
    appBar: AppBar(
      backgroundColor: const Color(0xFF17212b),
      elevation: 0.5,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_rounded, color: Color(0xFF5caeff)),
        onPressed: () => Navigator.pop(context),
      ),
      title: const Text(
        'New Group Configuration', 
        style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600, letterSpacing: 0.2)
      ),
    ),
    body: SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section Title
          const Padding(
            padding: EdgeInsets.only(left: 4, bottom: 12),
            child: Text('GROUP DETAILS', style: TextStyle(color: Color(0xFF5caeff), fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 1.2)),
          ),
          
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: const Color(0xFF17212b),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: const Color(0xFF1f3040), width: 1),
            ),
            child: Column(
              children: [
                AppTextField(controller: _nameCtrl, hintText: 'Enter group display name', prefixIcon: Icons.badge_outlined),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(child: AppTextField(controller: _memberCtrl, hintText: 'Add staff member (ID)', prefixIcon: Icons.person_add_alt_1_rounded, onSubmitted: (_) => _addMember())),
                    const SizedBox(width: 12),
                    Material(
                      color: const Color(0xFF5caeff),
                      borderRadius: BorderRadius.circular(12),
                      child: IconButton(
                        onPressed: _addMember,
                        icon: const Icon(Icons.add_rounded, color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          if (_error != null) 
            Padding(padding: const EdgeInsets.only(top: 16), child: Text('⚠️ $_error', style: const TextStyle(color: Color(0xFFFF6B6B), fontSize: 13, fontWeight: FontWeight.w500))),

          const SizedBox(height: 32),

          if (_memberIds.isNotEmpty) ...[
            const Padding(
              padding: EdgeInsets.only(left: 4, bottom: 12),
              child: Text('ASSIGNED MEMBERS', style: TextStyle(color: Color(0xFF8a9bb0), fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 1.2)),
            ),
            Wrap(
              spacing: 10, runSpacing: 10,
              children: _memberIds.map((id) => Chip(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                label: Text('Staff #$id', style: const TextStyle(color: Colors.white, fontSize: 12)),
                backgroundColor: const Color(0xFF1f3040),
                deleteIcon: const Icon(Icons.close_rounded, size: 16),
                deleteIconColor: const Color(0xFF5caeff),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                onDeleted: () => setState(() => _memberIds.remove(id)),
              )).toList(),
            ),
          ],
        ],
      ),
    ),
    bottomNavigationBar: Container(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
      decoration: const BoxDecoration(color: Color(0xFF0e1621)),
      child: FilledButton(
        onPressed: _loading ? null : _submit,
        style: FilledButton.styleFrom(
          backgroundColor: const Color(0xFF5caeff),
          minimumSize: const Size(double.infinity, 54),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        ),
        child: _loading 
          ? const SizedBox(height: 24, width: 24, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
          : const Text('Create Group', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
      ),
    ),
  );
}
}