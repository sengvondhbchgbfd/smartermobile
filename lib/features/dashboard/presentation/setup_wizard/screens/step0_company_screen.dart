import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontendmobile/core/themes/app_pallets.dart';
import 'package:frontendmobile/features/dashboard/presentation/setup_wizard/providers/wizard_provider.dart';
import 'package:frontendmobile/features/dashboard/presentation/setup_wizard/widgets/custom_dropdown.dart';
import 'package:frontendmobile/features/dashboard/presentation/setup_wizard/widgets/custom_text_field.dart';
import 'package:frontendmobile/shared/widgets/wizard_buttons.dart';

class Step0CompanyScreen extends ConsumerStatefulWidget {
  const Step0CompanyScreen({super.key});

  @override
  ConsumerState<Step0CompanyScreen> createState() => _Step0CompanyScreenState();
}

class _Step0CompanyScreenState extends ConsumerState<Step0CompanyScreen> {
  /////////////////////////////////////////////////////////////////////
  ///
  /////////////////////////////////////////////////////////////////////

  final _formKey = GlobalKey<FormState>();
  final _companyNameCtrl = TextEditingController();
  final _companyCodeCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _maxUsersCtrl = TextEditingController();

  final String _planType = 'free';
  String? _selectedCurrency;
  String? _selectedTimezone;

  static const List<String> _currencies = ['USD', 'KHR', 'THB', 'VND', 'SGD'];
  static const List<String> _timezones = [
    'Asia/Phnom_Penh',
    'Asia/Bangkok',
    'Asia/Ho_Chi_Minh',
    'Asia/Singapore',
  ];
  /////////////////////////////////////////////////////////////////////
  ///
  /////////////////////////////////////////////////////////////////////

  @override
  void dispose() {
    _companyNameCtrl.dispose();
    _companyCodeCtrl.dispose();
    _emailCtrl.dispose();
    _maxUsersCtrl.dispose();
    super.dispose();
  }

  /////////////////////////////////////////////////////////////////////
  ///
  /////////////////////////////////////////////////////////////////////

  Future<void> _submit() async {
    FocusScope.of(context).unfocus();
    if (!_formKey.currentState!.validate()) return;

    final success = await ref
        .read(wizardProvider.notifier)
        .registerCompany(
          companyCode: _companyCodeCtrl.text.trim(),
          companyName: _companyNameCtrl.text.trim(),
          currency: _selectedCurrency!,
          email: _emailCtrl.text.trim(),
          maxUsers: int.parse(_maxUsersCtrl.text.trim()),
          timezone: _selectedTimezone!,
          planType: _planType,
        );
    if (!mounted) return;
    if (success) {}
  }

  /////////////////////////////////////////////////////////////////////
  ///
  /////////////////////////////////////////////////////////////////////

  @override
  Widget build(BuildContext context) {
    final wizardState = ref.watch(wizardProvider);
    final isLoading = wizardState.isLoading;
    final error = wizardState.error;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    if (error != null) ...[
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Pallets.error.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: Pallets.error.withOpacity(0.4),
                          ),
                        ),
                        child: Text(
                          error,
                          style: const TextStyle(
                            color: Pallets.error,
                            fontSize: 13,
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                    ],

                    ///////////////////////////////////////////////////////////
                    ///
                    ///////////////////////////////////////////////////////////
                    CustomTextField(
                      controller: _companyNameCtrl,
                      label: 'Company Name',
                      prefixIcon: Icons.apartment,
                    ),
                    const SizedBox(height: 12),

                    ///////////////////////////////////////////////////////////
                    ///
                    ///////////////////////////////////////////////////////////
                    CustomTextField(
                      controller: _companyCodeCtrl,
                      label: 'Company code',
                      validator: (v) => v!.isEmpty ? 'Required' : null,
                    ),
                    const SizedBox(height: 12),

                    ///////////////////////////////////////////////////////////
                    ///
                    ///////////////////////////////////////////////////////////
                    CustomTextField(
                      controller: _emailCtrl,
                      label: 'Email',
                      keyboardType: TextInputType.emailAddress,
                      validator: (v) => v!.isEmpty ? 'Required' : null,
                    ),
                    const SizedBox(height: 12),

                    ///////////////////////////////////////////////////////////
                    ///
                    ///////////////////////////////////////////////////////////
                    CustomTextField(
                      controller: _maxUsersCtrl,
                      label: "maxUsers",
                      keyboardType: TextInputType.number,
                      validator: (v) => v!.isEmpty ? 'Required' : null,
                    ),
                    const SizedBox(height: 12),

                    ///////////////////////////////////////////////////////////
                    ///
                    ///////////////////////////////////////////////////////////
                    CustomDropdown<String>(
                      label: 'Currency',
                      prefixIcon: Icons.attach_money,
                      value: _selectedCurrency,
                      items: _currencies
                          .map(
                            (c) => DropdownMenuItem(value: c, child: Text(c)),
                          )
                          .toList(),
                      onChanged: (v) => setState(() => _selectedCurrency = v),
                      validator: (v) => v == null ? 'Select currency' : null,
                    ),

                    const SizedBox(height: 12),

                    ///////////////////////////////////////////////////////////
                    ///
                    ///////////////////////////////////////////////////////////
                    CustomDropdown<String>(
                      label: 'Timezone',
                      prefixIcon: Icons.schedule_outlined,
                      value: _selectedTimezone,
                      items: _timezones
                          .map(
                            (t) => DropdownMenuItem(value: t, child: Text(t)),
                          )
                          .toList(),
                      onChanged: (v) => setState(() => _selectedTimezone = v),
                      validator: (v) => v == null ? 'Select timezone' : null,
                    ),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(24),
            child: WizardButtons(
              isLoading: isLoading,
              onSkip: () => ref.read(wizardProvider.notifier).nextStep(),
              onSubmit: _submit,
            ),
          ),
        ],
      ),
    );
  }
}
