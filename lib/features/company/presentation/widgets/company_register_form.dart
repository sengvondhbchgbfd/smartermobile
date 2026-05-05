import 'package:flutter/material.dart';
class CompanyRegisterForm extends StatefulWidget {
  final Function({
    required String companyName,
    required String companyCode,
    String? email,
    String? phone,
    int? maxUsers,
    String? timezone,
    String? currency,
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
  final _phoneCtrl = TextEditingController();
  final _maxCtrl = TextEditingController();
  final _timezoneCtrl = TextEditingController();
  final _currencyCtrl = TextEditingController();

  void _submit() {
    if (_formKey.currentState!.validate()) {
      widget.onSubmit(
        companyName: _nameCtrl.text,
        companyCode: _codeCtrl.text,
        email: _emailCtrl.text,
        phone: _phoneCtrl.text,
        maxUsers: int.tryParse(_maxCtrl.text.trim()),
        timezone: _timezoneCtrl.text,
        currency: _currencyCtrl.text,
      );
    }
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _codeCtrl.dispose();
    _emailCtrl.dispose();
    _phoneCtrl.dispose();
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
        children: [
          TextFormField(
            controller: _nameCtrl,
            decoration: const InputDecoration(labelText: "Company Name"),
            validator: (value) => value!.isEmpty ? "Enter company name" : null,
          ),

          TextFormField(
            controller: _codeCtrl,
            decoration: const InputDecoration(labelText: "Company Code"),
            validator: (value) => value!.isEmpty ? "Enter company code" : null,
          ),

          TextFormField(
            controller: _emailCtrl,
            decoration: const InputDecoration(labelText: "Email"),
          ),

          TextFormField(
            controller: _phoneCtrl,
            decoration: const InputDecoration(labelText: "Phone"),
          ),
          TextFormField(
            controller: _maxCtrl,
            decoration: const InputDecoration(labelText: "MaxUsers"),
          ),

          TextFormField(
            controller: _timezoneCtrl,
            decoration: const InputDecoration(labelText: "Timezone"),
          ),
          TextFormField(
            controller: _currencyCtrl,
            decoration: const InputDecoration(labelText: "Currency"),
          ),

          const SizedBox(height: 20),

          ElevatedButton(
            onPressed: _submit,
            child: const Text("Create Company"),
          ),
        ],
      ),
    );
  }
}
