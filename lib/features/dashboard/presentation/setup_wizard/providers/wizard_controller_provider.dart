import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../controllers/wizard_controller.dart';

final wizardControllerProvider = Provider<WizardController>((ref) {
  return WizardController(ref);
});