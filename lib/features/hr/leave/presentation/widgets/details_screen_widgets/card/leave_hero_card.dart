import 'package:flutter/material.dart';
import 'package:frontendmobile/features/hr/leave/domain/entities/leave_entity.dart';
import 'package:frontendmobile/features/hr/leave/presentation/widgets/details_screen_widgets/config/status_c_f_g_type.dart';

class HeroCard extends StatelessWidget {
  //////////////////////////////////////////////////////////////////////////////
  //  CONSTRUCTOR
  //////////////////////////////////////////////////////////////////////////////
  final LeaveEntity leave;
  final int days;
  final Color card, border, textPrimary, textSecondary, accent;
  final StatusCfg statusCfg;
  final TypeCfg typeCfg;
  //////////////////////////////////////////////////////////////////////////////
  ///
  //////////////////////////////////////////////////////////////////////////////

  const HeroCard({
    super.key,
    required this.leave,
    required this.days,
    required this.card,
    required this.border,
    required this.textPrimary,
    required this.textSecondary,
    required this.statusCfg,
    required this.typeCfg,
    required this.accent,
  });

  //////////////////////////////////////////////////////////////////////////////
  ///
  //////////////////////////////////////////////////////////////////////////////

  @override
  Widget build(BuildContext context) {
    return Container(
      //////////////////////////////////////////////////////////////////////////
      ///
      //////////////////////////////////////////////////////////////////////////
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: card,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: border),
      ),

      //////////////////////////////////////////////////////////////////////////
      ///
      //////////////////////////////////////////////////////////////////////////
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //////////////////////////////////////////////////////////////////////
          // top row: avatar + name + status
          //////////////////////////////////////////////////////////////////////
          Row(
            children: [
              //////////////////////////////////////////////////////////////////
              // avatar
              //////////////////////////////////////////////////////////////////
              CircleAvatar(
                radius: 26,
                backgroundImage: leave.staffAvatarUrl != null
                    ? NetworkImage(leave.staffAvatarUrl!)
                    : null,
                backgroundColor: accent.withOpacity(0.15),
                child: leave.staffAvatarUrl == null
                    ? Text(
                        (leave.displayName)[0].toUpperCase(),
                        style: TextStyle(
                          color: accent,
                          fontWeight: FontWeight.w700,
                          fontSize: 18,
                        ),
                      )
                    : null,
              ),
              const SizedBox(width: 12),

              //////////////////////////////////////////////////////////////////
              //  LEAVE #ID
              //////////////////////////////////////////////////////////////////
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      leave.displayName,
                      style: TextStyle(
                        color: textPrimary,
                        fontWeight: FontWeight.w700,
                        fontSize: 15,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Leave #${leave.leaveId}',
                      style: TextStyle(color: textSecondary, fontSize: 12),
                    ),
                  ],
                ),
              ),

              //////////////////////////////////////////////////////////////////
              ///  STATUS BADGE
              //////////////////////////////////////////////////////////////////

              // status badge
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: statusCfg.bg,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(statusCfg.icon, color: statusCfg.color, size: 13),
                    const SizedBox(width: 5),
                    Text(
                      statusCfg.label,
                      style: TextStyle(
                        color: statusCfg.color,
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),
          Divider(color: border, height: 1),
          const SizedBox(height: 20),

          //////////////////////////////////////////////////////////////////////
          // LEAVE TYPE + DAYE COUNT
          //////////////////////////////////////////////////////////////////////
          Row(
            children: [
              //////////////////////////////////////////////////////////////////
              // type pill
              //////////////////////////////////////////////////////////////////
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: typeCfg.color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(typeCfg.icon, color: typeCfg.color, size: 16),
                    const SizedBox(width: 6),
                    Text(
                      typeCfg.label,
                      style: TextStyle(
                        color: typeCfg.color,
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(),

              //////////////////////////////////////////////////////////////////
              // days count
              //////////////////////////////////////////////////////////////////
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '$days',
                    style: TextStyle(
                      color: textPrimary,
                      fontSize: 28,
                      fontWeight: FontWeight.w800,
                      height: 1,
                    ),
                  ),
                  Text(
                    days == 1 ? 'day' : 'days',
                    style: TextStyle(color: textSecondary, fontSize: 12),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
