import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontendmobile/core/extensions/user_info_extensions.dart';
import 'package:frontendmobile/core/themes/app_pallets.dart';
import 'package:frontendmobile/features/auth/presentation/providers/auth_provider.dart';
import 'package:frontendmobile/features/company/presentation/widgets/card/user_state_card.dart';
import 'package:frontendmobile/features/hr/staff/presentation/providers/staff_notifier.dart';
import 'package:go_router/go_router.dart';
import '../providers/company_provider.dart';
import '../widgets/company_info_card.dart';

////////////////////////////////////////////////////////////////////////////////
///
////////////////////////////////////////////////////////////////////////////////

class CompanyScreen extends ConsumerStatefulWidget {
  final int companyId;
  const CompanyScreen({super.key, required this.companyId});
  @override
  ConsumerState<CompanyScreen> createState() => _CompanyScreenState();
}

////////////////////////////////////////////////////////////////////////////////
///
////////////////////////////////////////////////////////////////////////////////

class _CompanyScreenState extends ConsumerState<CompanyScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _fadeCtrl;
  late final Animation<double> _fadeAnim;

  @override
  void initState() {
    super.initState();
    _fadeCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 380),
    );
    _fadeAnim = CurvedAnimation(parent: _fadeCtrl, curve: Curves.easeOut);

    Future.microtask(() {
      ref.read(companyProvider.notifier).fetchCompany(widget.companyId);
    });
  }

  //////////////////////////////////////////////////////////////////////////////
  ///
  //////////////////////////////////////////////////////////////////////////////

  @override
  void dispose() {
    _fadeCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(companyProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final bg = isDark ? Pallets.backgroundDark : Pallets.backgroundLight;
    final surface = isDark ? Pallets.surfaceDark : Pallets.surfaceLight;
    final border = isDark ? Pallets.borderDark : Pallets.borderLight;
    final currentUser = ref.watch(currentUserProvider);
    final canManageCompany = currentUser?.canManageCompany ?? false;
    return Scaffold(
      backgroundColor: bg,

      ////////////////////////////////
      ///
      ////////////////////////////////
      appBar: AppBar(
        backgroundColor: surface,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            color: isDark ? Pallets.textPrimaryDark : Pallets.textPrimaryLight,
            size: 18,
          ),
          onPressed: () => Navigator.of(context).maybePop(),
        ),
        title: Text(
          'Company',
          style: TextStyle(
            color: isDark ? Pallets.textPrimaryDark : Pallets.textPrimaryLight,
            fontWeight: FontWeight.w600,
            fontSize: 16,
            letterSpacing: -0.3,
          ),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(height: 1, color: border),
        ),

        actions: [
          if (canManageCompany)
            state.maybeWhen(
              data: (data) => data.company != null
                  ? Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: _EditButton(
                        onTap: () => context.push(
                          '/companies/${widget.companyId}/edit',
                          extra: data.company!,
                        ),
                      ),
                    )
                  : const SizedBox.shrink(),
              orElse: () => const SizedBox.shrink(),
            ),
        ],
      ),

      ////////////////////////////////////
      ///
      ///////////////////////////////////
      body: _buildBody(state),
      floatingActionButton: _RegisterFab(
        onTap: () => context.push('/companies/register'),
      ),
    );
  }

  Widget _buildBody(AsyncValue state) {
    final staffAsync = ref.watch(staffNotifierProvider);

    ref.watch(staffNotifierProvider);

    return state.when(
      loading: () => const _LoadingState(),
      error: (error, _) => _ErrorState(
        message: error.toString(),
        onRetry: () =>
            ref.read(companyProvider.notifier).fetchCompany(widget.companyId),
      ),
      data: (companyState) {
        final company = companyState.company;
        if (company == null) return const _EmptyState();

        final users = staffAsync.maybeWhen(
          data: (staffList) => staffList
              .map(
                (s) => StaffPreview(
                  userId: s.userId ?? s.id ?? 0,
                  name: s.name,
                  roleName: s.staffRole?.roleName ?? '',
                  avatarUrl: s.avatarUrl,
                ),
              )
              .toList(),
          orElse: () => <StaffPreview>[],
        );

        _fadeCtrl.forward();
        return RefreshIndicator(
          color: Pallets.blurple,
          backgroundColor: Theme.of(context).brightness == Brightness.dark
              ? Pallets.surfaceCard
              : Pallets.surfaceLight,
          onRefresh: () =>
              ref.read(companyProvider.notifier).fetchCompany(widget.companyId),
          child: FadeTransition(
            opacity: _fadeAnim,
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
              child: CompanyInfoCard(company: company, users: users),
            ),
          ),
        );
      },
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Edit button
// ─────────────────────────────────────────────────────────────────────────────
class _EditButton extends StatelessWidget {
  final VoidCallback onTap;
  const _EditButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 10),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: Pallets.blurple.withOpacity(0.12),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Pallets.blurple.withOpacity(0.3)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.edit_outlined, color: Pallets.blurple, size: 14),
            const SizedBox(width: 5),
            Text(
              'Edit',
              style: TextStyle(
                color: Pallets.blurple,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Register FAB
// ─────────────────────────────────────────────────────────────────────────────
class _RegisterFab extends StatelessWidget {
  final VoidCallback onTap;
  const _RegisterFab({required this.onTap});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 48,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
          gradient: Pallets.brandGradient,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: Pallets.blurple.withOpacity(0.35),
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: const [
            Icon(Icons.add_rounded, color: Pallets.onAccent, size: 18),
            SizedBox(width: 6),
            Text(
              'Register',
              style: TextStyle(
                color: Pallets.onAccent,
                fontWeight: FontWeight.w700,
                fontSize: 14,
                letterSpacing: -0.2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Loading state
// ─────────────────────────────────────────────────────────────────────────────
class _LoadingState extends StatelessWidget {
  const _LoadingState();

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 36,
            height: 36,
            child: CircularProgressIndicator(
              color: Pallets.blurple,
              strokeWidth: 2.5,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Loading company…',
            style: TextStyle(
              color: isDark
                  ? Pallets.textSecondaryDark
                  : Pallets.textSecondaryLight,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Error state
// ─────────────────────────────────────────────────────────────────────────────
class _ErrorState extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;
  const _ErrorState({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: Pallets.errorTint,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: Pallets.error.withOpacity(0.25)),
              ),
              child: const Icon(
                Icons.error_outline_rounded,
                color: Pallets.error,
                size: 28,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Something went wrong',
              style: TextStyle(
                color: isDark
                    ? Pallets.textPrimaryDark
                    : Pallets.textPrimaryLight,
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              message,
              style: TextStyle(
                color: isDark
                    ? Pallets.textSecondaryDark
                    : Pallets.textSecondaryLight,
                fontSize: 12,
              ),
              textAlign: TextAlign.center,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 24),
            GestureDetector(
              onTap: onRetry,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: Pallets.blurple.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Pallets.blurple.withOpacity(0.3)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    Icon(
                      Icons.refresh_rounded,
                      color: Pallets.blurple,
                      size: 16,
                    ),
                    SizedBox(width: 6),
                    Text(
                      'Try again',
                      style: TextStyle(
                        color: Pallets.blurple,
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Empty state
// ─────────────────────────────────────────────────────────────────────────────
class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: isDark ? Pallets.surfaceCard : Pallets.backgroundLight,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(
                color: isDark ? Pallets.borderDark : Pallets.borderLight,
              ),
            ),
            child: Icon(
              Icons.business_outlined,
              color: isDark
                  ? Pallets.textSecondaryDark
                  : Pallets.textSecondaryLight,
              size: 28,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'No company found',
            style: TextStyle(
              color: isDark
                  ? Pallets.textPrimaryDark
                  : Pallets.textPrimaryLight,
              fontSize: 15,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Register a new company to get started',
            style: TextStyle(
              color: isDark
                  ? Pallets.textSecondaryDark
                  : Pallets.textSecondaryLight,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}
