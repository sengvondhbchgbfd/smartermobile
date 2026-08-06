  // ── status config ──────────────────────────────────────────────────────────


import 'package:flutter/material.dart';
import 'package:frontendmobile/features/hr/leave/presentation/widgets/details_screen_widgets/config/status_c_f_g_type.dart';

StatusCfg statusCfg(String? status) {
    switch (status?.toLowerCase()) {
      case 'approved':
        return StatusCfg(
          label: 'Approved',
          color: const Color(0xFF22C55E),
          bg: const Color(0xFF22C55E).withOpacity(0.12),
          icon: Icons.check_circle_rounded,
        );
      case 'rejected':
        return StatusCfg(
          label: 'Rejected',
          color: const Color(0xFFEF4444),
          bg: const Color(0xFFEF4444).withOpacity(0.12),
          icon: Icons.cancel_rounded,
        );
      case 'pending':
      default:
        return StatusCfg(
          label: 'Pending',
          color: const Color(0xFFF59E0B),
          bg: const Color(0xFFF59E0B).withOpacity(0.12),
          icon: Icons.hourglass_top_rounded,
        );
    }
  }

  // ── leave type config ──────────────────────────────────────────────────────
  TypeCfg typeCfg(String? type) {
    switch (type?.toLowerCase()) {
      case 'sick':
        return TypeCfg(
          label: 'Sick Leave',
          icon: Icons.sick_rounded,
          color: const Color(0xFF818CF8),
        );
      case 'annual':
        return TypeCfg(
          label: 'Annual Leave',
          icon: Icons.beach_access_rounded,
          color: const Color(0xFF38BDF8),
        );
      case 'maternity':
        return TypeCfg(
          label: 'Maternity Leave',
          icon: Icons.child_friendly_rounded,
          color: const Color(0xFFF472B6),
        );
      case 'emergency':
        return TypeCfg(
          label: 'Emergency Leave',
          icon: Icons.warning_amber_rounded,
          color: const Color(0xFFFB923C),
        );
      case 'other':
      default:
        return TypeCfg(
          label: 'Other Leave',
          icon: Icons.event_note_rounded,
          color: const Color(0xFF94A3B8),
        );
    }
  }