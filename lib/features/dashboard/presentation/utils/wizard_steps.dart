import 'package:flutter/cupertino.dart';
import 'package:frontendmobile/features/dashboard/presentation/setup_wizard/screens/step0_company_screen.dart';
import 'package:frontendmobile/features/dashboard/presentation/setup_wizard/screens/step1_role_screen.dart';
import 'package:frontendmobile/features/dashboard/presentation/setup_wizard/screens/step2_department_screen.dart';
import 'package:frontendmobile/features/dashboard/presentation/setup_wizard/screens/step3_user_type_screen.dart';
import 'package:frontendmobile/features/dashboard/presentation/setup_wizard/screens/step4_avatar_screen.dart';
import 'package:frontendmobile/features/dashboard/presentation/setup_wizard/screens/step5_create_user_screen.dart';

class WizardSteps {
  static final List<Widget Function()> steps = [
    () => const Step0CompanyScreen(key: ValueKey('step0')),
    () => const Step1RoleScreen(key: ValueKey('step1')),
    () => const Step2DepartmentScreen(key: ValueKey('step2')),
    () => const Step3UserTypeScreen(key: ValueKey('step3')),
    () => const Step4AvatarScreen(key: ValueKey('step4')),
    () => const Step5CreateUserScreen(key: ValueKey("step5")),
  ];
  static Widget get(int index) {
    if (index < 0 || index >= steps.length) {
      return const SizedBox();
    }
    return steps[index]();
  }
}
