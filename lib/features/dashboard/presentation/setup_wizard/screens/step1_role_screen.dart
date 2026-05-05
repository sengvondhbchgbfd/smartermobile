import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontendmobile/features/dashboard/presentation/setup_wizard/providers/wizard_provider.dart';
import 'package:frontendmobile/features/onboarding/presentation/widgets/onboarding_field.dart';
import 'package:frontendmobile/shared/widgets/wizard_buttons.dart';

class Step1RoleScreen extends ConsumerStatefulWidget {
  const Step1RoleScreen({super.key});
  @override
  ConsumerState<Step1RoleScreen> createState() => _Step1RoleState();
}

class _Step1RoleState extends ConsumerState<Step1RoleScreen> {
  final _formKey  = GlobalKey<FormState>();
  final _roleName = TextEditingController();
  final _salary   = TextEditingController();
  bool _isManager = false;

  @override
  void dispose() {
    _roleName.dispose();
    _salary.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    await ref.read(wizardProvider.notifier).assignRole(
      roleName:   _roleName.text.trim(),
      isManager:  _isManager,
      baseSalary: double.tryParse(_salary.text.trim()) ?? 0,
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            OnboardingField(
              controller: _roleName,
              label:      'Role Name',
              icon:       Icons.badge_outlined,
              hint:       'e.g. Manager, Developer',
              validator:  (v) => v == null || v.isEmpty ? 'Required' : null,
            ),
            OnboardingField(
              controller:   _salary,
              label:        'Base Salary',
              icon:         Icons.attach_money,
              hint:         'e.g. 1500.00',
              keyboardType: TextInputType.number,
              validator:    (v) => v == null || v.isEmpty ? 'Required' : null,
            ),
            const SizedBox(height: 4),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              decoration: BoxDecoration(
                color:        const Color(0xFF0F172A),
                borderRadius: BorderRadius.circular(10),
                border:       Border.all(color: Colors.white12),
              ),
              child: SwitchListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text(
                  'Is Manager',
                  style: TextStyle(color: Colors.white70, fontSize: 14),
                ),
                subtitle: const Text(
                  'Can manage staff',
                  style: TextStyle(color: Colors.white38, fontSize: 12),
                ),
                value:       _isManager,
                activeColor: const Color(0xFF6366F1),
                onChanged:   (v) => setState(() => _isManager = v),
              ),
            ),
            if (state.error != null) ...[
              const SizedBox(height: 12),
              Text(
                state.error!,
                style: const TextStyle(color: Colors.redAccent, fontSize: 13),
              ),
            ],
            const SizedBox(height: 24),
            WizardButtons(
              isLoading: isLoading,
              onSkip:    () => ref.read(wizardProvider.notifier).skipStep(),
              onSubmit:  _submit,
            ),
          ],
        ),
      ),
    );
  }
}