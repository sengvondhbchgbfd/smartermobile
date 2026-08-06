import 'package:flutter/material.dart';
import 'package:frontendmobile/core/themes/app_pallets.dart';
import 'package:go_router/go_router.dart';

// ── Box Decoration ────────────────────────────────────────────────────────────

BoxDecoration userFormBox(BuildContext context) {
  final isDark = Theme.of(context).brightness == Brightness.dark;
  return BoxDecoration(
    color: isDark ? Pallets.surfaceCard : Pallets.surfaceLight,
    borderRadius: BorderRadius.circular(14),
    border: Border.all(
      color: isDark ? Pallets.borderDark : Pallets.borderLight,
    ),
  );
}

// ── Section Label ─────────────────────────────────────────────────────────────

class UserFormLabel extends StatelessWidget {
  final String text;
  const UserFormLabel(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textSecondary = isDark
        ? Pallets.textSecondaryDark
        : Pallets.textSecondaryLight;
    return Text(
      text,
      style: TextStyle(
        color: textSecondary,
        fontSize: 12,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.8,
      ),
    );
  }
}

// ── Text Field ────────────────────────────────────────────────────────────────

class UserFormField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final IconData icon;
  final bool obscure;
  final Widget? suffixIcon;

  const UserFormField({
    super.key,
    required this.controller,
    required this.label,
    required this.icon,
    this.obscure = false,
    this.suffixIcon,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textPrimary = isDark
        ? Pallets.textPrimaryDark
        : Pallets.textPrimaryLight;
    final textSecondary = isDark
        ? Pallets.textSecondaryDark
        : Pallets.textSecondaryLight;

    return Container(
      decoration: userFormBox(context),
      child: TextField(
        controller: controller,
        obscureText: obscure,
        style: TextStyle(color: textPrimary),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(color: textSecondary),
          prefixIcon: Icon(icon, color: textSecondary, size: 20),
          suffixIcon: suffixIcon,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 16),
        ),
      ),
    );
  }
}

// ── Dropdown ──────────────────────────────────────────────────────────────────

class UserFormDropdown<T> extends StatelessWidget {
  final String hint;
  final IconData icon;
  final T? value;
  final List<DropdownMenuItem<T>> items;
  final ValueChanged<T?> onChanged;

  const UserFormDropdown({
    super.key,
    required this.hint,
    required this.icon,
    required this.value,
    required this.items,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textPrimary = isDark
        ? Pallets.textPrimaryDark
        : Pallets.textPrimaryLight;
    final textSecondary = isDark
        ? Pallets.textSecondaryDark
        : Pallets.textSecondaryLight;
    final dropdownBg = isDark ? Pallets.surfaceOverlay : Pallets.surfaceLight;

    return Container(
      decoration: userFormBox(context),
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: DropdownButtonFormField<T>(
        value: value,
        dropdownColor: dropdownBg,
        style: TextStyle(color: textPrimary),
        decoration: InputDecoration(
          prefixIcon: Icon(icon, color: textSecondary, size: 20),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 14),
        ),
        hint: Text(hint, style: TextStyle(color: textSecondary)),
        items: items,
        onChanged: onChanged,
      ),
    );
  }
}

// ── Submit Button ─────────────────────────────────────────────────────────────

class UserFormButton extends StatelessWidget {
  final String label;
  final bool loading;
  final VoidCallback? onPressed;

  const UserFormButton({
    super.key,
    required this.label,
    required this.loading,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) => SizedBox(
    width: double.infinity,
    child: ElevatedButton(
      onPressed: loading ? null : onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: Pallets.blurple,
        disabledBackgroundColor: Pallets.blurple.withOpacity(0.5),
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      ),
      child: loading
          ? const SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: Colors.white,
              ),
            )
          : Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
            ),
    ),
  );
}

// ── Back Button ───────────────────────────────────────────────────────────────

class UserFormBackButton extends StatelessWidget {
  const UserFormBackButton({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textPrimary = isDark
        ? Pallets.textPrimaryDark
        : Pallets.textPrimaryLight;
    final iconBg = isDark
        ? Colors.white.withOpacity(0.07)
        : Colors.black.withOpacity(0.05);

    return GestureDetector(
      onTap: () => context.pop(),
      child: Container(
        margin: const EdgeInsets.all(8),
        decoration: BoxDecoration(color: iconBg, shape: BoxShape.circle),
        child: Icon(Icons.chevron_left_rounded, color: textPrimary, size: 22),
      ),
    );
  }
}
