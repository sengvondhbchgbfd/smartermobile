import 'package:flutter/material.dart';

class ChatSenderName extends StatelessWidget {
  final String name;
  const ChatSenderName({super.key, required this.name});
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.fromLTRB(12, 8, 12, 0),
    child: Text(
      name,
      style: const TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w600,
        color: Color(0xFF5caeff),
      ),
    ),
  );
}
