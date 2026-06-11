import 'package:flutter/material.dart';
<<<<<<< HEAD
=======
import 'package:frontendmobile/core/themes/app_pallets.dart';
>>>>>>> 9f1638c8060e11abffb348266a42c22f5d24569c

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
<<<<<<< HEAD

=======
>>>>>>> 9f1638c8060e11abffb348266a42c22f5d24569c
  final _nameCtrl = TextEditingController();
  final _codeCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _maxCtrl = TextEditingController();
<<<<<<< HEAD
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
=======
  final _tzCtrl = TextEditingController();
  final _currCtrl = TextEditingController();
  bool _isLoading = false;
>>>>>>> 9f1638c8060e11abffb348266a42c22f5d24569c

  @override
  void dispose() {
    _nameCtrl.dispose();
    _codeCtrl.dispose();
    _emailCtrl.dispose();
    _maxCtrl.dispose();
<<<<<<< HEAD
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
=======
    _tzCtrl.dispose();
    _currCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);
    await widget.onSubmit(
      companyCode: _codeCtrl.text.trim(),
      companyName: _nameCtrl.text.trim(),
      currency: _currCtrl.text.trim(),
      email: _emailCtrl.text.trim(),
      maxUsers: int.parse(_maxCtrl.text.trim()),
      timezone: _tzCtrl.text.trim(),
    );
    if (mounted) setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
        20,
        16,
        20,
        MediaQuery.of(context).viewInsets.bottom + 20,
      ),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Handle ──────────────────────────────────────────────
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Pallets.borderDark,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // ── Title ───────────────────────────────────────────────
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Pallets.gradient2.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      Icons.business_outlined,
                      color: Pallets.gradient2,
                      size: 18,
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    'Register Company',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // ── Fields ───────────────────────────────────────────────
              _Field(
                controller: _nameCtrl,
                label: 'Company Name',
                icon: Icons.business_outlined,
                validator: (v) => v!.trim().isEmpty ? 'Required' : null,
              ),
              _Field(
                controller: _codeCtrl,
                label: 'Company Code',
                icon: Icons.tag_rounded,
                validator: (v) => v!.trim().isEmpty ? 'Required' : null,
              ),
              _Field(
                controller: _emailCtrl,
                label: 'Email',
                icon: Icons.email_outlined,
                keyboardType: TextInputType.emailAddress,
                validator: (v) => v!.trim().isEmpty ? 'Required' : null,
              ),
              _Field(
                controller: _maxCtrl,
                label: 'Max Users',
                icon: Icons.people_outline_rounded,
                keyboardType: TextInputType.number,
                validator: (v) {
                  if (v == null || v.trim().isEmpty) return 'Required';
                  if (int.tryParse(v.trim()) == null) return 'Must be a number';
                  return null;
                },
              ),
              _Field(
                controller: _tzCtrl,
                label: 'Timezone',
                icon: Icons.public_outlined,
                hint: 'e.g. Asia/Phnom_Penh',
                validator: (v) => v!.trim().isEmpty ? 'Required' : null,
              ),
              _Field(
                controller: _currCtrl,
                label: 'Currency',
                icon: Icons.attach_money_rounded,
                hint: 'e.g. USD, KHR',
                validator: (v) => v!.trim().isEmpty ? 'Required' : null,
              ),

              const SizedBox(height: 8),

              // ── Submit ───────────────────────────────────────────────
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _submit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Pallets.gradient2,
                    disabledBackgroundColor: Pallets.gradient2.withOpacity(0.5),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    elevation: 0,
                  ),
                  child: _isLoading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : const Text(
                          'Create Company',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                ),
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Field ─────────────────────────────────────────────────────────────────────

class _Field extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final IconData icon;
  final String? hint;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;

  const _Field({
    required this.controller,
    required this.label,
    required this.icon,
    this.hint,
    this.keyboardType,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        validator: validator,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          prefixIcon: Icon(icon, color: Pallets.textSecondaryDark, size: 20),
          labelStyle: TextStyle(color: Pallets.textSecondaryDark),
          hintStyle: TextStyle(
            color: Pallets.textSecondaryDark.withOpacity(0.5),
          ),
          filled: true,
          fillColor: Pallets.backgroundDark,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Pallets.borderDark),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Pallets.borderDark),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Pallets.gradient2, width: 1.5),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.redAccent),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.redAccent, width: 1.5),
          ),
        ),
>>>>>>> 9f1638c8060e11abffb348266a42c22f5d24569c
      ),
    );
  }
}
