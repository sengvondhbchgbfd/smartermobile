import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/company_provider.dart';
import '../widgets/company_info_card.dart';
import '../widgets/company_edit_form.dart';
import '../widgets/company_register_form.dart';

class CompanyScreen extends ConsumerStatefulWidget {
  final int companyId;

  const CompanyScreen({super.key, required this.companyId});

  @override
  ConsumerState<CompanyScreen> createState() => _CompanyScreenState();
}

////////////////////////////////////////////////////////////////////////
//
////////////////////////////////////////////////////////////////////////
class _CompanyScreenState extends ConsumerState<CompanyScreen> {
  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      ref.read(companyProvider.notifier).fetchCompany(widget.companyId);
    });
  }
  ////////////////////////////////////////////////////////////////////////
  //
  ////////////////////////////////////////////////////////////////////////

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(companyProvider);

    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),

      ////////////////////////////////////////////////////////////////////////
      // ================= APP BAR =================
      ////////////////////////////////////////////////////////////////////////
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E293B),
        title: const Text(
          'Company',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
        ),
        actions: [
          state.maybeWhen(
            data: (data) => data.company != null
                ? IconButton(
                    icon: const Icon(Icons.edit_outlined, color: Colors.white),
                    onPressed: () => _showEditSheet(data.company!),
                  )
                : const SizedBox.shrink(),
            orElse: () => const SizedBox.shrink(),
          ),
        ],
      ),

      ////////////////////////////////////////////////////////////////////////
      // ================= BODY =================
      ////////////////////////////////////////////////////////////////////////
      body: _buildBody(state),

      ///////////////////////////////////////////////////////////////////////
      // ================= FLOATING ACTION BUTTON =================
      ///////////////////////////////////////////////////////////////////////
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF6366F1),
        onPressed: _showRegisterSheet,
        child: const Icon(Icons.add),
      ),
    );
  }
  ///////////////////////////////////////////////////////////////////////
  // ================= BODY =================
  ///////////////////////////////////////////////////////////////////////

  Widget _buildBody(AsyncValue state) {
    return state.when(
      loading: () => const Center(
        child: CircularProgressIndicator(color: Color(0xFF6366F1)),
      ),
      error: (error, _) => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, color: Colors.redAccent, size: 48),
            const SizedBox(height: 12),
            Text(
              error.toString(),
              style: const TextStyle(color: Colors.white70),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => ref
                  .read(companyProvider.notifier)
                  .fetchCompany(widget.companyId),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF6366F1),
              ),
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
      data: (companyState) {
        final company = companyState.company;
        if (company == null) {
          return const Center(
            child: Text(
              "No company found",
              style: TextStyle(color: Colors.white70),
            ),
          );
        }
        return RefreshIndicator(
          color: const Color(0xFF6366F1),
          onRefresh: () =>
              ref.read(companyProvider.notifier).fetchCompany(widget.companyId),
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(16),
            child: CompanyInfoCard(company: company),
          ),
        );
      },
    );
  }
  ///////////////////////////////////////////////////////////////////////
  // ================= EDIT COMPANY =================
  ///////////////////////////////////////////////////////////////////////

  void _showEditSheet(company) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFF1E293B),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
          left: 16,
          right: 16,
          top: 20,
        ),
        child: CompanyEditForm(company: company, companyId: widget.companyId),
      ),
    );
  }
  ///////////////////////////////////////////////////////////////////////
  // ================= REGISTER COMPANY =================
  ///////////////////////////////////////////////////////////////////////

  void _showRegisterSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFF1E293B),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            left: 16,
            right: 16,
            top: 20,
          ),
          child: CompanyRegisterForm(
            onSubmit:
                ({
                  required String companyName,
                  required String companyCode,
                  String? email,
                  String? phone,
                  int? maxUsers,
                  String? timezone,
                  String? currency,
                }) async {
                  Navigator.pop(context);

                  await ref
                      .read(companyProvider.notifier)
                      .registerCompany(
                        companyName: companyName,
                        companyCode: companyCode,
                        email: email,
                        phone: phone,
                        maxUsers: maxUsers,
                        timezone: timezone,
                        currency: currency,
                        username: '',
                        password: '',
                        fullName: '',
                      );
                },
          ),
        );
      },
    );
  }
}
