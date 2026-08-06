import 'package:flutter/material.dart';
import 'package:frontendmobile/core/themes/app_pallets.dart';

class CompanyRegisterForm extends StatefulWidget {
  final Function({
    required String companyCode,
    required String companyName,
    required String currency,
    required String email,
    required int maxUsers,
    required String timezone,
    required String adminUsername,
    required String adminPassword,
    required String adminFullName,
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
  final _tzCtrl = TextEditingController();
  final _currCtrl = TextEditingController();

  // ── Owner account fields ────────────────────────────────────────────
  final _adminUsernameCtrl = TextEditingController();
  final _adminPasswordCtrl = TextEditingController();
  final _adminFullNameCtrl = TextEditingController();
  bool _obscurePassword = true;

  bool _isLoading = false;
  int _step = 0; // 0 = basic, 1 = settings, 2 = owner account

  @override
  void dispose() {
    _nameCtrl.dispose();
    _codeCtrl.dispose();
    _emailCtrl.dispose();
    _maxCtrl.dispose();
    _tzCtrl.dispose();
    _currCtrl.dispose();
    _adminUsernameCtrl.dispose();
    _adminPasswordCtrl.dispose();
    _adminFullNameCtrl.dispose();
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
      adminUsername: _adminUsernameCtrl.text.trim(),
      adminPassword: _adminPasswordCtrl.text,
      adminFullName: _adminFullNameCtrl.text.trim(),
    );
    if (mounted) setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final t1 = isDark ? Pallets.textPrimaryDark : Pallets.textPrimaryLight;
    final t2 = isDark ? Pallets.textSecondaryDark : Pallets.textSecondaryLight;
    final fill = isDark ? Pallets.surfaceElevated : Pallets.backgroundLight;
    final border = isDark ? Pallets.borderDark : Pallets.borderLight;

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Handle ────────────────────────────────────────────
              Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      gradient: Pallets.brandGradient,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.business_outlined,
                      color: Pallets.onAccent,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Register Company',
                        style: TextStyle(
                          color: t1,
                          fontSize: 17,
                          fontWeight: FontWeight.w700,
                          letterSpacing: -0.4,
                        ),
                      ),
                      Text(
                        'Fill in your company details',
                        style: TextStyle(color: t2, fontSize: 12),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // ── Step tabs ─────────────────────────────────────────
              _StepTabs(
                current: _step,
                labels: const ['Basic Info', 'Settings', 'Owner Account'],
                onTap: (i) => setState(() => _step = i),
              ),
              const SizedBox(height: 20),

              // ── Step 0: Basic ──────────────────────────────────────
              if (_step == 0) ...[
                _Field(
                  controller: _nameCtrl,
                  label: 'Company Name',
                  icon: Icons.business_outlined,
                  isDark: isDark,
                  fill: fill,
                  border: border,
                  validator: (v) => v!.trim().isEmpty ? 'Required' : null,
                ),
                _Field(
                  controller: _codeCtrl,
                  label: 'Company Code',
                  icon: Icons.tag_rounded,
                  isDark: isDark,
                  fill: fill,
                  border: border,
                  validator: (v) => v!.trim().isEmpty ? 'Required' : null,
                ),
                _Field(
                  controller: _emailCtrl,
                  label: 'Email',
                  icon: Icons.email_outlined,
                  isDark: isDark,
                  fill: fill,
                  border: border,
                  keyboardType: TextInputType.emailAddress,
                  validator: (v) => v!.trim().isEmpty ? 'Required' : null,
                ),
                _Field(
                  controller: _maxCtrl,
                  label: 'Max Users',
                  icon: Icons.people_outline_rounded,
                  isDark: isDark,
                  fill: fill,
                  border: border,
                  keyboardType: TextInputType.number,
                  validator: (v) {
                    if (v == null || v.trim().isEmpty) return 'Required';
                    if (int.tryParse(v.trim()) == null)
                      return 'Must be a number';
                    return null;
                  },
                ),
                const SizedBox(height: 4),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () => setState(() => _step = 1),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Pallets.blurple,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      elevation: 0,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Text(
                          'Next',
                          style: TextStyle(
                            color: Pallets.onAccent,
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(width: 6),
                        Icon(
                          Icons.arrow_forward_rounded,
                          color: Pallets.onAccent,
                          size: 16,
                        ),
                      ],
                    ),
                  ),
                ),
              ],

              // ── Step 1: Settings ───────────────────────────────────
              if (_step == 1) ...[
                _Field(
                  controller: _tzCtrl,
                  label: 'Timezone',
                  icon: Icons.public_outlined,
                  hint: 'e.g. Asia/Phnom_Penh',
                  isDark: isDark,
                  fill: fill,
                  border: border,
                  validator: (v) => v!.trim().isEmpty ? 'Required' : null,
                ),
                _Field(
                  controller: _currCtrl,
                  label: 'Currency',
                  icon: Icons.attach_money_rounded,
                  hint: 'e.g. USD, KHR',
                  isDark: isDark,
                  fill: fill,
                  border: border,
                  validator: (v) => v!.trim().isEmpty ? 'Required' : null,
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => setState(() => _step = 0),
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(color: border),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                        child: Text(
                          'Back',
                          style: TextStyle(
                            color: t2,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      flex: 2,
                      child: SizedBox(
                        height: 50,
                        child: ElevatedButton(
                          onPressed: () => setState(() => _step = 2),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Pallets.blurple,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                            elevation: 0,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Text(
                                'Next',
                                style: TextStyle(
                                  color: Pallets.onAccent,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              SizedBox(width: 6),
                              Icon(
                                Icons.arrow_forward_rounded,
                                color: Pallets.onAccent,
                                size: 16,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],

              // ── Step 2: Owner Account ───────────────────────────────
              if (_step == 2) ...[
                _Field(
                  controller: _adminFullNameCtrl,
                  label: 'Full Name',
                  icon: Icons.person_outline_rounded,
                  isDark: isDark,
                  fill: fill,
                  border: border,
                  validator: (v) => v!.trim().isEmpty ? 'Required' : null,
                ),
                _Field(
                  controller: _adminUsernameCtrl,
                  label: 'Username',
                  icon: Icons.alternate_email_rounded,
                  isDark: isDark,
                  fill: fill,
                  border: border,
                  validator: (v) {
                    if (v == null || v.trim().isEmpty) return 'Required';
                    if (v.trim().length < 3) return 'Min 3 characters';
                    return null;
                  },
                ),
                _PasswordField(
                  controller: _adminPasswordCtrl,
                  label: 'Password',
                  isDark: isDark,
                  fill: fill,
                  border: border,
                  obscure: _obscurePassword,
                  onToggle: () =>
                      setState(() => _obscurePassword = !_obscurePassword),
                  validator: (v) {
                    if (v == null || v.isEmpty) return 'Required';
                    if (v.length < 8) return 'Min 8 characters';
                    return null;
                  },
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => setState(() => _step = 1),
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(color: border),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                        child: Text(
                          'Back',
                          style: TextStyle(
                            color: t2,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      flex: 2,
                      child: SizedBox(
                        height: 50,
                        child: ElevatedButton(
                          onPressed: _isLoading ? null : _submit,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Pallets.blurple,
                            disabledBackgroundColor: Pallets.blurple
                                .withOpacity(0.4),
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
                                    color: Pallets.onAccent,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],

              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Step tabs ─────────────────────────────────────────────────────────────────
class _StepTabs extends StatelessWidget {
  final int current;
  final List<String> labels;
  final ValueChanged<int> onTap;
  const _StepTabs({
    required this.current,
    required this.labels,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final trackColor = isDark
        ? Pallets.surfaceElevated
        : Pallets.backgroundLight;

    return Container(
      height: 40,
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        color: trackColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: List.generate(labels.length, (i) {
          final active = i == current;
          return Expanded(
            child: GestureDetector(
              onTap: () => onTap(i),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                curve: Curves.easeOut,
                decoration: BoxDecoration(
                  color: active ? Pallets.blurple : Colors.transparent,
                  borderRadius: BorderRadius.circular(9),
                  boxShadow: active
                      ? [
                          BoxShadow(
                            color: Pallets.blurple.withOpacity(0.3),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ]
                      : [],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 18,
                      height: 18,
                      decoration: BoxDecoration(
                        color: active
                            ? Colors.white.withOpacity(0.2)
                            : Pallets.blurple.withOpacity(0.15),
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Text(
                          '${i + 1}',
                          style: TextStyle(
                            color: active ? Colors.white : Pallets.blurple,
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      labels[i],
                      style: TextStyle(
                        color: active
                            ? Colors.white
                            : (isDark
                                  ? Pallets.textSecondaryDark
                                  : Pallets.textSecondaryLight),
                        fontSize: 12,
                        fontWeight: active ? FontWeight.w600 : FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }),
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
  final bool isDark;
  final Color fill;
  final Color border;

  const _Field({
    required this.controller,
    required this.label,
    required this.icon,
    required this.isDark,
    required this.fill,
    required this.border,
    this.hint,
    this.keyboardType,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    final t1 = isDark ? Pallets.textPrimaryDark : Pallets.textPrimaryLight;
    final t2 = isDark ? Pallets.textSecondaryDark : Pallets.textSecondaryLight;

    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        validator: validator,
        style: TextStyle(color: t1, fontSize: 14),
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          prefixIcon: Icon(icon, color: t2, size: 19),
          labelStyle: TextStyle(color: t2, fontSize: 13),
          hintStyle: TextStyle(color: t2.withOpacity(0.5), fontSize: 13),
          filled: true,
          fillColor: fill,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 14,
            vertical: 14,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: border),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: border),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Pallets.blurple, width: 1.5),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Pallets.error),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Pallets.error, width: 1.5),
          ),
        ),
      ),
    );
  }
}

// ── Password Field ──────────────────────────────────────────────────────────
class _PasswordField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final bool obscure;
  final VoidCallback onToggle;
  final String? Function(String?)? validator;
  final bool isDark;
  final Color fill;
  final Color border;

  const _PasswordField({
    required this.controller,
    required this.label,
    required this.obscure,
    required this.onToggle,
    required this.isDark,
    required this.fill,
    required this.border,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    final t1 = isDark ? Pallets.textPrimaryDark : Pallets.textPrimaryLight;
    final t2 = isDark ? Pallets.textSecondaryDark : Pallets.textSecondaryLight;

    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: TextFormField(
        controller: controller,
        obscureText: obscure,
        validator: validator,
        style: TextStyle(color: t1, fontSize: 14),
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(Icons.lock_outline_rounded, color: t2, size: 19),
          suffixIcon: IconButton(
            icon: Icon(
              obscure
                  ? Icons.visibility_outlined
                  : Icons.visibility_off_outlined,
              color: t2,
              size: 19,
            ),
            onPressed: onToggle,
          ),
          labelStyle: TextStyle(color: t2, fontSize: 13),
          filled: true,
          fillColor: fill,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 14,
            vertical: 14,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: border),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: border),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Pallets.blurple, width: 1.5),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Pallets.error),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Pallets.error, width: 1.5),
          ),
        ),
      ),
    );
  }
}
