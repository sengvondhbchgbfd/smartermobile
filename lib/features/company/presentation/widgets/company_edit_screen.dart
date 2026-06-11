import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontendmobile/core/themes/app_pallets.dart';
import 'package:frontendmobile/features/company/domain/usecases/update_company_usecase.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import '../../domain/entities/company_entity.dart';
import '../providers/company_provider.dart';

class CompanyEditScreen extends ConsumerStatefulWidget {
  final CompanyEntity company;
  const CompanyEditScreen({super.key, required this.company});

  @override
  ConsumerState<CompanyEditScreen> createState() => _CompanyEditScreenState();
}

class _CompanyEditScreenState extends ConsumerState<CompanyEditScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameCtrl;
  late final TextEditingController _emailCtrl;
  late final TextEditingController _phoneCtrl;
  late final TextEditingController _addressCtrl;
  late final TextEditingController _tzCtrl;
  late final TextEditingController _currCtrl;
  File? _pendingLogo;
  File? _pendingBanner;
  bool _hasChanges = false;

  @override
  void initState() {
    super.initState();
    _nameCtrl = TextEditingController(text: widget.company.companyName);
    _emailCtrl = TextEditingController(text: widget.company.email ?? '');
    _phoneCtrl = TextEditingController(text: widget.company.phone ?? '');
    _addressCtrl = TextEditingController(text: widget.company.address ?? '');
    _tzCtrl = TextEditingController(text: widget.company.timezone ?? '');
    _currCtrl = TextEditingController(text: widget.company.currency ?? '');

    for (final c in [
      _nameCtrl,
      _emailCtrl,
      _phoneCtrl,
      _addressCtrl,
      _tzCtrl,
      _currCtrl,
    ]) {
      c.addListener(_markChanged);
    }
  }

  void _markChanged() => setState(() => _hasChanges = true);

  @override
  void dispose() {
    for (final c in [
      _nameCtrl,
      _emailCtrl,
      _phoneCtrl,
      _addressCtrl,
      _tzCtrl,
      _currCtrl,
    ]) {
      c.dispose();
    }
    super.dispose();
  }

  // ── Pick image ─────────────────────────────────────────────────────────────

  Future<void> _pickImage({required bool isLogo}) async {
    final picked = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      imageQuality: 85,
    );
    if (picked == null) return;
    setState(() {
      if (isLogo) {
        _pendingLogo = File(picked.path);
      } else {
        _pendingBanner = File(picked.path);
      }
      _hasChanges = true;
    });
  }

  // ── Save ───────────────────────────────────────────────────────────────────

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    final notifier = ref.read(companyProvider.notifier);

    if (_pendingLogo != null) {
      await notifier.uploadLogo(
        companyId: widget.company.id,
        filePath: _pendingLogo!.path,
        isLogo: true,
        oldLogoPublicId: widget.company.logoPublicId,
      );
    }

    if (_pendingBanner != null) {
      await notifier.uploadLogo(
        companyId: widget.company.id,
        filePath: _pendingBanner!.path,
        isLogo: false,
        oldBannerPublicId: widget.company.bannerPublicId,
      );
    }

    final success = await notifier.updateCompany(
      UpdateCompanyParams(
        companyId: widget.company.id,
        companyName: _nameCtrl.text.trim(),
        email: _emailCtrl.text.trim(),
        phone: _phoneCtrl.text.trim(),
        address: _addressCtrl.text.trim(),
        timezone: _tzCtrl.text.trim(),
        currency: _currCtrl.text.trim(),
      ),
    );

    if (!mounted) return;
    if (success) {
      // ── FIX: GoRouter pop instead of Navigator.pop ────────────────────
      context.pop();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Company updated'),
          backgroundColor: Colors.green.shade700,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
    }
  }

  // ── Discard popup ──────────────────────────────────────────────────────────

  Future<bool> _confirmDiscard() async {
    if (!_hasChanges) return true;
    final discard = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: Pallets.surfaceDark,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text(
          'Discard changes?',
          style:
              TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
        ),
        content: Text(
          'You have unsaved changes. Are you sure you want to leave?',
          style: TextStyle(color: Pallets.textSecondaryDark),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(
              'Cancel',
              style: TextStyle(color: Pallets.textSecondaryDark),
            ),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.redAccent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: const Text(
              'Discard',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
    return discard ?? false;
  }

  @override
  Widget build(BuildContext context) {
    final isUpdating =
        ref.watch(companyProvider).valueOrNull?.isUpdating ?? false;

    // ── FIX: PopScope replaces deprecated WillPopScope ────────────────────
    return PopScope(
      canPop: !_hasChanges,
      onPopInvoked: (didPop) async {
        if (didPop) return;
        if (await _confirmDiscard() && mounted) context.pop();
      },
      child: Scaffold(
        backgroundColor: Pallets.backgroundDark,
        body: CustomScrollView(
          slivers: [
            // ── SliverAppBar with banner ───────────────────────────────
            SliverAppBar(
              expandedHeight: 220,
              pinned: true,
              backgroundColor: Pallets.surfaceDark,
              automaticallyImplyLeading: false,
              // ── Custom arrowhead back button ─────────────────────────
              leading: _BackButton(onTap: () async {
                if (await _confirmDiscard() && context.mounted) context.pop();
              }),
              title: const Text(
                'Edit Company',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
              actions: [
                Padding(
                  padding: const EdgeInsets.only(right: 12),
                  child: TextButton(
                    onPressed: isUpdating ? null : _save,
                    style: TextButton.styleFrom(
                      backgroundColor: _hasChanges
                          ? Pallets.gradient2
                          : Pallets.gradient2.withOpacity(0.4),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                    ),
                    child: isUpdating
                        ? const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                        : const Text(
                            'Save',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                  ),
                ),
              ],
              flexibleSpace: FlexibleSpaceBar(
                background: Stack(
                  fit: StackFit.expand,
                  children: [
                    _pendingBanner != null
                        ? Image.file(_pendingBanner!, fit: BoxFit.cover)
                        : widget.company.bannerUrl != null
                            ? Image.network(
                                widget.company.bannerUrl!,
                                fit: BoxFit.cover,
                              )
                            : Container(color: Pallets.surfaceDark),
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            Colors.black.withOpacity(0.6),
                          ],
                        ),
                      ),
                    ),
                    Center(
                      child: GestureDetector(
                        onTap: () => _pickImage(isLogo: false),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.5),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: Colors.white24),
                          ),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.add_photo_alternate_outlined,
                                color: Colors.white,
                                size: 18,
                              ),
                              SizedBox(width: 8),
                              Text(
                                'Add Banner',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // ── Body ──────────────────────────────────────────────────
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // ── Logo picker ────────────────────────────────
                      Row(
                        children: [
                          GestureDetector(
                            onTap: () => _pickImage(isLogo: true),
                            child: Stack(
                              children: [
                                Container(
                                  width: 80,
                                  height: 80,
                                  decoration: BoxDecoration(
                                    color: Pallets.surfaceDark,
                                    borderRadius: BorderRadius.circular(18),
                                    border: Border.all(
                                      color: Pallets.borderDark,
                                      width: 3,
                                    ),
                                    image: _pendingLogo != null
                                        ? DecorationImage(
                                            image: FileImage(_pendingLogo!),
                                            fit: BoxFit.cover,
                                          )
                                        : widget.company.logoUrl != null
                                            ? DecorationImage(
                                                image: NetworkImage(
                                                  widget.company.logoUrl!,
                                                ),
                                                fit: BoxFit.cover,
                                              )
                                            : null,
                                  ),
                                  child: (_pendingLogo == null &&
                                          widget.company.logoUrl == null)
                                      ? Icon(
                                          Icons.business_rounded,
                                          color: Pallets.textSecondaryDark,
                                          size: 32,
                                        )
                                      : null,
                                ),
                                Positioned(
                                  bottom: 0,
                                  right: 0,
                                  child: Container(
                                    padding: const EdgeInsets.all(5),
                                    decoration: BoxDecoration(
                                      color: Pallets.gradient2,
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(
                                        color: Pallets.backgroundDark,
                                        width: 2,
                                      ),
                                    ),
                                    child: const Icon(
                                      Icons.camera_alt_rounded,
                                      color: Colors.white,
                                      size: 12,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Company Logo',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Tap to change logo image',
                                  style: TextStyle(
                                    color: Pallets.textSecondaryDark,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 24),
                      Divider(color: Pallets.borderDark),
                      const SizedBox(height: 20),

                      _Field(
                        controller: _nameCtrl,
                        label: 'Company Name',
                        icon: Icons.business_outlined,
                        validator: (v) =>
                            v!.trim().isEmpty ? 'Required' : null,
                      ),
                      _Field(
                        controller: _emailCtrl,
                        label: 'Email',
                        icon: Icons.email_outlined,
                        keyboardType: TextInputType.emailAddress,
                      ),
                      _Field(
                        controller: _phoneCtrl,
                        label: 'Phone',
                        icon: Icons.phone_outlined,
                        keyboardType: TextInputType.phone,
                      ),
                      _Field(
                        controller: _addressCtrl,
                        label: 'Address',
                        icon: Icons.location_on_outlined,
                      ),
                      _Field(
                        controller: _tzCtrl,
                        label: 'Timezone',
                        icon: Icons.public_outlined,
                        hint: 'e.g. Asia/Phnom_Penh',
                      ),
                      _Field(
                        controller: _currCtrl,
                        label: 'Currency',
                        icon: Icons.attach_money_rounded,
                        hint: 'e.g. USD, KHR',
                      ),

                      const SizedBox(height: 32),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Custom arrowhead back button ──────────────────────────────────────────────

class _BackButton extends StatelessWidget {
  final VoidCallback onTap;
  const _BackButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Center(
        child: Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: Pallets.surfaceDark,
            borderRadius: BorderRadius.circular(11),
            border: Border.all(color: Pallets.borderDark),
          ),
          child: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Colors.white,
            size: 16,
          ),
        ),
      ),
    );
  }
}

// ── Text field ────────────────────────────────────────────────────────────────

class _Field extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final IconData icon;
  final String? hint;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;

  const _Field({
    required this.controller,
    required this.label,
    required this.icon,
    this.hint,
    this.keyboardType,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        validator: validator,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          prefixIcon:
              Icon(icon, color: Pallets.textSecondaryDark, size: 20),
          labelStyle: TextStyle(color: Pallets.textSecondaryDark),
          hintStyle: TextStyle(
            color: Pallets.textSecondaryDark.withOpacity(0.5),
          ),
          filled: true,
          fillColor: Pallets.surfaceDark,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Pallets.borderDark),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Pallets.borderDark),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Pallets.gradient2, width: 1.5),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.redAccent),
          ),
        ),
      ),
    );
  }
}