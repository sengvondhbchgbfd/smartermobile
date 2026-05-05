import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontendmobile/features/onboarding/presentation/providers/onboarding_provider.dart';
import 'package:frontendmobile/features/onboarding/presentation/widgets/onboarding_field.dart';

class Step0CompanyScreen extends ConsumerStatefulWidget {
  const Step0CompanyScreen({super.key});
  @override
  ConsumerState<Step0CompanyScreen> createState() => _Step1Sate();
}

//////////////////////////////////////////////////////////////////////
//
//////////////////////////////////////////////////////////////////////
class _Step1Sate extends ConsumerState<Step0CompanyScreen> {
  final _formKey = GlobalKey<FormState>();
  final _companyName = TextEditingController();
  final _companyCode = TextEditingController();
  final _username = TextEditingController();
  final _password = TextEditingController();
  final _fullName = TextEditingController();
  final _timezone = TextEditingController(text: 'Asia/Phnom_Penh');
  final _currency = TextEditingController(text: 'USD');

  @override
  void dispose() {
    _companyName.dispose();
    _companyCode.dispose();
    _username.dispose();
    _password.dispose();
    _fullName.dispose();
    _timezone.dispose();
    _currency.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    await ref
        .read(onboardingProvider.notifier)
        .registerCompanyAndAdmin(
          companyName: _companyName.text.trim(),
          companyCode: _companyCode.text.trim().toUpperCase(),
          username: _username.text.trim(),
          password: _password.text.trim(),
          fullName: _fullName.text.trim(),
          timezone: _timezone.text.trim(),
          currency: _currency.text.trim(),
        );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(onboardingProvider);
    final isLoading = state.isLoading;

    //////////////////////////////////////////////////////
    //
    //////////////////////////////////////////////////////
    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '🏢 Company Info',
              style: TextStyle(
                color: Colors.white54,
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),

            /////////////////////////////////////////
            const SizedBox(height: 12),

            ////////////////////////////////////////
            OnboardingField(
              controller: _companyName,
              label: 'Company Name',
              icon: Icons.business_outlined,
              validator: (v) => v == null || v.isEmpty ? 'Required' : null,
            ),

            OnboardingField(
              controller: _companyCode,
              label: 'Company Code',
              icon: Icons.qr_code_outlined,
              hint: 'e.g. MYCO',
              validator: (v) => v == null || v.isEmpty ? 'Required' : null,
            ),
            OnboardingField(
              controller: _timezone,
              label: 'Timezone',
              icon: Icons.public_outlined,
              hint: 'e.g. Asia/Phnom_Penh',
              validator: (v) => v == null || v.isEmpty ? 'Required' : null,
            ),
            OnboardingField(
              controller: _currency,
              label: 'Currency',
              icon: Icons.attach_money,
              hint: 'e.g. USD, KHR',
              validator: (v) => v == null || v.isEmpty ? 'Required' : null,
            ),
            const SizedBox(height: 8),
            const Text(
              '👤 Admin Account',
              style: TextStyle(
                color: Colors.white54,
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
            //////////////////////////////////////////////////////
            const SizedBox(height: 12),
            //////////////////////////////////////////////////////
            OnboardingField(
              controller: _fullName,
              label: 'Full Name',
              icon: Icons.person_outlined,
              validator: (v) => v == null || v.isEmpty ? 'Required' : null,
            ),
            OnboardingField(
              controller: _username,
              label: 'Username',
              icon: Icons.alternate_email,
              validator: (v) => v == null || v.isEmpty ? 'Required' : null,
            ),
            OnboardingField(
              controller: _password,
              label: 'Password',
              icon: Icons.lock_outline,
              obscure: true,
              validator: (v) =>
                  v == null || v.length < 6 ? 'Min 6 characters' : null,
            ),

            if (state.error != null) ...[
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.redAccent.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.redAccent.withOpacity(0.3)),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.error_outline,
                      color: Colors.redAccent,
                      size: 16,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        state.error!,
                        style: const TextStyle(
                          color: Colors.redAccent,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],

            //////////////////////////////////////////////////////
            const SizedBox(height: 24),
            //////////////////////////////////////////////////////
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: isLoading ? null : _submit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF6366F1),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: isLoading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : const Text(
                        'Continue',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
