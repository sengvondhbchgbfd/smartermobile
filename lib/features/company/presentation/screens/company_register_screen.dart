import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontendmobile/core/themes/app_pallets.dart';
import 'package:go_router/go_router.dart';
import '../providers/company_provider.dart';
import '../widgets/form/company_register_form.dart';

class CompanyRegisterScreen extends ConsumerWidget {
  const CompanyRegisterScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg     = isDark ? Pallets.backgroundDark : Pallets.backgroundLight;
    final surf   = isDark ? Pallets.surfaceDark    : Pallets.surfaceLight;
    final border = isDark ? Pallets.borderDark     : Pallets.borderLight;
    final t1     = isDark ? Pallets.textPrimaryDark : Pallets.textPrimaryLight;

    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        backgroundColor: surf,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_rounded, color: t1, size: 18),
          onPressed: () => context.pop(),
        ),
        title: Text(
          'Register Company',
          style: TextStyle(
            color: t1,
            fontWeight: FontWeight.w600,
            fontSize: 16,
            letterSpacing: -0.3,
          ),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(height: 1, color: border),
        ),
      ),
      body: SafeArea(
        child: CompanyRegisterForm(
          onSubmit: ({
            required String companyCode,
            required String companyName,
            required String currency,
            required String email,
            required int maxUsers,
            required String timezone,
            required String adminUsername,     // ← added
            required String adminPassword,     // ← added
            required String adminFullName,     // ← added
            String planType = 'free',
          }) async {
            final ok = await ref.read(companyProvider.notifier).registerCompany(
                  companyCode: companyCode,
                  companyName: companyName,
                  currency: currency,
                  email: email,
                  maxUsers: maxUsers,
                  timezone: timezone,
                  planType: planType,
                  adminUsername: adminUsername,   // ← added
                  adminPassword: adminPassword,    // ← added
                  adminFullName: adminFullName,     // ← added
                );
            // Only pop on success — otherwise the error is silently swallowed
            // and the form closes even though registration failed.
            if (context.mounted && ok) context.pop();
          },
        ),
      ),
    );
  }
}