import 'package:flutter/material.dart';
import 'package:frontendmobile/features/auth/presentation/widgets/register_form.dart';
class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: RegisterForm()));
  }
}
