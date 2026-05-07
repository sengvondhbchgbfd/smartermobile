import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontendmobile/features/dashboard/presentation/setup_wizard/providers/wizard_controller_provider.dart';
import 'package:frontendmobile/features/dashboard/presentation/setup_wizard/providers/wizard_provider.dart';
import 'package:frontendmobile/features/dashboard/presentation/utils/wizard_steps.dart';

class WizardScreen extends ConsumerWidget {
  const WizardScreen({super.key});

  static const _steps = [
    '🏢 Company',
    '💼 Role',
    '🏢 Department',
    '👤 User Type',
    '🖼️ Avatar',
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(wizardProvider);
    final step = state.currentStep.clamp(0, _steps.length - 1);
    final controller = ref.read(wizardControllerProvider);

    ///////////////////////////////////////////////////////////////
    // ── Professional Navigation Guard ──────────────────────────
    ///////////////////////////////////////////////////////////////
    return PopScope(
      ////////////////////////////////////////////////////////////
      canPop: false, // Prevent accidental exit
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        controller.handleBack(context: context, currentStep: state.currentStep);
      },

      ////////////////////////////////////////////////////////////
      child: Scaffold(
        backgroundColor: const Color(0xFFFAFAFA),
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0.5,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Color(0xFF2168D3)),
            onPressed: state.isBusy
                ? null
                : () => controller.handleBack(
                    context: context,
                    currentStep: state.currentStep,
                  ),
          ),
          title: Text(
            _steps[step],
            style: const TextStyle(
              color: Colors.black,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        body: Column(
          children: [
            ///////////////////////////////////////////////////////////
            // ── Progress Linear Indicator ──────────────────────────
            //////////////////////////////////////////////////////////
            LinearProgressIndicator(
              value: (step + 1) / _steps.length,
              backgroundColor: Colors.grey[200],
              color: const Color(0xFFFF5722),
            ),

            //////////////////////////////////////////////////////////
            ///
            /////////////////////////////////////////////////////////
            Expanded(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 350),
                transitionBuilder: (child, animation) {
                  final slide = Tween<Offset>(
                    begin: const Offset(0.2, 0),
                    end: Offset.zero,
                  ).animate(animation);
                  return FadeTransition(
                    opacity: animation,
                    child: SlideTransition(position: slide, child: child),
                  );
                },
                child: KeyedSubtree(
                  key: ValueKey(state.currentStep),
                  child: WizardSteps.get(state.currentStep),
                ),
              ),
            ),
            //////////////////////////////////////////////////////
            //
            //////////////////////////////////////////////////////
          ],
        ),
      ),
    );
  }
}
