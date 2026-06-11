import 'package:flutter/material.dart';
import 'package:frontendmobile/features/hr/salaries/presentation/widgets/salary_form.dart';

class SalaryCreateScreen extends StatelessWidget {
  const SalaryCreateScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('New Salary')),
      body: const SingleChildScrollView(child: SalaryForm()),
    );
  }
}
