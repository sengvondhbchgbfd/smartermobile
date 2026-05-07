import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:frontendmobile/features/auth/presentation/providers/auth_provider.dart';
import 'package:frontendmobile/shared/widgets/custom_button.dart';
import 'package:frontendmobile/shared/widgets/custom_textfield.dart';
const _timezones = ['Asia/Phnom_Penh', 'Asia/Bangkok', 'Asia/Singapore', 'UTC'];
const _currencies = ['USD', 'KHR', 'THB', 'SGD'];

class RegisterForm extends ConsumerStatefulWidget {
  const RegisterForm({super.key});

  @override
  ConsumerState<RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends ConsumerState<RegisterForm> {
  // ====================================================|
  // main data set
  //=====================================================|
  final _formKey = GlobalKey<FormState>();
  final _companyName = TextEditingController();
  final _companyCode = TextEditingController();
  final _fullName = TextEditingController();
  final _username = TextEditingController();
  final _password = TextEditingController();
  String _timezone = _timezones.first;
  String _currency = _currencies.first;
  bool _obscure = true;

  @override
  void dispose() {
    _companyName.dispose();
    _companyCode.dispose();
    _fullName.dispose();
    _username.dispose();
    _password.dispose();
    super.dispose();
  }

  //==========================================================
  //  event
  //==========================================================

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    if (!_formKey.currentState!.validate()) return;

    await ref
        .read(registerProvider.notifier)
        .register(
          companyName: _companyName.text.trim(),
          companyCode: _companyCode.text.trim(),
          username: _username.text.trim(),
          password: _password.text,
          fullName: _fullName.text.trim(),
          timezone: _timezone,
          currency: _currency,
        );

    if (!mounted) return;
    ref
        .read(registerProvider)
        .whenOrNull(
          data: (_) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Company registered successfully!'),
                backgroundColor: Colors.green,
              ),
            );
            context.go('/login');
          },
          error: (e, _) => ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(e.toString()), backgroundColor: Colors.red),
          ),
        );
  }

  //==========================================================
  //
  //==========================================================

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(registerProvider) is AsyncLoading;
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 24),
                Text(
                  'Create account',
                  style: theme.textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Set up your company workspace',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: Colors.grey,
                  ),
                ),
                ////////////////////////////////////////////////////////////
                const SizedBox(height: 32),

                ////////////////////////////////////////////////////////////
                _SectionLabel('Company information'),
                const SizedBox(height: 12),
                CustomTextField(
                  controller: _companyName,
                  label: 'Company name',
                  hint: 'Acme Corp',
                  prefixIcon: Icons.business_outlined,
                  validator: (v) =>
                      v!.isEmpty ? 'Company name is required' : null,
                ),

                ////////////////////////////////////////////////////////////
                const SizedBox(height: 12),

                ////////////////////////////////////////////////////////////
                CustomTextField(
                  controller: _companyCode,
                  label: 'Company code',
                  hint: 'ACME',
                  prefixIcon: Icons.tag_outlined,
                  validator: (v) =>
                      v!.isEmpty ? 'Company code is required' : null,
                ),

                ////////////////////////////////////////////////////////////
                const SizedBox(height: 24),

                ////////////////////////////////////////////////////////////
                _SectionLabel('Admin account'),
                const SizedBox(height: 12),
                CustomTextField(
                  controller: _fullName,
                  label: 'Full name',
                  hint: 'System Admin',
                  prefixIcon: Icons.person_outlined,
                  validator: (v) => v!.isEmpty ? 'Full name is required' : null,
                ),

                ////////////////////////////////////////////////////////////
                const SizedBox(height: 12),

                ////////////////////////////////////////////////////////////
                CustomTextField(
                  controller: _username,
                  label: 'Username',
                  hint: 'admin',
                  prefixIcon: Icons.alternate_email_outlined,
                  validator: (v) => v!.isEmpty ? 'Username is required' : null,
                ),

                ////////////////////////////////////////////////////////////
                const SizedBox(height: 12),
                ////////////////////////////////////////////////////////////
                CustomTextField(
                  controller: _password,
                  label: 'Password',
                  hint: '••••••••',
                  prefixIcon: Icons.lock_outlined,
                  obscureText: _obscure,
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscure
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                    ),
                    onPressed: () => setState(() => _obscure = !_obscure),
                  ),
                  validator: (v) {
                    if (v!.isEmpty) return 'Password is required';
                    if (v.length < 8) return 'Minimum 8 characters';
                    return null;
                  },
                ),

                ////////////////////////////////////////////////////////////
                const SizedBox(height: 24),

                ////////////////////////////////////////////////////////////
                _SectionLabel('Settings'),
                const SizedBox(height: 12),
                _DropdownField(
                  label: 'Timezone',
                  value: _timezone,
                  items: _timezones,
                  icon: Icons.schedule_outlined,
                  onChanged: (v) => setState(() => _timezone = v!),
                ),
                const SizedBox(height: 12),
                _DropdownField(
                  label: 'Currency',
                  value: _currency,
                  items: _currencies,
                  icon: Icons.attach_money_outlined,
                  onChanged: (v) => setState(() => _currency = v!),
                ),

                ////////////////////////////////////////////////////////////
                const SizedBox(height: 32),

                ////////////////////////////////////////////////////////////
                CustomButton(
                  label: 'Create account',
                  isLoading: isLoading,
                  onPressed: isLoading ? null : _submit,
                ),
                ////////////////////////////////////////////////////////////
                const SizedBox(height: 16),

                ////////////////////////////////////////////////////////////
                Center(
                  child: TextButton(
                    onPressed: () => context.go('/login'),
                    child: const Text('Already have an account? Sign in'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  final String label;
  const _SectionLabel(this.label);

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: Theme.of(context).textTheme.titleSmall?.copyWith(
        fontWeight: FontWeight.w600,
        color: Theme.of(context).colorScheme.primary,
      ),
    );
  }
}

class _DropdownField extends StatelessWidget {
  final String label;
  final String value;
  final List<String> items;
  final IconData icon;
  final void Function(String?) onChanged;

  const _DropdownField({
    required this.label,
    required this.value,
    required this.items,
    required this.icon,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      value: value,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
      items: items
          .map((e) => DropdownMenuItem(value: e, child: Text(e)))
          .toList(),
      onChanged: onChanged,
    );
  }
}
