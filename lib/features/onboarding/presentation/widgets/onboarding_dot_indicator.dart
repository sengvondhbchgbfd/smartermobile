import 'package:flutter/material.dart';

class OnboardingDotIndicator extends StatelessWidget {
  final int count;
  final int current;

  const OnboardingDotIndicator({
    super.key,
    required this.count,
    required this.current,
  });

  ///////////////////////////////////////////////
  //
  //////////////////////////////////////////////
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(count, (i) {
        final isActive = i == current;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 350),
          curve: Curves.easeInOut,
          margin: const EdgeInsets.symmetric(horizontal: 4),
          width: isActive ? 32 : 8,
          height: 8,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4),
            color: isActive
                ? const Color.fromARGB(255, 211, 15, 15)
                : const Color(0xFFC8E6C9),
          ),
        );
      }),
    );
  }
}
