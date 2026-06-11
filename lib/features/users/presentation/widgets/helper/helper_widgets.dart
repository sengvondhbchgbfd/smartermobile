import 'package:flutter/material.dart';
import 'package:frontendmobile/core/themes/app_pallets.dart';
import 'package:go_router/go_router.dart';

// ── Box Decoration ────────────────────────────────────────────────────────────

BoxDecoration userFormBox() => BoxDecoration(
  color: Colors.white.withOpacity(0.05),
  borderRadius: BorderRadius.circular(14),
  border: Border.all(color: Colors.white.withOpacity(0.08)),
);

// ── Section Label ─────────────────────────────────────────────────────────────

class UserFormLabel extends StatelessWidget {
  final String text;
  const UserFormLabel(this.text, {super.key});

  @override
  Widget build(BuildContext context) => Text(
    text,
    style: TextStyle(
      color: Pallets.textSecondaryDark,
      fontSize: 12,
      fontWeight: FontWeight.w600,
      letterSpacing: 0.8,
    ),
  );
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
  Widget build(BuildContext context) => Container(
    decoration: userFormBox(),
    child: TextField(
      controller: controller,
      obscureText: obscure,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Pallets.textSecondaryDark),
        prefixIcon: Icon(icon, color: Pallets.textSecondaryDark, size: 20),
        suffixIcon: suffixIcon,
        border: InputBorder.none,
        contentPadding: const EdgeInsets.symmetric(vertical: 16),
      ),
    ),
  );
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
  Widget build(BuildContext context) => Container(
    decoration: userFormBox(),
    padding: const EdgeInsets.symmetric(horizontal: 12),
    child: DropdownButtonFormField<T>(
      value: value,
      dropdownColor: const Color(0xFF2C2C3E),
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: Pallets.textSecondaryDark, size: 20),
        border: InputBorder.none,
        contentPadding: const EdgeInsets.symmetric(vertical: 14),
      ),
      hint: Text(hint, style: TextStyle(color: Pallets.textSecondaryDark)),
      items: items,
      onChanged: onChanged,
    ),
  );
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
        backgroundColor: Pallets.gradient2,
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
  Widget build(BuildContext context) => GestureDetector(
    onTap: () => context.pop(),
    child: Container(
      margin: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.07),
        shape: BoxShape.circle,
      ),
      child: const Icon(
        Icons.chevron_left_rounded,
        color: Colors.white,
        size: 22,
      ),
    ),
  );
}
