import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
<<<<<<< HEAD
=======
import 'package:frontendmobile/core/themes/app_pallets.dart';
>>>>>>> 9f1638c8060e11abffb348266a42c22f5d24569c
import '../../domain/entities/company_entity.dart';
import '../../domain/usecases/update_company_usecase.dart';
import '../providers/company_provider.dart';

class CompanyEditForm extends ConsumerStatefulWidget {
  final CompanyEntity company;
  final int companyId;

  const CompanyEditForm({
    super.key,
    required this.company,
    required this.companyId,
  });

  @override
  ConsumerState<CompanyEditForm> createState() => _CompanyEditFormState();
}

<<<<<<< HEAD
//////////////////////////////////////////////////////////////////////////////
//
//////////////////////////////////////////////////////////////////////////////

=======
>>>>>>> 9f1638c8060e11abffb348266a42c22f5d24569c
class _CompanyEditFormState extends ConsumerState<CompanyEditForm> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameCtrl;
  late final TextEditingController _emailCtrl;
  late final TextEditingController _phoneCtrl;
  late final TextEditingController _addressCtrl;
  late final TextEditingController _timezoneCtrl;
  late final TextEditingController _currencyCtrl;

  @override
  void initState() {
    super.initState();
    _nameCtrl = TextEditingController(text: widget.company.companyName);
    _emailCtrl = TextEditingController(text: widget.company.email ?? '');
    _phoneCtrl = TextEditingController(text: widget.company.phone ?? '');
    _addressCtrl = TextEditingController(text: widget.company.address ?? '');
    _timezoneCtrl = TextEditingController(text: widget.company.timezone ?? '');
    _currencyCtrl = TextEditingController(text: widget.company.currency ?? '');
  }
<<<<<<< HEAD

=======
>>>>>>> 9f1638c8060e11abffb348266a42c22f5d24569c
  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _phoneCtrl.dispose();
    _addressCtrl.dispose();
    _timezoneCtrl.dispose();
    _currencyCtrl.dispose();
    super.dispose();
  }

<<<<<<< HEAD
  //////////////////////////////////////////////////////////////////////////////
  //
  //////////////////////////////////////////////////////////////////////////////

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

=======
  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
>>>>>>> 9f1638c8060e11abffb348266a42c22f5d24569c
    final success = await ref
        .read(companyProvider.notifier)
        .updateCompany(
          UpdateCompanyParams(
            companyId: widget.companyId,
            companyName: _nameCtrl.text.trim(),
            email: _emailCtrl.text.trim(),
            phone: _phoneCtrl.text.trim(),
<<<<<<< HEAD
            address: _addressCtrl.text.trim(), // ✅ fix 3
=======
            address: _addressCtrl.text.trim(),
>>>>>>> 9f1638c8060e11abffb348266a42c22f5d24569c
            timezone: _timezoneCtrl.text.trim(),
            currency: _currencyCtrl.text.trim(),
          ),
        );
<<<<<<< HEAD

    if (!mounted) return;

    if (success) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Company updated successfully'),
          backgroundColor: Colors.green,
=======
    if (!mounted) return;
    if (success) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Company updated successfully'),
          backgroundColor: Colors.green.shade700,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
>>>>>>> 9f1638c8060e11abffb348266a42c22f5d24569c
        ),
      );
    } else {
      final error =
          ref.read(companyProvider).valueOrNull?.error ?? 'Update failed';
      ScaffoldMessenger.of(context).showSnackBar(
<<<<<<< HEAD
        SnackBar(content: Text(error), backgroundColor: Colors.redAccent),
=======
        SnackBar(
          content: Text(error),
          backgroundColor: Colors.redAccent,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
>>>>>>> 9f1638c8060e11abffb348266a42c22f5d24569c
      );
    }
  }

<<<<<<< HEAD
  //////////////////////////////////////////////////////////////////////////////
  //
  //////////////////////////////////////////////////////////////////////////////

  @override
  Widget build(BuildContext context) {
    final companyState = ref.watch(companyProvider);
    final isUpdating = companyState.valueOrNull?.isUpdating ?? false;
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return Padding(
      padding: EdgeInsets.fromLTRB(20, 20, 20, 20 + bottomInset),
=======
  @override
  Widget build(BuildContext context) {
    final isUpdating =
        ref.watch(companyProvider).valueOrNull?.isUpdating ?? false;

    return Padding(
      padding: EdgeInsets.fromLTRB(
        20,
        16,
        20,
        MediaQuery.of(context).viewInsets.bottom + 20,
      ),
>>>>>>> 9f1638c8060e11abffb348266a42c22f5d24569c
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
<<<<<<< HEAD
              // Handle
=======
              // ── Handle ──────────────────────────────────────────────
>>>>>>> 9f1638c8060e11abffb348266a42c22f5d24569c
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
<<<<<<< HEAD
                    color: Colors.white24,
=======
                    color: Pallets.borderDark,
>>>>>>> 9f1638c8060e11abffb348266a42c22f5d24569c
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 20),
<<<<<<< HEAD
              const Text(
                'Edit Company',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 20),
=======

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
                      Icons.edit_outlined,
                      color: Pallets.gradient2,
                      size: 18,
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    'Edit Company',
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
>>>>>>> 9f1638c8060e11abffb348266a42c22f5d24569c
              _AppField(
                controller: _nameCtrl,
                label: 'Company Name',
                icon: Icons.business_outlined,
                validator: (v) => v == null || v.isEmpty ? 'Required' : null,
              ),
              _AppField(
                controller: _emailCtrl,
                label: 'Email',
                icon: Icons.email_outlined,
                keyboardType: TextInputType.emailAddress,
              ),
              _AppField(
                controller: _phoneCtrl,
                label: 'Phone',
                icon: Icons.phone_outlined,
                keyboardType: TextInputType.phone,
              ),
              _AppField(
<<<<<<< HEAD
                // ✅ fix 4
=======
>>>>>>> 9f1638c8060e11abffb348266a42c22f5d24569c
                controller: _addressCtrl,
                label: 'Address',
                icon: Icons.location_on_outlined,
              ),
              _AppField(
                controller: _timezoneCtrl,
                label: 'Timezone',
                icon: Icons.public_outlined,
                hint: 'e.g. Asia/Phnom_Penh',
              ),
              _AppField(
                controller: _currencyCtrl,
                label: 'Currency',
<<<<<<< HEAD
                icon: Icons.attach_money,
                hint: 'e.g. USD, KHR',
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: isUpdating ? null : _submit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF6366F1),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
=======
                icon: Icons.attach_money_rounded,
                hint: 'e.g. USD, KHR',
              ),

              const SizedBox(height: 8),

              // ── Submit ───────────────────────────────────────────────
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: isUpdating ? null : _submit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Pallets.gradient2,
                    disabledBackgroundColor: Pallets.gradient2.withOpacity(0.5),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    elevation: 0,
>>>>>>> 9f1638c8060e11abffb348266a42c22f5d24569c
                  ),
                  child: isUpdating
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : const Text(
                          'Save Changes',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                ),
              ),
<<<<<<< HEAD
=======
              const SizedBox(height: 8),
>>>>>>> 9f1638c8060e11abffb348266a42c22f5d24569c
            ],
          ),
        ),
      ),
    );
  }
}

<<<<<<< HEAD
//////////////////////////////////////////////////////////////////////////////
//
//////////////////////////////////////////////////////////////////////////////
=======
// ── Field ─────────────────────────────────────────────────────────────────────
>>>>>>> 9f1638c8060e11abffb348266a42c22f5d24569c

class _AppField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final IconData icon;
  final String? hint;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;

  const _AppField({
    required this.controller,
    required this.label,
    required this.icon,
    this.hint,
    this.keyboardType,
    this.validator,
  });

<<<<<<< HEAD
  //////////////////////////////////////////////////////////////////////////////
  //
  //////////////////////////////////////////////////////////////////////////////

=======
>>>>>>> 9f1638c8060e11abffb348266a42c22f5d24569c
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
<<<<<<< HEAD
          prefixIcon: Icon(icon, color: Colors.white38, size: 20),
          labelStyle: const TextStyle(color: Colors.white38),
          hintStyle: const TextStyle(color: Colors.white24),
          filled: true,
          fillColor: const Color(0xFF0F172A),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Colors.white12),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Colors.white12),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Color(0xFF6366F1)),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Colors.redAccent),
          ),
=======
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
>>>>>>> 9f1638c8060e11abffb348266a42c22f5d24569c
        ),
      ),
    );
  }
}
