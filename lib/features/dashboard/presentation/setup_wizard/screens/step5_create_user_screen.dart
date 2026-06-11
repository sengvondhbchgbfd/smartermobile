import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontendmobile/features/auth/presentation/providers/auth_provider.dart';
import 'package:frontendmobile/features/dashboard/presentation/setup_wizard/providers/wizard_provider.dart';
import 'package:frontendmobile/features/dashboard/presentation/setup_wizard/widgets/custom_text_field.dart';
import 'package:go_router/go_router.dart';

class Step5CreateUserScreen extends ConsumerStatefulWidget {
  const Step5CreateUserScreen({super.key});
  @override
  ConsumerState<Step5CreateUserScreen> createState() => _State();
}

class _State extends ConsumerState<Step5CreateUserScreen> {
  final _formKey = GlobalKey<FormState>();
  final _username = TextEditingController();
  final _fullName = TextEditingController();
  final _password = TextEditingController();
  bool _obscure = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.listenManual<AsyncValue<void>>(registerUserProvider, (prev, next) {
        next.whenOrNull(
          data: (_) {
            ref.read(wizardProvider.notifier).markComplete();
            context.go('/login');
          },
          error: (e, _) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(e.toString())));
          },
        );
      });
    });
  }

  @override
  void dispose() {
    _username.dispose();
    _fullName.dispose();
    _password.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    final ws = ref.read(wizardProvider);

    // ✅ FIX 2: Guard against null roleId / departmentId before using !
    if (ws.roleId == null || ws.departmentId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Role or Department not selected. Please go back and complete previous steps.',
          ),
        ),
      );
      return;
    }

    await ref
        .read(registerUserProvider.notifier)
        .registerUser(
          username: _username.text.trim(),
          password: _password.text,
          fullName: _fullName.text.trim(),
          roleId: ws.roleId!,
          departmentId: ws.departmentId!,
        );
  }

  @override
  Widget build(BuildContext context) {
    final ctrl = ref.watch(registerUserProvider);
    final ws = ref.watch(wizardProvider);

    return Form(
      key: _formKey,
      child: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          const CircleAvatar(
            radius: 32,
            child: Icon(Icons.manage_accounts, size: 32),
          ),
          const SizedBox(height: 12),
          const Text(
            'Identify Yourself',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          const Text(
            'Create your superuser account to manage this system',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey, fontSize: 13),
          ),
          const SizedBox(height: 24),
          CustomTextField(
            controller: _username,
            label: 'Username',
            hint: 'e.g. admin_john',
            validator: (v) => (v?.isEmpty ?? true) ? 'Required' : null,
          ),
          const SizedBox(height: 16),
          // ✅ FIX 3: fullName field was missing from the form UI
          CustomTextField(
            controller: _fullName,
            label: 'Full Name',
            hint: 'e.g. John Smith',
            validator: (v) => (v?.isEmpty ?? true) ? 'Required' : null,
          ),
          const SizedBox(height: 16),
          CustomTextField(
            controller: _password,
            label: 'Password',
            obscureText: _obscure,
            suffixIcon: IconButton(
              icon: Icon(_obscure ? Icons.visibility_off : Icons.visibility),
              onPressed: () => setState(() => _obscure = !_obscure),
            ),
            validator: (v) {
              if (v == null || v.isEmpty) return 'Required';
              if (v.length < 8) return 'Minimum 8 characters';
              return null;
            },
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _Chip(
                  label: 'Role',
                  value: ws.roleId?.toString() ?? '—',
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _Chip(
                  label: 'Department',
                  value: ws.departmentId?.toString() ?? '—',
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.blue.shade50,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.blue.shade200),
            ),
            child: const Row(
              children: [
                Icon(Icons.info_outline, color: Colors.blue, size: 18),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'This account has full system access (superuser).',
                    style: TextStyle(fontSize: 13),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              onPressed: ctrl.isLoading ? null : _submit,
              child: ctrl.isLoading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text('Create Account & Finish Setup'),
            ),
          ),
          if (ctrl.hasError)
            Padding(
              padding: const EdgeInsets.only(top: 12),
              child: Text(
                ctrl.error.toString(),
                style: const TextStyle(color: Colors.red),
                textAlign: TextAlign.center,
              ),
            ),
        ],
      ),
    );
  }
}

class _Chip extends StatelessWidget {
  final String label, value;
  const _Chip({required this.label, required this.value});

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
    decoration: BoxDecoration(
<<<<<<< HEAD
      color: Theme.of(context).colorScheme.surfaceContainerHighest,
=======
      color: Theme.of(context).colorScheme.surfaceVariant,
>>>>>>> 9f1638c8060e11abffb348266a42c22f5d24569c
      borderRadius: BorderRadius.circular(8),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 11, color: Colors.grey)),
        const SizedBox(height: 2),
        Text(value, style: const TextStyle(fontWeight: FontWeight.w600)),
      ],
    ),
  );
}
