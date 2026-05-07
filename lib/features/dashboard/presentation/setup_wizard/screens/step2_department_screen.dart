import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontendmobile/features/dashboard/presentation/setup_wizard/providers/wizard_provider.dart';
import 'package:frontendmobile/features/onboarding/presentation/widgets/onboarding_field.dart';
import 'package:frontendmobile/shared/widgets/wizard_buttons.dart';

class Step2DepartmentScreen extends ConsumerStatefulWidget {
  const Step2DepartmentScreen({super.key});
  @override
  ConsumerState<Step2DepartmentScreen> createState() => _Step2DeptState();
}

class _Step2DeptState extends ConsumerState<Step2DepartmentScreen> {
  final _formKey  = GlobalKey<FormState>();
  final _deptName = TextEditingController();

  @override
  void dispose() {
    _deptName.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    await ref.read(wizardProvider.notifier).assignDepartment(
      departmentName: _deptName.text.trim(),
    );
  }





  @override
  Widget build(BuildContext context) {
    final state     = ref.watch(wizardProvider);
    final isLoading = state.isLoading;

    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            OnboardingField(
              controller: _deptName,
              label:      'Department Name',
              icon:       Icons.apartment_outlined,
              hint:       'e.g. Engineering, Sales',
              validator:  (v) => v == null || v.isEmpty ? 'Required' : null,
            ),
            if (state.error != null) ...[
              const SizedBox(height: 8),
              Text(
                state.error!,
                style: const TextStyle(color: Colors.redAccent, fontSize: 13),
              ),
            ],
            const SizedBox(height: 24),
            WizardButtons(
              isLoading: isLoading,
              onSkip:    () => ref.read(wizardProvider.notifier).nextStep(),
              onSubmit:  _submit,
            ),
          ],
        ),
      ),
    );
  }
}
