import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontendmobile/features/communication/chat/presentation/widgets/components/chat_empty_state.dart';
import 'package:frontendmobile/features/communication/chat/presentation/widgets/components/chat_error_view.dart';
import '../../domain/entities/chat_group_entity.dart';
import '../providers/chat_provider.dart';
import '../widgets/group_list_item.dart';
import 'chat_screen.dart';
import 'create_group_screen.dart';

class ChatGroupsScreen extends ConsumerStatefulWidget {
  const ChatGroupsScreen({super.key});
  @override
  ConsumerState<ChatGroupsScreen> createState() => _ChatGroupsScreenState();
}

class _ChatGroupsScreenState extends ConsumerState<ChatGroupsScreen> {
  //=============================================================================
  // STATE VARIABLES
  //=============================================================================

  String _search = '';
  @override
  Widget build(BuildContext context) {
    final groupsAsync = ref.watch(groupListProvider);
    final staffIdAsync = ref.watch(currentStaffIdProvider);
    if (!staffIdAsync.hasValue) {
      return const Scaffold(
        backgroundColor: Color(0xFF0e1621),
        body: Center(
          child: CircularProgressIndicator(color: Color(0xFF5caeff)),
        ),
      );
    }

    // =========================================================================
    //
    //==========================================================================

    return Scaffold(
      backgroundColor: const Color(0xFF0e1621),

      // =======================================================================
      // Messages AppBar
      //========================================================================
      appBar: AppBar(
        backgroundColor: const Color(0xFF17212b),
        elevation: 0,
        title: const Text(
          'Messages',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Color(0xFFe8eaed),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_rounded, color: Color(0xFF8a9bb0)),
            onPressed: () => _openCreateGroup(context),
            tooltip: 'New Group',
          ),
        ],
      ),

      // =======================================================================
      // Messages Body
      //========================================================================
      body: Column(
        children: [
          // ===================================================================
          // Search Bar
          //====================================================================
          Container(
            color: const Color(0xFF17212b),
            padding: const EdgeInsets.fromLTRB(12, 0, 12, 10),
            child: TextField(
              onChanged: (v) => setState(() => _search = v.toLowerCase()),
              style: const TextStyle(color: Color(0xFFe8eaed), fontSize: 14.5),
              decoration: InputDecoration(
                hintText: 'Search conversations…',
                hintStyle: const TextStyle(color: Color(0xFF8a9bb0)),
                prefixIcon: const Icon(
                  Icons.search_rounded,
                  color: Color(0xFF8a9bb0),
                  size: 20,
                ),
                filled: true,
                fillColor: const Color(0xFF0e1621),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(22),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),

          // ===================================================================
          // Group List
          //====================================================================
          Expanded(
            child: groupsAsync.when(
              loading: () => const Center(
                child: CircularProgressIndicator(color: Color(0xFF5caeff)),
              ),

              //////////////////////////////////////////////////////////////////
              /// Error state
              //////////////////////////////////////////////////////////////////
              error: (e, __) => ChatErrorView(
                error: e.toString(),
                onRetry: () => ref.invalidate(groupListProvider),
              ),
              //////////////////////////////////////////////////////////////////
              /// Data state
              //////////////////////////////////////////////////////////////////
              data: (groups) {
                final filtered = _search.isEmpty
                    ? groups
                    : groups
                          .where(
                            (g) => (g.groupName ?? '').toLowerCase().contains(
                              _search,
                            ),
                          )
                          .toList();

                if (filtered.isEmpty) {
                  return ChatEmptyState(
                    isSearch: _search.isNotEmpty,
                    onCreateGroup: () => _openCreateGroup(context),
                  );
                }

                ////////////////////////////////////////////////////////////////
                ///
                ////////////////////////////////////////////////////////////////

                return RefreshIndicator(
                  color: const Color(0xFF5caeff),
                  backgroundColor: const Color(0xFF17212b),
                  onRefresh: () => ref.refresh(groupListProvider.future),
                  /////////////////////////////////////////
                  //
                  /////////////////////////////////////////
                  child: ListView.separated(
                    physics: const AlwaysScrollableScrollPhysics(),
                    itemCount: filtered.length,
                    separatorBuilder: (_, __) => const Divider(
                      height: 0.5,
                      color: Color(0xFF1f3040),
                      indent: 72,
                    ),
                    /////////////////////////////////////////
                    //
                    /////////////////////////////////////////
                    itemBuilder: (_, i) {
                      final g = filtered[i];
                      return GroupListItem(
                        group: g,
                        onTap: () => _openChat(context, g),
                      );
                    },
                    /////////////////////////////////////////
                    //
                    /////////////////////////////////////////
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF3a7bd5),
        onPressed: () => _openCreateGroup(context),
        child: const Icon(Icons.chat_rounded, color: Colors.white),
      ),
    );
  }

  /////////////////////////////////////////////////////////////////////////////
  ///
  ////////////////////////////////////////////////////////////////////////////

  void _openChat(BuildContext context, ChatGroupEntity group) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => ChatScreen(group: group)),
    );
  }

  /////////////////////////////////////////////////////////////////////////////
  ///
  ////////////////////////////////////////////////////////////////////////////

  void _openCreateGroup(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const CreateGroupScreen()),
    ).then((_) => ref.invalidate(groupListProvider));
  }

  /////////////////////////////////////////////////////////////////////////////
  ///
  ////////////////////////////////////////////////////////////////////////////
}
