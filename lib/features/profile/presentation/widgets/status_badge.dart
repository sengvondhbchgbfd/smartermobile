import 'package:flutter/material.dart';
import 'package:frontendmobile/core/themes/app_pallets.dart';

class StatusBadge extends StatelessWidget {
  final String status;
  const StatusBadge({super.key, required this.status});

  //////////////////////////////////////////////////////////////////////////
  ///
  //////////////////////////////////////////////////////////////////////////

  Color get _bgColor {
    switch (status.toLowerCase()) {
      case 'active':
        return Pallets.success.withOpacity(0.15);
      case 'inactive':
        return Pallets.inactive.withOpacity(0.15);
      default:
        return Pallets.inactive.withOpacity(0.15);
    }
  }
  //////////////////////////////////////////////////////////////////////////
  ///
  //////////////////////////////////////////////////////////////////////////

  Color get _textColor {
    switch (status.toLowerCase()) {
      case 'active':
        return Pallets.success;
      case 'inactive':
        return Pallets.inactive;
      default:
        return Pallets.inactive;
    }
  }

  //////////////////////////////////////////////////////////////////////////
  ///
  //////////////////////////////////////////////////////////////////////////

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
      decoration: BoxDecoration(
        color: _bgColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        status[0].toUpperCase() + status.substring(1),
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: _textColor,
        ),
      ),
    );
  }
}
