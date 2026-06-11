import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:frontendmobile/shared/widgets/custom_button.dart';
import 'package:frontendmobile/shared/widgets/custom_textfield.dart';
import '../providers/auth_provider.dart';

class LoginForm extends ConsumerStatefulWidget {
  const LoginForm({super.key});
  @override
  ConsumerState<LoginForm> createState() => _LoginFormState();
}

////////////////////////////////////////////////////////////
//
///////////////////////////////////////////////////////////

class _LoginFormState extends ConsumerState<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  final _username = TextEditingController();
  final _password = TextEditingController();
  bool _obscure = true;

  ////////////////////////////////////////////////////////////
  //
  ///////////////////////////////////////////////////////////

  @override
  void dispose() {
    _username.dispose();
    _password.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    ref
        .read(authProvider.notifier)
        .login(_username.text.trim(), _password.text);
  }

  ////////////////////////////////////////////////////////////
  //
  ///////////////////////////////////////////////////////////

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(authProvider) is AsyncLoading;

    /////////////////////////////////////////////////////////
    /// USERS
    //////////////////////////////////////////////////////////
    ref.listen<AsyncValue>(authProvider, (prev, next) {
      next.whenOrNull(
        data: (_) => context.go('/dashboard'),
        error: (e, _) => ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString()), backgroundColor: Colors.red),
        ),
      );
    });
    ////////////////////////////////////////////////////////////
    //
    ///////////////////////////////////////////////////////////

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ///////////////////////////////////////////////////////
            //
            ///////////////////////////////////////////////////////
            CustomTextField(
              controller: _username,
              label: 'Username',
              hint: 'admin',
              prefixIcon: Icons.alternate_email_outlined,
              validator: (v) => v!.isEmpty ? 'Username is required' : null,
            ),

            ///////////////////////////////////////////////////////
            const SizedBox(height: 12),

            ///////////////////////////////////////////////////////
            CustomTextField(
              controller: _password,
              label: 'Password',
              hint: '',
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
              validator: (v) => v!.isEmpty ? 'Password is required' : null,
            ),

            ///////////////////////////////////////////////////////
            const SizedBox(height: 24),

            ///////////////////////////////////////////////////////
            CustomButton(
              label: 'Sign in',
              isLoading: isLoading,
              onPressed: isLoading ? null : _submit,
            ),

            ///////////////////////////////////////////////////////
            const SizedBox(height: 12),
            ///////////////////////////////////////////////////////
            TextButton(
              onPressed: () => context.go('/register'),
              child: const Text("Don't have an account? Register"),
            ),
          ],
        ),
      ),
    );
  }
}
