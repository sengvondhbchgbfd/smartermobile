import 'package:flutter/material.dart';

class ChatDeletedBody extends StatelessWidget {
  final bool isMe;
  const ChatDeletedBody({super.key, required this.isMe});
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: const [
        Icon(Icons.block_rounded, size: 14, color: Color(0xFF8a9bb0)),
        SizedBox(width: 6),
        Text(
          'This message was deleted',
          style: TextStyle(
            fontSize: 13.5,
            color: Color(0xFF8a9bb0),
            fontStyle: FontStyle.italic,
          ),
        ),
      ],
    ),
  );
}
