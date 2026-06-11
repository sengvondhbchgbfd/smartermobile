import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontendmobile/core/themes/app_pallets.dart';
import 'package:frontendmobile/features/company/presentation/widgets/card/info_row.dart'
    show InfoRow;
import 'package:frontendmobile/features/company/presentation/widgets/card/plan_badge.dart';
import 'package:frontendmobile/features/company/presentation/widgets/card/plan_state._card.dart';
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ////////////////////////////////////////////////////////////////////////
        // ── Banner + Avatar + Switcher ───────────────────────────────────
        ////////////////////////////////////////////////////////////////////////
        Stack(
          clipBehavior: Clip.none,
          children: [
            // Banner
            Container(
              height: 120,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Pallets.surfaceDark,
                border: Border.all(color: Pallets.borderDark),
                image: company.bannerUrl != null
                    ? DecorationImage(
                        image: NetworkImage(company.bannerUrl!),
                        fit: BoxFit.cover,
                      )
                    : null,
              ),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black.withOpacity(0.55),
                    ],
                  ),
                ),
              ),
            ),
            ////////////////////////////////////////////////////////////////////
            // Status badge
            ////////////////////////////////////////////////////////////////////
            Positioned(
              top: 10,
              left: 10,
              child: StatusBadge(status: company.status),
            ),
            ////////////////////////////////////////////////////////////////////
            // Circular Avatar
            ////////////////////////////////////////////////////////////////////
            Positioned(
              bottom: -38,
              left: 16,
              child: Container(
                width: 76,
                height: 76,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Pallets.backgroundDark,
                  border: Border.all(color: Pallets.backgroundDark, width: 3),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.35),
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
                    ? Icon(
                        Icons.business_rounded,
                        color: Pallets.textSecondaryDark,
                        size: 34,
                      )
                    : null,
              ),
            ),
            ////////////////////////////////////////////////////////////////////
            // Switch account button
            ////////////////////////////////////////////////////////////////////
            Positioned(bottom: -18, right: 0, child: SwitchAccountButton()),
          ],
        ),

        const SizedBox(height: 50),
        ////////////////////////////////////////////////////////////////////////
        // ── Info Card ──────────────────────────────────────────────────
        ////////////////////////////////////////////////////////////////////////
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: Pallets.surfaceDark,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Pallets.borderDark),
          ),
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                company.companyName,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (company.companyCode != null)
                Text(
                  company.companyCode!,
                  style: TextStyle(
                    color: Pallets.textSecondaryDark,
                    fontSize: 13,
                  ),
                ),

              const SizedBox(height: 16),

              //////////////////////////////////////////////////////////////////
              // ── Stats Row ─────────────────────────────────────────────
              //////////////////////////////////////////////////////////////////
              Row(
                children: [
                  Expanded(
                    child: UsersStatCard(
                      currentUsers: users.length,
                      maxUsers: company.maxUsers ?? 0,
                      users: users,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(child: PlanStatCard(plan: company.planType)),
                ],
              ),

              const SizedBox(height: 20),
              Divider(color: Pallets.borderDark),
              const SizedBox(height: 12),

              //////////////////////////////////////////////////////////////////
              // ── Info Rows ────────────────────────────────────────────
              //////////////////////////////////////////////////////////////////
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
              Divider(color: Pallets.borderDark),
              const SizedBox(height: 12),

              //////////////////////////////////////////////////////////////////
              // ── Bottom Row ────────────────────────────────────────────
              //////////////////////////////////////////////////////////////////
              Row(
                children: [
                  PlanBadge(plan: company.planType),
                  const Spacer(),
                  if (company.expiresAt != null)
                    Text(
                      'Expires: ${_formatDate(company.expiresAt!)}',
                      style: TextStyle(
                        color: Pallets.textSecondaryDark,
                        fontSize: 12,
                      ),
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
