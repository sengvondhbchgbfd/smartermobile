import 'package:flutter/material.dart';

class GenderDropdown extends StatelessWidget {
  final String? value;
  final List<String> genders;
  final ValueChanged<String?> onChanged;

  const GenderDropdown({super.key, 
    required this.value,
    required this.genders,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        color: const Color(0xFF2B2D31),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFF3F4147)),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          hint: const Text(
            'Gender',
            style: TextStyle(color: Color(0xFF80848E), fontSize: 13),
          ),
          dropdownColor: const Color(0xFF2B2D31),
          iconEnabledColor: const Color(0xFF80848E),
          isExpanded: true,
          items: [
            const DropdownMenuItem(
              value: null,
              child: Text(
                'Prefer not to say',
                style: TextStyle(color: Color(0xFFB5BAC1), fontSize: 14),
              ),
            ),
            ...genders.map(
              (g) => DropdownMenuItem(
                value: g,
                child: Row(
                  children: [
                    const SizedBox(width: 4),
                    Text(
                      g[0].toUpperCase() + g.substring(1),
                      style: const TextStyle(color: Colors.white, fontSize: 14),
                    ),
                  ],
                ),
              ),
            ),
          ],
          onChanged: onChanged,
        ),
      ),
    );
  }
}
