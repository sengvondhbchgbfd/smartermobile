import 'package:flutter/material.dart';
import 'package:frontendmobile/features/communication/chat/domain/entities/chat_group_entity.dart';
import 'package:frontendmobile/features/communication/chat/presentation/providers/chat_state.dart';

class ChatGroupInfoSheet extends StatelessWidget {
  final ChatGroupEntity group;
  final ChatState state;
  const ChatGroupInfoSheet({
    super.key,
    required this.group,
    required this.state,
  });

  @override
  Widget build(BuildContext context) {
    final isDirect = group.chatType == ChatType.direct;
    return DraggableScrollableSheet(
      initialChildSize: 0.6,
      maxChildSize: 0.9,
      minChildSize: 0.3,
      expand: false,
      builder: (_, sc) => ListView(
        controller: sc,
        padding: const EdgeInsets.all(20),
        children: [
          // ── Drag Handle ─────────────────────────────────────────────────
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: const Color(0xFF2a3f52),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 20),

          // ── Avatar ──────────────────────────────────────────────────────
          Center(
            child: Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isDirect
                    ? const Color(0xFF1e3d2a)
                    : const Color(0xFF1a3a5c),
              ),
              alignment: Alignment.center,
              child: Text(
                (group.groupName ?? 'C').isEmpty
                    ? 'C'
                    : group.groupName!.substring(0, 1).toUpperCase(),
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w600,
                  color: isDirect
                      ? const Color(0xFF4daf7c)
                      : const Color(0xFF5caeff),
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),

          // ── Name ────────────────────────────────────────────────────────
          Center(
            child: Text(
              group.groupName ?? 'Chat',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Color(0xFFe8eaed),
              ),
            ),
          ),
          const SizedBox(height: 4),

          // ── Type label ──────────────────────────────────────────────────
          Center(
            child: Text(
              isDirect ? 'Direct Message' : 'Group Chat',
              style: const TextStyle(fontSize: 13, color: Color(0xFF8a9bb0)),
            ),
          ),
          const SizedBox(height: 24),

          // ── Direct chat actions ─────────────────────────────────────────
          if (isDirect) ...[
            const Divider(color: Color(0xFF1f3040)),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.call_rounded, color: Color(0xFF8a9bb0)),
              title: const Text(
                'Voice Call',
                style: TextStyle(color: Color(0xFFe8eaed), fontSize: 14.5),
              ),
              onTap: () {},
            ),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(
                Icons.notifications_rounded,
                color: Color(0xFF8a9bb0),
              ),
              title: const Text(
                'Mute Notifications',
                style: TextStyle(color: Color(0xFFe8eaed), fontSize: 14.5),
              ),
              onTap: () {},
            ),
          ],

          // ── Group members list ──────────────────────────────────────────
          if (!isDirect) ...[
            const Text(
              'Members',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: Color(0xFF8a9bb0),
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(height: 10),
            ...state.members.map(
              (m) => ListTile(
                contentPadding: EdgeInsets.zero,
                leading: Container(
                  width: 40,
                  height: 40,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color(0xFF1a3a5c),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    (m.staffName ?? 'U').isEmpty
                        ? 'U'
                        : m.staffName!.substring(0, 1).toUpperCase(),
                    style: const TextStyle(
                      color: Color(0xFF5caeff),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                title: Text(
                  m.staffName ?? 'Unknown',
                  style: const TextStyle(
                    color: Color(0xFFe8eaed),
                    fontSize: 14.5,
                  ),
                ),
                subtitle: Text(
                  m.isAdmin ? 'Admin' : 'Member',
                  style: TextStyle(
                    fontSize: 12.5,
                    color: m.isAdmin
                        ? const Color(0xFF5caeff)
                        : const Color(0xFF8a9bb0),
                  ),
                ),
                trailing: state.onlineStaffIds.contains(m.staffId)
                    ? Container(
                        width: 8,
                        height: 8,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color(0xFF4daf7c),
                        ),
                      )
                    : null,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
