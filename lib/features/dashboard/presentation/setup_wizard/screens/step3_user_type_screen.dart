import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontendmobile/features/dashboard/presentation/setup_wizard/providers/wizard_provider.dart';
import 'package:frontendmobile/shared/widgets/wizard_buttons.dart';

class Step3UserTypeScreen extends ConsumerStatefulWidget {
  const Step3UserTypeScreen({super.key});
  @override
  ConsumerState<Step3UserTypeScreen> createState() => _Step3UserTypeState();
}

class _Step3UserTypeState extends ConsumerState<Step3UserTypeScreen> {
  String? _selected;

  @override
  Widget build(BuildContext context) {
    /////////////////////////////////////////////
    ///
    /////////////////////////////////////////////

    ///////////////////////////////////////////////
    ///
    ///////////////////////////////////////////////

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          _TypeCard(
            icon: Icons.people_outlined,
            title: 'Staff',
            subtitle: 'Employees, managers, and team members',
            selected: _selected == 'staff',
            onTap: () => setState(() => _selected = 'staff'),
          ),
          const SizedBox(height: 16),
          _TypeCard(
            icon: Icons.person_outlined,
            title: 'Customer',
            subtitle: 'Clients and customers of the company',
            selected: _selected == 'customer',
            onTap: () => setState(() => _selected = 'customer'),
          ),
          const Spacer(),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => ref.read(wizardProvider.notifier).nextStep(),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Colors.white24),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  child: const Text(
                    'Skip',
                    style: TextStyle(color: Colors.white54),
                  ),
                ),
              ),

              const SizedBox(width: 12),
              Expanded(
                flex: 2,
                child: ElevatedButton(
                  onPressed: _selected == null
                      ? null
                      : () => ref
                            .read(wizardProvider.notifier)
                            .selectUserType(_selected!),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF6366F1),
                    disabledBackgroundColor: Colors.white12,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  child: const Text(
                    'Continue',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _TypeCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final bool selected;
  final VoidCallback onTap;

  const _TypeCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: selected
              ? const Color(0xFF6366F1).withOpacity(0.15)
              : const Color(0xFF0F172A),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: selected ? const Color(0xFF6366F1) : Colors.white12,
            width: selected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: selected
                    ? const Color(0xFF6366F1).withOpacity(0.2)
                    : Colors.white10,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                icon,
                color: selected ? const Color(0xFF6366F1) : Colors.white54,
                size: 24,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      color: selected ? Colors.white : Colors.white70,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: const TextStyle(color: Colors.white38, fontSize: 13),
                  ),
                ],
              ),
            ),
            if (selected)
              const Icon(
                Icons.check_circle,
                color: Color(0xFF6366F1),
                size: 22,
              ),
          ],
        ),
      ),
    );
  }
}
