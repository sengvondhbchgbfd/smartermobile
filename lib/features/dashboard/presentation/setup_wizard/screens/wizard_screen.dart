import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontendmobile/config/routes/route_names.dart';
import 'package:frontendmobile/features/dashboard/presentation/setup_wizard/providers/wizard_provider.dart';
import 'package:frontendmobile/features/dashboard/presentation/setup_wizard/screens/step0_company_screen.dart';
import 'package:frontendmobile/features/dashboard/presentation/setup_wizard/screens/step1_role_screen.dart';
import 'package:frontendmobile/features/dashboard/presentation/setup_wizard/screens/step2_department_screen.dart';
import 'package:frontendmobile/features/dashboard/presentation/setup_wizard/screens/step3_user_type_screen.dart';
import 'package:frontendmobile/features/dashboard/presentation/setup_wizard/screens/step4_avatar_screen.dart';
import 'package:go_router/go_router.dart';

class WizardScreen extends ConsumerWidget {
  const WizardScreen({super.key});
  static const _steps = [
    '💼 Role',
    '🏢 Department',
    '👤 User Type',
    '🖼️ Avatar',
  ];
  //////////////////////////////////////////////////////////////
  //
  /////////////////////////////////////////////////////////////
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(wizardProvider);
    final step = state.currentStep.clamp(0, _steps.length - 1);
    // final notifier = ref.read(wizardProvider.notifier);

    if (state.currentStep >= _steps.length) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        context.go(RouteNames.home);
      });
    }
    //////////////////////////////////////////////////////////
    //
    /////////////////////////////////////////////////////////

    return Scaffold(
      backgroundColor: const Color(0xFF0B1120),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Setup Wizard',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
        ),
        actions: [
          TextButton(
            onPressed: () => context.go(RouteNames.home),
            child: const Text(
              'Skip All',
              style: TextStyle(color: Colors.white38),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          ////////////////////////////////////////////////////////////
          // ── Step indicator ───────────────────────────────────────
          /////////////////////////////////////////////////////////////
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            child: Row(
              children: List.generate(_steps.length, (i) {
                final done = i < step;
                final active = i == step;
                return Expanded(
                  child: Row(
                    children: [
                      Expanded(
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          height: 4,
                          decoration: BoxDecoration(
                            color: done || active
                                ? const Color(0xFF6366F1)
                                : Colors.white12,
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                      ),
                      if (i < _steps.length - 1) const SizedBox(width: 4),
                    ],
                  ),
                );
              }),
            ),
          ),

          ////////////////////////////////////////////////////////////
          // ── Step label ───────────────────────────────────────────
          ////////////////////////////////////////////////////////////
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Step ${step + 1} of ${_steps.length}',
                  style: const TextStyle(color: Colors.white38, fontSize: 12),
                ),
                Text(
                  _steps[step],
                  style: const TextStyle(
                    color: Color(0xFF6366F1),
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 8),

          ////////////////////////////////////////////////////////////
          // ── Step content ─────────────────────────────────────────
          ////////////////////////////////////////////////////////////
          Expanded(
            child: IndexedStack(
              index: step,
              children: const [
                Step0CompanyScreen(),
                Step1RoleScreen(),
                Step2DepartmentScreen(),
                Step3UserTypeScreen(),
                Step4AvatarScreen(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
