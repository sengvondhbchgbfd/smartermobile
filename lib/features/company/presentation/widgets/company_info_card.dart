import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
<<<<<<< HEAD
import 'package:frontendmobile/features/company/domain/usecases/update_company_usecase.dart';
import 'package:image_picker/image_picker.dart';
import '../../domain/entities/company_entity.dart';
import '../providers/company_provider.dart';

class CompanyInfoCard extends ConsumerWidget {
  final CompanyEntity company;
  const CompanyInfoCard({super.key, required this.company});
  //////////////////////////////////////////////////////////////////////////////
  //
  //////////////////////////////////////////////////////////////////////////////
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(companyProvider);
    final isUpdating = state.valueOrNull?.isUpdating ?? false;

    Future<void> pickAndUpload({required bool isLogo}) async {
      final picker = ImagePicker();
      final picked = await picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 85,
      );
      if (picked == null) return;
      await ref
          .read(companyProvider.notifier)
          .uploadLogo(
            companyId: company.id,
            filePath: picked.path,
            oldLogoPublicId: isLogo
                ? company.logoPublicId
                : company.bannerPublicId,
          );
    }

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.08)),
      ),
      child: Column(
        children: [
          ///////////////////////////////////////////////////////////////////
          /// ───────── Banner + Logo ─────────
          /// ///////////////////////////////////////////////////////////////
          Stack(
            clipBehavior: Clip.none,
            children: [
              GestureDetector(
                onTap: isUpdating ? null : () => pickAndUpload(isLogo: false),
                child: Container(
                  height: 100,
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(16),
                    ),
                    color: const Color(0xFF334155),
                    image: company.bannerUrl != null
                        ? DecorationImage(
                            image: NetworkImage(company.bannerUrl!),
                            fit: BoxFit.cover,
                          )
                        : null,
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(16),
                      ),
                      color: Colors.black.withOpacity(0.3),
                    ),
                    child: const Center(
                      child: Icon(
                        Icons.camera_alt_outlined,
                        color: Colors.white54,
                      ),
                    ),
                  ),
                ),
              ),

              /// Logo
              Positioned(
                bottom: -36,
                left: 20,
                child: GestureDetector(
                  onTap: isUpdating ? null : () => pickAndUpload(isLogo: true),
                  child: Stack(
                    children: [
                      Container(
                        width: 72,
                        height: 72,
                        decoration: BoxDecoration(
                          color: const Color(0xFF0F172A),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: const Color(0xFF1E293B),
                            width: 3,
                          ),
                          image: company.logoUrl != null
                              ? DecorationImage(
                                  image: NetworkImage(company.logoUrl!),
                                  fit: BoxFit.cover,
                                )
                              : null,
                        ),
                        child: company.logoUrl == null
                            ? const Icon(Icons.business, color: Colors.white54)
                            : null,
                      ),

                      if (isUpdating)
                        Positioned.fill(
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.black45,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Center(
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            ),
                          ),
                        ),
=======
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
>>>>>>> 9f1638c8060e11abffb348266a42c22f5d24569c
                    ],
                  ),
                ),
              ),
<<<<<<< HEAD
            ],
          ),

          const SizedBox(height: 44),
          //////////////////////////////////////////////////////////////////
          /// ───────── Details ─────────
          /// ///////////////////////////////////////////////////////////////
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        company.companyName,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    _StatusBadge(status: company.status),

                    /// ✏️ EDIT BUTTON
                    IconButton(
                      icon: const Icon(Icons.edit, color: Colors.white70),
                      onPressed: () => _showEditDialog(context, ref, company),
                    ),
                  ],
                ),

                if (company.companyCode != null)
                  Text(
                    company.companyCode!,
                    style: const TextStyle(color: Colors.white38),
                  ),

                const SizedBox(height: 20),
                const Divider(color: Colors.white12),
                const SizedBox(height: 10),

                _InfoRow(Icons.email, 'Email', company.email),
                _InfoRow(Icons.phone, 'Phone', company.phone),
                _InfoRow(Icons.location_city, 'Address', company.address),
                _InfoRow(Icons.public, 'Timezone', company.timezone),
                _InfoRow(Icons.attach_money, 'Currency', company.currency),
                _InfoRow(
                  Icons.people,
                  'Max Users',
                  company.maxUsers?.toString(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  //////////////////////////////////////////////////////////////////////////////
  //  show dialog
  //////////////////////////////////////////////////////////////////////////////

  void _showEditDialog(
    BuildContext context,
    WidgetRef ref,
    CompanyEntity company,
  ) {
    final name = TextEditingController(text: company.companyName);
    final email = TextEditingController(text: company.email);
    final phone = TextEditingController(text: company.phone);
    final address = TextEditingController(text: company.address);
    final timezone = TextEditingController(text: company.timezone);
    final currency = TextEditingController(text: company.currency);

    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          backgroundColor: const Color(0xFF1E293B),
          title: const Text(
            'Edit Company',
            style: TextStyle(color: Colors.white),
          ),
          content: SingleChildScrollView(
            child: Column(
              children: [
                _input(name, 'Company Name'),
                _input(email, 'Email'),
                _input(phone, 'Phone'),
                _input(address, 'Address'),
                _input(timezone, 'Timezone'),
                _input(currency, 'Currency'),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                final success = await ref
                    .read(companyProvider.notifier)
                    .updateCompany(
                      UpdateCompanyParams(
                        companyId: company.id,
                        companyName: name.text,
                        email: email.text,
                        phone: phone.text,
                        address: address.text,
                        timezone: timezone.text,
                        currency: currency.text,
                      ),
                    );

                if (success) {
                  Navigator.pop(context);
                }
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  //////////////////////////////////////////////////////////////////////////////
  //
  //////////////////////////////////////////////////////////////////////////////

  Widget _input(TextEditingController c, String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: TextField(
        controller: c,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(color: Colors.white54),
          filled: true,
          fillColor: const Color(0xFF334155),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        ),
      ),
    );
  }
}

//////////////////////////////////////////////////////////////////////////////
//
//////////////////////////////////////////////////////////////////////////////
class _StatusBadge extends StatelessWidget {
  final String status;
  const _StatusBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    return Text(
      status.toUpperCase(),
      style: const TextStyle(color: Colors.green),
    );
  }
}

//////////////////////////////////////////////////////////////////////////////
//
//////////////////////////////////////////////////////////////////////////////
class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String? value;

  const _InfoRow(this.icon, this.label, this.value);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: Colors.white38),
        const SizedBox(width: 8),
        Text(label, style: const TextStyle(color: Colors.white54)),
        const Spacer(),
        Text(value ?? '—', style: const TextStyle(color: Colors.white)),
      ],
    );
  }
=======
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
>>>>>>> 9f1638c8060e11abffb348266a42c22f5d24569c
}
