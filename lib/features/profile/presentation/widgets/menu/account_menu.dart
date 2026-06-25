import 'package:flutter/material.dart';

class AccountMenu extends StatelessWidget {
  const AccountMenu({super.key});

  @override
  Widget build(BuildContext context) {
    const items = [
      (Icons.settings_outlined,        'Settings',         true),
      (Icons.person_outline_rounded,   'Profile curation', false),
      (Icons.edit_outlined,            'Drafts',           false),
      (Icons.history_rounded,          'History',          false),
      (Icons.bookmark_outline_rounded, 'Saved',            false),
    ];

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 20, 12, 8),
          child: Row(
            children: [
              const Text(
                'My Account',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const Spacer(),
              IconButton(
                icon: const Icon(Icons.close_rounded, color: Colors.white54),
                onPressed: () => Navigator.of(context).pop(false), // ← false
              ),
            ],
          ),
        ),
        const Divider(color: Color(0xFF3F4147), height: 1),
        ...items.map((item) {
          return ListTile(
            leading: Icon(item.$1, color: Colors.white70, size: 22),
            title: Text(
              item.$2,
              style: const TextStyle(color: Colors.white, fontSize: 15),
            ),
            onTap: () => Navigator.of(context).pop(item.$3), // ← true only for Settings
            contentPadding: const EdgeInsets.symmetric(horizontal: 20),
          );
        }),
        SizedBox(height: MediaQuery.of(context).padding.bottom + 12),
      ],
    );
  }
}