import 'package:flutter/material.dart';

class OnboardingStepIndicator extends StatelessWidget {
  final int currentStep;
  final int totalSteps;

  const OnboardingStepIndicator({
    super.key,
    required this.currentStep,
    required this.totalSteps,
  });

  ///////////////////////////////////////////////////////////////
  //
  ///////////////////////////////////////////////////////////////
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ///////////////////////////////////////////////////
        // dots
        ////////////////////////////////////////////////////
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(totalSteps, (index) {
            final isActive = index == currentStep;
            final isComplete = index < currentStep;
            return AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              margin: const EdgeInsets.symmetric(horizontal: 4),
              width: isActive ? 28 : 10,
              height: 10,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: isComplete
                    ? const Color(0xFF6366F1)
                    : isActive
                    ? const Color(0xFF6366F1)
                    : Colors.white12,
              ),
              child: isComplete
                  ? const Icon(Icons.check, color: Colors.white, size: 8)
                  : null,
            );
          }),
        ),
        const SizedBox(height: 0),
        Text(
          'Step ${currentStep + 1} of $totalSteps',
          style: const TextStyle(color: Colors.white38, fontSize: 12),
        ),
      ],
    );
  }
}
