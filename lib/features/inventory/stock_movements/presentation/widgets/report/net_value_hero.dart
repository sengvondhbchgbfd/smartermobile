import 'package:flutter/material.dart';
import 'package:frontendmobile/core/themes/app_pallets.dart';

class NetValueHero extends StatelessWidget {
  final String value;
  final int qtyIn;
  final int qtyOut;
  final bool isDark;
  const NetValueHero({
    super.key,
    required this.value,
    required this.qtyIn,
    required this.qtyOut,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 18),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Pallets.blurple, Pallets.blurple.withOpacity(0.72)],
        ),
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: Pallets.blurple.withOpacity(0.35),
            blurRadius: 24,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'NET VALUE',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: Colors.white.withOpacity(0.75),
              letterSpacing: 1.1,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: const TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.w800,
              color: Colors.white,
              letterSpacing: -0.8,
            ),
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Icon(
                Icons.arrow_downward_rounded,
                size: 14,
                color: Colors.white.withOpacity(0.85),
              ),
              const SizedBox(width: 3),
              Text(
                '$qtyIn in',
                style: TextStyle(
                  fontSize: 12.5,
                  fontWeight: FontWeight.w600,
                  color: Colors.white.withOpacity(0.9),
                ),
              ),
              const SizedBox(width: 14),
              Icon(
                Icons.arrow_upward_rounded,
                size: 14,
                color: Colors.white.withOpacity(0.85),
              ),
              const SizedBox(width: 3),
              Text(
                '$qtyOut out',
                style: TextStyle(
                  fontSize: 12.5,
                  fontWeight: FontWeight.w600,
                  color: Colors.white.withOpacity(0.9),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
