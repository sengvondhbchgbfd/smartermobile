import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
                    ],
                  ),
                ),
              ),
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
}
