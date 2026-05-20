import 'package:flutter/material.dart';

enum ManagerMode { me, staff, user }

class ModeToggle extends StatelessWidget {
  final ManagerMode current;
  final ValueChanged<ManagerMode> onChanged;

  const ModeToggle({super.key, required this.current, required this.onChanged});

  //////////////////////////////////////////////////////
  ///
  //////////////////////////////////////////////////////

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: ManagerMode.values.map((mode) {
        final isSelected = current == mode;
        final label = switch (mode) {
          ManagerMode.me => 'Me',
          ManagerMode.staff => 'Staff',
          ManagerMode.user => 'User',
        };

        final icon = switch (mode) {
          ManagerMode.me => Icons.person_outline,
          ManagerMode.staff => Icons.badge_outlined,
          ManagerMode.user => Icons.manage_accounts_outlined,
        };

        //////////////////////////////////////////////////////
        ///
        //////////////////////////////////////////////////////

        return GestureDetector(
          onTap: () => onChanged(mode),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            margin: const EdgeInsets.only(left: 6),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),

            //////////////////////////////////////////////
            ///
            /////////////////////////////////////////////
            decoration: BoxDecoration(
              color: isSelected
                  ? Theme.of(context).colorScheme.primary
                  : Colors.grey.shade100,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: isSelected
                    ? Theme.of(context).colorScheme.primary
                    : Colors.grey.shade300,
              ),
            ),
            /////////////////////////////////////////////
            ///
            /////////////////////////////////////////////
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  icon,
                  size: 13,
                  color: isSelected ? Colors.white : Colors.grey.shade600,
                ),
                const SizedBox(width: 4),
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: isSelected ? Colors.white : Colors.grey.shade600,
                  ),
                ),
              ],
            ),
            /////////////////////////////////////////////
            ///
            /////////////////////////////////////////////
          ),
        );
      }).toList(),
    );
  }
}
