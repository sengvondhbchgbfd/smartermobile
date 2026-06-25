import 'package:flutter/material.dart';

class EmptyPermissions extends StatelessWidget {
  const EmptyPermissions({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 40),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: const [
          Icon(Icons.shield_outlined, size: 36, color: Color(0xFF4E5058)),
          SizedBox(height: 10),
          Text(
            'No permissions assigned',
            style: TextStyle(fontSize: 13, color: Color(0xFF80848E)),
          ),
        ],
      ),
    );
  }
}
