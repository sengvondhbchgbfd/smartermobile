import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontendmobile/core/themes/app_pallets.dart';
import 'package:frontendmobile/features/company/presentation/widgets/card/info_row.dart';
import 'package:frontendmobile/features/company/presentation/widgets/card/plan_badge.dart';
import 'package:frontendmobile/features/company/presentation/widgets/card/plan_state_card.dart';
import 'package:frontendmobile/features/company/presentation/widgets/card/switch_account_button.dart';
import 'package:frontendmobile/features/company/presentation/widgets/card/user_state_card.dart';
import 'package:frontendmobile/features/profile/presentation/widgets/status_badge.dart';
import '../../domain/entities/company_entity.dart';

class CompanyInfoCard extends ConsumerWidget {
  final CompanyEntity company;
  final List<StaffPreview> users;
  const CompanyInfoCard({
    super.key,
    required this.company,
    this.users = const [],
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ////////////////////////////////////////////////////////////////////////////
    ///
    ////////////////////////////////////////////////////////////////////////////
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final t1 = isDark ? Pallets.textPrimaryDark : Pallets.textPrimaryLight;
    final t2 = isDark ? Pallets.textSecondaryDark : Pallets.textSecondaryLight;
    final surf = isDark ? Pallets.surfaceDark : Pallets.surfaceLight;
    final border = isDark ? Pallets.borderDark : Pallets.borderLight;
    final divider = isDark ? Pallets.dividerDark : Pallets.dividerLight;
    final avatarBg = isDark ? Pallets.backgroundDark : Pallets.backgroundLight;
    ////////////////////////////////////////////////////////////////////////////
    ///
    ////////////////////////////////////////////////////////////////////////////
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── Banner + Avatar + Switch button ────────────────────────────
        Stack(
          clipBehavior: Clip.none,
          children: [
            // Banner
            Container(
              height: 120,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: surf,
                border: Border.all(color: border),
                image: company.bannerUrl != null
                    ? DecorationImage(
                        image: NetworkImage(company.bannerUrl!),
                        fit: BoxFit.cover,
                      )
                    : null,
              ),
              child: company.bannerUrl == null
                  ? Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Pallets.purpleStart.withOpacity(0.5),
                            Pallets.blurple.withOpacity(0.35),
                          ],
                        ),
                      ),
                    )
                  : Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            Colors.black.withOpacity(0.5),
                          ],
                        ),
                      ),
                    ),
            ),

            // Status badge
            Positioned(
              top: 10,
              left: 10,
              child: StatusBadge(status: company.status),
            ),

            // Logo avatar
            Positioned(
              bottom: -38,
              left: 16,
              child: Container(
                width: 76,
                height: 76,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: avatarBg,
                  border: Border.all(color: avatarBg, width: 3),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.25),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                  image: company.logoUrl != null
                      ? DecorationImage(
                          image: NetworkImage(company.logoUrl!),
                          fit: BoxFit.cover,
                        )
                      : null,
                ),
                child: company.logoUrl == null
                    ? Icon(Icons.business_rounded, color: t2, size: 34)
                    : null,
              ),
            ),

            // Switch account button
            Positioned(
              bottom: -18,
              right: 0,
              child: const SwitchAccountButton(),
            ),
          ],
        ),

        const SizedBox(height: 50),

        // ── Main info card ─────────────────────────────────────────────
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: surf,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: border),
          ),
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Company name + code
              Text(
                company.companyName,
                style: TextStyle(
                  color: t1,
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  letterSpacing: -0.4,
                ),
              ),
              if (company.companyCode != null) ...[
                const SizedBox(height: 2),
                Text(
                  company.companyCode!,
                  style: TextStyle(color: t2, fontSize: 13),
                ),
              ],

              const SizedBox(height: 16),

              // ── Stats: vertical stack, no overflow ──────────────────
              UsersStatCard(
                currentUsers: users.length,
                maxUsers: company.maxUsers ?? 0,
                users: users,
              ),
              const SizedBox(height: 10),
              PlanStatCard(plan: company.planType),

              const SizedBox(height: 20),
              Divider(color: divider),
              const SizedBox(height: 12),

              // ── Info rows ────────────────────────────────────────────
              InfoRow(
                icon: Icons.email_outlined,
                label: 'Email',
                value: company.email,
              ),
              InfoRow(
                icon: Icons.phone_outlined,
                label: 'Phone',
                value: company.phone,
              ),
              InfoRow(
                icon: Icons.location_on_outlined,
                label: 'Address',
                value: company.address,
              ),
              InfoRow(
                icon: Icons.public_outlined,
                label: 'Timezone',
                value: company.timezone,
              ),
              InfoRow(
                icon: Icons.attach_money_rounded,
                label: 'Currency',
                value: company.currency,
              ),

              const SizedBox(height: 20),
              Divider(color: divider),
              const SizedBox(height: 12),

              // ── Bottom row ───────────────────────────────────────────
              Row(
                children: [
                  PlanBadge(plan: company.planType),
                  const Spacer(),
                  if (company.expiresAt != null)
                    Text(
                      'Expires: ${_formatDate(company.expiresAt!)}',
                      style: TextStyle(color: t2, fontSize: 12),
                    ),
                ],
              ),
            ],
          ),
        ),

        const SizedBox(height: 80),
      ],
    );
  }

  String _formatDate(DateTime dt) => '${dt.day}/${dt.month}/${dt.year}';
}
