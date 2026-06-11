import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/wizard_provider.dart';

////////////////////////////////////////
// For back
///////////////////////////////////////
class WizardController {
  final Ref ref;
  WizardController(this.ref);

  bool _lock = false;

  Future<void> handleBack({
    required BuildContext context,
    required int currentStep,
  }) async {
    if (_lock) return;
    _lock = true;

    final notifier = ref.read(wizardProvider.notifier);

    try {
      if (currentStep > 0) {
        notifier.previousStep();
      } else {
        context.go('/onboarding');
      }
    } finally {
      _lock = false;
    }
  }

  Future<void> handleNext() async {
    if (_lock) return;
    _lock = true;

    try {
      ref.read(wizardProvider.notifier).nextStep();
    } finally {
      _lock = false;
    }
  }
}

//////////////////////////////////////
//
/////////////////////////////////////

