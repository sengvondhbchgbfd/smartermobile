import 'package:flutter/material.dart';
import 'package:frontendmobile/features/hr/salaries/domain/entities/salaries_entity.dart';
import 'package:frontendmobile/features/hr/salaries/presentation/widgets/salary_form.dart';

class SalaryEditScreen extends StatelessWidget {
  final SalaryEntity salary;

  const SalaryEditScreen({super.key, required this.salary});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Salary')),
      body: SingleChildScrollView(
        child: SalaryForm(existing: salary),
      ),
    );
  }
}