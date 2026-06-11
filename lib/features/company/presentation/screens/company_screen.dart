import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontendmobile/core/themes/app_pallets.dart';
import 'package:frontendmobile/features/company/presentation/widgets/card/user_state_card.dart';
import 'package:frontendmobile/features/users/presentation/provider/user_notifier.dart';
import 'package:go_router/go_router.dart';
import '../providers/company_provider.dart';
import '../widgets/company_info_card.dart';
import '../widgets/company_register_form.dart';

class CompanyScreen extends ConsumerStatefulWidget {
  final int companyId;
  const CompanyScreen({super.key, required this.companyId});

  @override
  ConsumerState<CompanyScreen> createState() => _CompanyScreenState();
}

class _CompanyScreenState extends ConsumerState<CompanyScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(companyProvider.notifier).fetchCompany(widget.companyId);
    });
  }

  ////////////////////////////////////////////////////////////////////////////
  ///
  ///////////////////////////////////////////////////////////////////////////

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(companyProvider);

    return Scaffold(
      backgroundColor: Pallets.backgroundDark,
      appBar: AppBar(
        backgroundColor: Pallets.surfaceDark,
        elevation: 0,
        centerTitle: false,
        ////////////////////////////////////////////////////////////////////////
        ///  back button
        ////////////////////////////////////////////////////////////////////////
        leading: const BackButton(),
        title: const Text(
          'Company',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
        ),
        ////////////////////////////////////////////////////////////////////////
        /// get data
        ////////////////////////////////////////////////////////////////////////
        actions: [
          state.maybeWhen(
            data: (data) => data.company != null
                ? Padding(
                    padding: const EdgeInsets.only(right: 12),
                    child: IconButton(
                      icon: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Pallets.gradient2.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: Pallets.gradient2.withOpacity(0.3),
                          ),
                        ),
                        child: Icon(
                          Icons.edit_outlined,
                          color: Pallets.gradient2,
                          size: 18,
                        ),
                      ),

                      onPressed: () => context.push(
                        '/companies/${widget.companyId}/edit',
                        extra: data.company!,
                      ),
                    ),
                  )
                : const SizedBox.shrink(),
            orElse: () => const SizedBox.shrink(),
          ),
        ],

        ////////////////////////////////////////////////////////////////////////
        ///  Register Button
        ////////////////////////////////////////////////////////////////////////
      ),
      body: _buildBody(state),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Pallets.gradient2,
        onPressed: _showRegisterSheet,
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text(
          'Register',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }

  ////////////////////////////////////////////////////////////////////////
  ///  Body
  ////////////////////////////////////////////////////////////////////////

  Widget _buildBody(AsyncValue state) {
    final userAsync = ref.watch(userNotifierProvider);
    return state.when(
      /////////////////////////////////////////////////////////////////
      ///  loading
      ////////////////////////////////////////////////////////////////
      loading: () => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(color: Pallets.gradient2),
            const SizedBox(height: 16),
            Text(
              'Loading...',
              style: TextStyle(color: Pallets.textSecondaryDark),
            ),
          ],
        ),
      ),

      ///////////////////////////////////////////////////////////////
      ///  error
      //////////////////////////////////////////////////////////////
      error: (error, _) => Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 72,
                height: 72,
                decoration: BoxDecoration(
                  color: Colors.redAccent.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Icon(
                  Icons.error_outline,
                  color: Colors.redAccent,
                  size: 36,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Something went wrong',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                error.toString(),
                style: TextStyle(
                  color: Pallets.textSecondaryDark,
                  fontSize: 13,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: () => ref
                    .read(companyProvider.notifier)
                    .fetchCompany(widget.companyId),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Pallets.gradient2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                icon: const Icon(
                  Icons.refresh_rounded,
                  color: Colors.white,
                  size: 18,
                ),
                label: const Text(
                  'Retry',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),

      ////////////////////////////////////////////////////////////////////
      ///  Data
      ///////////////////////////////////////////////////////////////////
      data: (companyState) {
        final company = companyState.company;
        if (company == null) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 72,
                  height: 72,
                  decoration: BoxDecoration(
                    color: Pallets.surfaceDark,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Pallets.borderDark),
                  ),
                  child: Icon(
                    Icons.business_outlined,
                    color: Pallets.textSecondaryDark,
                    size: 36,
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'No company found',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Register a new company to get started',
                  style: TextStyle(
                    color: Pallets.textSecondaryDark,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          );
        }

        ///////////////////////////////////////////////////////////////////////
        ///
        //////////////////////////////////////////////////////////////////////
        final users = userAsync.maybeWhen(
          data: (userState) => userState.users
              .map(
                (u) => StaffPreview(
                  userId: u.id,
                  name: u.staff?.name ?? u.fullName,
                  roleName: u.staff?.staffRole?.roleName ?? u.roleName ?? '',
                  avatarUrl: u.staff?.avatarUrl ?? u.avatarUrl,
                  status: u.status,
                ),
              )
              .toList(),
          orElse: () => <StaffPreview>[],
        );

        //  final currentUserId = userAsync.maybeWhen(
        //   data: (s) => s.users.isNotEmpty ? s.users.first.id : null,
        //   orElse: () => null,
        // );

        // final users = userAsync.maybeWhen(
        //   data: (userState) => userState.users
        //       .where((u) => u.id != currentUserId)
        //       .map(
        //         (u) => StaffPreview(
        //           userId: u.id,
        //           name: u.staff?.name ?? u.fullName,
        //           roleName: u.staff?.staffRole?.roleName ?? u.roleName ?? '',
        //           avatarUrl: u.staff?.avatarUrl ?? u.avatarUrl,
        //           status: u.status,
        //         ),
        //       )
        //       .toList(),
        //   orElse: () => <StaffPreview>[],
        // );

        /////////////////////////////////////////////////////////////////////
        ///
        ////////////////////////////////////////////////////////////////////

        return RefreshIndicator(
          color: Pallets.gradient2,
          backgroundColor: Pallets.surfaceDark,
          onRefresh: () =>
              ref.read(companyProvider.notifier).fetchCompany(widget.companyId),
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(16),
            child: CompanyInfoCard(company: company, users: users),
          ),
        );
      },
    );
  }

  ////////////////////////////////////////////////////////////////////////
  /// Show Register
  ////////////////////////////////////////////////////////////////////////

  void _showRegisterSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Pallets.surfaceDark,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => CompanyRegisterForm(
        onSubmit:
            ({
              required String companyCode,
              required String companyName,
              required String currency,
              required String email,
              required int maxUsers,
              required String timezone,
              String planType = 'free',
            }) async {
              Navigator.pop(context);
              await ref
                  .read(companyProvider.notifier)
                  .registerCompany(
                    companyCode: companyCode,
                    companyName: companyName,
                    currency: currency,
                    email: email,
                    maxUsers: maxUsers,
                    timezone: timezone,
                    planType: planType,
                  );
            },
      ),
    );
  }
}
