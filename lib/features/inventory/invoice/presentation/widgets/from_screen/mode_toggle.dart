import 'package:flutter/material.dart';
import 'package:frontendmobile/features/inventory/invoice/presentation/widgets/from_screen/create_mode.dart';
import 'package:frontendmobile/features/inventory/invoice/presentation/widgets/invoice_theme_color.dart';

class ModeToggle extends StatelessWidget {
  /////////////////////////////////////////////
  /// CONSTRUCTOR TYPE
  ////////////////////////////////////////////
  final CreationMode mode;
  final bool enabled;
  final ValueChanged<CreationMode> onChanged;

  const ModeToggle({
    required this.mode,
    required this.enabled,
    required this.onChanged,
    super.key,
  });

  ////////////////////////////////////////////
  ///  BUILDING WIDGETS
  ///////////////////////////////////////////

  @override
  Widget build(BuildContext context) {
    final colors = context.invoiceColors;

    return Container(
      /////////////////////////////////
      ///
      ////////////////////////////////
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: colors.card,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: colors.border),
      ),

      /////////////////////////////////
      ///
      ////////////////////////////////
      child: Row(
        children: [
          Expanded(
            child: _modeButton(
              context,
              'Manual Entry',
              Icons.edit_note_rounded,
              CreationMode.manual,
            ),
          ),
          const SizedBox(width: 4),
          Expanded(
            child: _modeButton(
              context,
              'From Quotation',
              Icons.request_quote_outlined,
              CreationMode.quotation,
            ),
          ),
        ],
      ),
    );
  }

  /////////////////////////////////
  ///
  ////////////////////////////////

  Widget _modeButton(
    BuildContext context,
    String label,
    IconData icon,
    CreationMode value,
  ) {
    /////////////////////////////////
    ///
    ////////////////////////////////
    final colors = context.invoiceColors;
    final selected = mode == value;
    /////////////////////////////////
    ///
    ////////////////////////////////
    return GestureDetector(
      onTap: enabled ? () => onChanged(value) : null,

      /////////////////////////////////
      ///
      ////////////////////////////////
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(vertical: 10),

        /////////////////////////////////
        ///
        ////////////////////////////////
        decoration: BoxDecoration(
          color: selected ? colors.accent : Colors.transparent,
          borderRadius: BorderRadius.circular(9),
        ),

        /////////////////////////////////
        ///
        ////////////////////////////////
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 16,
              color: selected ? colors.onAccent : colors.textSecondary,
            ),
            /////////////////////////////////
            ///
            ////////////////////////////////
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: selected ? colors.onAccent : colors.textSecondary,
              ),
            ),
            /////////////////////////////////
            ///
            ////////////////////////////////
          ],
        ),
      ),
    );
  }
}
