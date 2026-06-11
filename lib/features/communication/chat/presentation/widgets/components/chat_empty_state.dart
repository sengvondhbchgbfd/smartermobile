import 'package:flutter/material.dart';

class ChatEmptyState extends StatelessWidget {
  final bool isSearch;
  final VoidCallback onCreateGroup;
  const ChatEmptyState({
    super.key,
    required this.isSearch,
    required this.onCreateGroup,
  });

  @override
  Widget build(BuildContext context) => Center(
    child: Column(
      mainAxisSize: MainAxisSize.min,
      ////////////////////////////////////////////////////////////////////////
      ///
      ////////////////////////////////////////////////////////////////////////
      children: [
        Icon(
          isSearch
              ? Icons.search_off_rounded
              : Icons.chat_bubble_outline_rounded,
          size: 52,
          color: const Color(0xFF2a3f52),
        ),
        const SizedBox(height: 12),
        Text(
          isSearch ? 'No conversations found' : 'No conversations yet',
          style: const TextStyle(color: Color(0xFF8a9bb0), fontSize: 15),
        ),

        //////////////////////////////////////////////////////////////////////
        ///
        //////////////////////////////////////////////////////////////////////
        if (!isSearch) ...[
          const SizedBox(height: 16),
          TextButton.icon(
            onPressed: onCreateGroup,
            icon: const Icon(Icons.add_rounded, color: Color(0xFF5caeff)),
            label: const Text(
              'Create a group',
              style: TextStyle(color: Color(0xFF5caeff)),
            ),
          ),
        ],
        //////////////////////////////////////////////////////////////////////
        ///
        //////////////////////////////////////////////////////////////////////
      ],
    ),
  );
}
