import 'package:flutter/material.dart';

class CompanyRegisterForm extends StatefulWidget {
  final Function({
    required String companyCode,
    required String companyName,
    required String currency,
    required String email,
    required int maxUsers,
    required String timezone,
    String planType,
  })
  onSubmit;

  const CompanyRegisterForm({super.key, required this.onSubmit});

  @override
  State<CompanyRegisterForm> createState() => _CompanyRegisterFormState();
}

class _CompanyRegisterFormState extends State<CompanyRegisterForm> {
  final _formKey = GlobalKey<FormState>();

  final _nameCtrl = TextEditingController();
  final _codeCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _maxCtrl = TextEditingController();
  final _timezoneCtrl = TextEditingController();
  final _currencyCtrl = TextEditingController();

  void _submit() {
    if (_formKey.currentState!.validate()) {
      widget.onSubmit(
        companyCode: _codeCtrl.text.trim(),
        companyName: _nameCtrl.text.trim(),
        currency: _currencyCtrl.text.trim(),
        email: _emailCtrl.text.trim(),
        maxUsers: int.parse(_maxCtrl.text.trim()),
        timezone: _timezoneCtrl.text.trim(),
      );
    }
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _codeCtrl.dispose();
    _emailCtrl.dispose();
    _maxCtrl.dispose();
    _timezoneCtrl.dispose();
    _currencyCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextFormField(
            controller: _nameCtrl,
            decoration: const InputDecoration(labelText: 'Company Name'),
            validator: (v) =>
                (v == null || v.trim().isEmpty) ? 'Enter company name' : null,
          ),
          TextFormField(
            controller: _codeCtrl,
            decoration: const InputDecoration(labelText: 'Company Code'),
            validator: (v) =>
                (v == null || v.trim().isEmpty) ? 'Enter company code' : null,
          ),
          TextFormField(
            controller: _emailCtrl,
            decoration: const InputDecoration(labelText: 'Email'),
            keyboardType: TextInputType.emailAddress,
            validator: (v) =>
                (v == null || v.trim().isEmpty) ? 'Enter email' : null,
          ),
          TextFormField(
            controller: _maxCtrl,
            decoration: const InputDecoration(labelText: 'Max Users'),
            keyboardType: TextInputType.number,
            validator: (v) {
              if (v == null || v.trim().isEmpty) return 'Enter max users';
              if (int.tryParse(v.trim()) == null) return 'Must be a number';
              return null;
            },
          ),
          TextFormField(
            controller: _timezoneCtrl,
            decoration: const InputDecoration(labelText: 'Timezone'),
            validator: (v) =>
                (v == null || v.trim().isEmpty) ? 'Enter timezone' : null,
          ),
          TextFormField(
            controller: _currencyCtrl,
            decoration: const InputDecoration(labelText: 'Currency'),
            validator: (v) =>
                (v == null || v.trim().isEmpty) ? 'Enter currency' : null,
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: _submit,
            child: const Text('Create Company'),
          ),
          const SizedBox(height: 12),
        ],
      ),
    );
  }
}
