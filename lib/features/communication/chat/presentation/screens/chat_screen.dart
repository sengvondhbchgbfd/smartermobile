// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:frontendmobile/features/communication/chat/presentation/providers/chat_state.dart';
// import 'package:frontendmobile/features/communication/chat/presentation/widgets/components/chat_date_divider.dart';
// import 'package:frontendmobile/features/communication/chat/presentation/widgets/components/chat_error_banner.dart';
// import 'package:frontendmobile/features/communication/chat/presentation/widgets/components/chat_group_info_sheet.dart';
// import 'package:frontendmobile/features/communication/chat/presentation/widgets/components/chat_header_avatar.dart';
// import '../../domain/entities/chat_group_entity.dart';
// import '../../domain/entities/chat_message_entity.dart';
// import '../providers/chat_provider.dart';
// import '../widgets/chat_bubble.dart';
// import '../widgets/chat_input_bar.dart';

// class ChatScreen extends ConsumerStatefulWidget {
//   final ChatGroupEntity group;
//   const ChatScreen({super.key, required this.group});
//   @override
//   ConsumerState<ChatScreen> createState() => _ChatScreenState();
// }

// // =============================================================================
// //
// //==============================================================================

// class _ChatScreenState extends ConsumerState<ChatScreen> {
//   // ===========================================================================
//   //
//   //============================================================================
//   final _scrollCtrl = ScrollController();
//   ChatMessageEntity? _replyTarget;

//   @override
//   void initState() {
//     super.initState();
//     _scrollCtrl.addListener(_onScroll);
//   }

//   @override
//   void dispose() {
//     _scrollCtrl.dispose();
//     super.dispose();
//   }

//   void _onScroll() {
//     if (!_scrollCtrl.hasClients) return;
//     if (_scrollCtrl.position.pixels >=
//         _scrollCtrl.position.maxScrollExtent - 120) {
//       final notifier = ref.read(chatProvider(widget.group.groupId).notifier);
//       final state = ref.read(chatProvider(widget.group.groupId));
//       if (!state.loadingMessages && state.hasMore) {
//         notifier.loadMessages();
//       }
//     }
//   }

//   // ===========================================================================
//   //
//   //============================================================================

//   @override
//   Widget build(BuildContext context) {
//     final userIdAsync = ref.watch(currentUserIdProvider);
//     final repoAsync = ref.watch(chatRepositoryProvider);

//     // =========================================================================
//     //
//     //==========================================================================

//     if (!userIdAsync.hasValue || !repoAsync.hasValue) {
//       return const Scaffold(
//         backgroundColor: Color(0xFF0e1621),
//         body: Center(
//           child: CircularProgressIndicator(color: Color(0xFF5caeff)),
//         ),
//       );
//     }
//     // =========================================================================
//     //
//     //==========================================================================

//     final int resolvedStaffId = userIdAsync.value!;
//     final state = ref.watch(chatProvider(widget.group.groupId));
//     final notifier = ref.read(chatProvider(widget.group.groupId).notifier);
//     final isDirect = widget.group.chatType == ChatType.direct;
//     final onlineCount = state.onlineStaffIds.length;
//     final subtitle = isDirect
//         ? (state.onlineStaffIds.isNotEmpty ? 'Online' : 'Offline')
//         : '${state.members.length} members${onlineCount > 0 ? ', $onlineCount online' : ''}';
//     // =========================================================================
//     //
//     //==========================================================================

//     return Scaffold(
//       backgroundColor: const Color(0xFF0e1621),
//       appBar: _buildAppBar(subtitle, state),
//       body: Column(
//         children: [
//           Expanded(
//             child: state.loadingMessages && state.messages.isEmpty
//                 ? const Center(
//                     child: CircularProgressIndicator(color: Color(0xFF5caeff)),
//                   )
//                 : _buildMessageList(state, notifier, resolvedStaffId),
//           ),
//           if (state.error != null) ChatErrorBanner(error: state.error!),
//           ChatInputBar(
//             replyTarget: _replyTarget,
//             onCancelReply: () => setState(() => _replyTarget = null),
//             onSendText: (text, {replyToId}) async {
//               notifier.sendText(text, replyToId: replyToId);
//               setState(() => _replyTarget = null);
//             },
//             onSendImage: (file, {replyToId}) async {
//               notifier.sendImage(file, replyToId: replyToId);
//               setState(() => _replyTarget = null);
//             },
//             onSendVideo: (file, {replyToId}) async {
//               notifier.sendVideo(file, replyToId: replyToId);
//               setState(() => _replyTarget = null);
//             },
//             onSendAudio: (file, {isVoice = false, replyToId}) async {
//               notifier.sendAudio(file, isVoice: isVoice, replyToId: replyToId);
//               setState(() => _replyTarget = null);
//             },
//             onSendFile: (file, {replyToId}) async {
//               notifier.sendFile(file, replyToId: replyToId);
//               setState(() => _replyTarget = null);
//             },
//           ),
//         ],
//       ),
//     );
//   }

//   // =========================================================================
//   //
//   //==========================================================================

//   AppBar _buildAppBar(String subtitle, ChatState state) {
//     return AppBar(
//       backgroundColor: const Color(0xFF17212b),
//       elevation: 0,
//       titleSpacing: 0,
//       leading: IconButton(
//         icon: const Icon(
//           Icons.arrow_back_ios_rounded,
//           color: Color(0xFF5caeff),
//         ),
//         onPressed: () => Navigator.pop(context),
//       ),

//       /////////////////////////////////////////////////////////////////////////
//       ///
//       ////////////////////////////////////////////////////////////////////////
//       title: GestureDetector(
//         onTap: () => _showGroupInfo(state),
//         child: Row(
//           children: [
//             ChatHeaderAvatar(group: widget.group),
//             const SizedBox(width: 10),
//             Expanded(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     widget.group.groupName ?? 'Chat',
//                     style: const TextStyle(
//                       fontSize: 16,
//                       fontWeight: FontWeight.w600,
//                       color: Color(0xFFe8eaed),
//                     ),
//                     overflow: TextOverflow.ellipsis,
//                   ),
//                   Text(
//                     subtitle,
//                     style: const TextStyle(
//                       fontSize: 12.5,
//                       color: Color(0xFF8a9bb0),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),

//       /////////////////////////////////////////////////////////////////////////
//       ///
//       ////////////////////////////////////////////////////////////////////////
//       actions: [
//         IconButton(
//           icon: const Icon(Icons.search_rounded, color: Color(0xFF8a9bb0)),
//           onPressed: () {},
//         ),
//         if (widget.group.chatType == ChatType.direct)
//           IconButton(
//             icon: const Icon(Icons.call_rounded, color: Color(0xFF8a9bb0)),
//             onPressed: () {},
//           ),
//         IconButton(
//           icon: const Icon(Icons.more_vert_rounded, color: Color(0xFF8a9bb0)),
//           onPressed: () => _showGroupInfo(state),
//         ),
//       ],
//       /////////////////////////////////////////////////////////////////////////
//       ///
//       ////////////////////////////////////////////////////////////////////////
//     );
//   }

//   // =========================================================================
//   //
//   //==========================================================================

//   Widget _buildMessageList(
//     ChatState state,
//     ChatNotifier notifier,
//     int resolvedStaffId,
//   ) {
//     final messages = state.messages;
//     if (messages.isEmpty) {
//       return const Center(
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             Icon(
//               Icons.chat_bubble_outline_rounded,
//               size: 48,
//               color: Color(0xFF2a3f52),
//             ),
//             SizedBox(height: 12),
//             Text(
//               'No messages yet. Say hi! 👋',
//               style: TextStyle(color: Color(0xFF8a9bb0), fontSize: 15),
//             ),
//           ],
//         ),
//       );
//     }

//     // =========================================================================
//     //
//     //==========================================================================

//     return ListView.builder(
//       controller: _scrollCtrl,
//       reverse: true,
//       padding: const EdgeInsets.symmetric(vertical: 8),
//       itemCount: messages.length + (state.loadingMessages ? 1 : 0),
//       itemBuilder: (_, i) {
//         if (i == messages.length) {
//           return const Center(
//             child: Padding(
//               padding: EdgeInsets.all(12),
//               child: CircularProgressIndicator(
//                 strokeWidth: 2,
//                 color: Color(0xFF5caeff),
//               ),
//             ),
//           );
//         }

//         // =====================================================================
//         //
//         //======================================================================

//         final msg = messages[i];
//         final isMe = msg.senderId == resolvedStaffId;
//         final isGroup = widget.group.chatType == ChatType.group;
//         final showName = !isMe && isGroup;

//         final nextMsg = i + 1 < messages.length ? messages[i + 1] : null;
//         final showDate =
//             nextMsg == null || !_sameDay(msg.createdAt, nextMsg.createdAt);

//         return Column(
//           children: [
//             if (showDate) ChatDateDivider(date: msg.createdAt),
//             ChatBubble(
//               message: msg,
//               isMe: isMe,
//               showSenderName: showName,
//               onReply: () => setState(() => _replyTarget = msg),
//               onDelete: isMe
//                   ? () => notifier.deleteMessage(msg.messageId)
//                   : null,
//               onTapReply: msg.replyToId != null
//                   ? () => _scrollToMessage(msg.replyToId!)
//                   : null,
//             ),
//           ],
//         );
//       },
//     );
//   }

//   bool _sameDay(DateTime a, DateTime b) =>
//       a.year == b.year && a.month == b.month && a.day == b.day;

//   void _scrollToMessage(int messageId) {
//     if (!_scrollCtrl.hasClients) return;
//     final messages = ref.read(chatProvider(widget.group.groupId)).messages;
//     final idx = messages.indexWhere((m) => m.messageId == messageId);
//     if (idx == -1) return;

//     // Each item is ~72px average — estimate offset
//     const estimatedItemHeight = 72.0;
//     final offset = idx * estimatedItemHeight;
//     _scrollCtrl.animateTo(
//       offset.clamp(0, _scrollCtrl.position.maxScrollExtent),
//       duration: const Duration(milliseconds: 350),
//       curve: Curves.easeInOut,
//     );
//   }

//   void _showGroupInfo(ChatState state) {
//     showModalBottomSheet(
//       context: context,
//       backgroundColor: const Color(0xFF17212b),
//       isScrollControlled: true,
//       shape: const RoundedRectangleBorder(
//         borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
//       ),
//       builder: (_) => ChatGroupInfoSheet(group: widget.group, state: state),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontendmobile/features/communication/chat/presentation/providers/chat_state.dart';
// import 'package:frontendmobile/features/communication/chat/presentation/widgets/components/chat_date_divider.dart';
import 'package:frontendmobile/features/communication/chat/presentation/widgets/components/chat_error_banner.dart';
import 'package:frontendmobile/features/communication/chat/presentation/widgets/components/chat_group_info_sheet.dart';
import 'package:frontendmobile/features/communication/chat/presentation/widgets/components/chat_header_avatar.dart';
import '../../domain/entities/chat_group_entity.dart';
import '../../domain/entities/chat_message_entity.dart';
import '../providers/chat_provider.dart';
import '../widgets/chat_bubble.dart';
import '../widgets/chat_input_bar.dart';

class ChatScreen extends ConsumerStatefulWidget {
  final ChatGroupEntity group;
  const ChatScreen({super.key, required this.group});
  @override
  ConsumerState<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends ConsumerState<ChatScreen> {
  final _scrollCtrl = ScrollController();
  ChatMessageEntity? _replyTarget;

  @override
  void initState() {
    super.initState();
    _scrollCtrl.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollCtrl.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (!_scrollCtrl.hasClients) return;
    if (_scrollCtrl.position.pixels >= _scrollCtrl.position.maxScrollExtent - 120) {
      final notifier = ref.read(chatProvider(widget.group.groupId).notifier);
      final state = ref.read(chatProvider(widget.group.groupId));
      if (!state.loadingMessages && state.hasMore) notifier.loadMessages();
    }
  }

  @override
  Widget build(BuildContext context) {
    final userIdAsync = ref.watch(currentUserIdProvider);
    final repoAsync = ref.watch(chatRepositoryProvider);

    if (!userIdAsync.hasValue || !repoAsync.hasValue) {
      return const Scaffold(
        backgroundColor: Color(0xFF0e1621),
        body: Center(child: CircularProgressIndicator(color: Color(0xFF5caeff))),
      );
    }

    final resolvedStaffId = userIdAsync.value!;
    final state = ref.watch(chatProvider(widget.group.groupId));
    final notifier = ref.read(chatProvider(widget.group.groupId).notifier);

    return Scaffold(
      backgroundColor: const Color(0xFF0e1621),
      appBar: _buildAppBar(state),
      body: Column(
        children: [
          Expanded(
            child: state.loadingMessages && state.messages.isEmpty
                ? const Center(child: CircularProgressIndicator(color: Color(0xFF5caeff)))
                : _buildMessageList(state, notifier, resolvedStaffId),
          ),
          if (state.error != null) ChatErrorBanner(error: state.error!),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            decoration: const BoxDecoration(
              color: Color(0xFF17212b),
              borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
            ),
            child: ChatInputBar(
              replyTarget: _replyTarget,
              onCancelReply: () => setState(() => _replyTarget = null),
              onSendText: (text, {replyToId}) async => _handleSend(text, replyToId: replyToId, notifier: notifier),
              onSendImage: (file, {replyToId}) async => _handleSend(file, isFile: true, replyToId: replyToId, notifier: notifier),
              onSendVideo: (file, {replyToId}) async => _handleSend(file, isFile: true, replyToId: replyToId, notifier: notifier),
              onSendAudio: (file, {isVoice = false, replyToId}) async => _handleSend(file, isFile: true, replyToId: replyToId, notifier: notifier),
              onSendFile: (file, {replyToId}) async => _handleSend(file, isFile: true, replyToId: replyToId, notifier: notifier),
            ),
          ),
        ],
      ),
    );
  }

  void _handleSend(dynamic content, {bool isFile = false, int? replyToId, required ChatNotifier notifier}) {
    if (isFile) {
      // Logic for file handling
    } else {
      notifier.sendText(content, replyToId: replyToId);
    }
    setState(() => _replyTarget = null);
  }

  AppBar _buildAppBar(ChatState state) {
    return AppBar(
      backgroundColor: const Color(0xFF17212b),
      elevation: 2,
      shadowColor: Colors.black.withOpacity(0.5),
      titleSpacing: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Color(0xFF5caeff)),
        onPressed: () => Navigator.pop(context),
      ),
      title: InkWell(
        onTap: () => _showGroupInfo(state),
        child: Row(
          children: [
            ChatHeaderAvatar(group: widget.group),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(widget.group.groupName ?? 'Chat', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                  Text("Tap to view details", style: TextStyle(fontSize: 11, color: const Color(0xFF5caeff).withOpacity(0.8))),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMessageList(ChatState state, ChatNotifier notifier, int resolvedStaffId) {
    if (state.messages.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.forum_outlined, size: 64, color: const Color(0xFF2a3f52)),
            const SizedBox(height: 16),
            const Text('No messages yet', style: TextStyle(color: Color(0xFF8a9bb0), fontWeight: FontWeight.w500)),
          ],
        ),
      );
    }

    return ListView.builder(
      controller: _scrollCtrl,
      reverse: true,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
      itemCount: state.messages.length,
      itemBuilder: (_, i) {
        final msg = state.messages[i];
        final isMe = msg.senderId == resolvedStaffId;
        return Column(
          children: [
            ChatBubble(
              message: msg,
              isMe: isMe,
              showSenderName: widget.group.chatType == ChatType.group && !isMe,
              onReply: () => setState(() => _replyTarget = msg),
            ),
          ],
        );
      },
    );
  }

  void _showGroupInfo(ChatState state) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF17212b),
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (_) => ChatGroupInfoSheet(group: widget.group, state: state),
    );
  }
}