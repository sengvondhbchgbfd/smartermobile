import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontendmobile/core/themes/app_pallets.dart';
import 'package:frontendmobile/core/widgets/alertmessage/app_snacker.dart';
import 'package:frontendmobile/core/widgets/shimmer/app_list_shimmer.dart';
import 'package:frontendmobile/features/inventory/customer/presentation/widgets/customer_detail/custom_info_row.dart'
    show InfoRow, InfoCard;
import 'package:frontendmobile/features/inventory/customer/presentation/widgets/customer_detail/invoice_tile.dart';
import 'package:frontendmobile/features/inventory/customer/presentation/widgets/customer_detail/section_label.dart'
    show SectionLabel;
import 'package:frontendmobile/features/inventory/customer/presentation/widgets/customer_detail/state_card.dart'
    show StatCard;
import 'package:intl/intl.dart';
import '../../domain/entities/customer_entity.dart';
import '../../../invoice/presentation/providers/invoice_providers.dart';
import '../providers/customer_provider.dart';
import '../widgets/customer_create_page.dart';

////////////////////////////////////////////////////////////////////////////////
///
////////////////////////////////////////////////////////////////////////////////

class CustomerDetailScreen extends ConsumerStatefulWidget {
  final int customerId;
  const CustomerDetailScreen({super.key, required this.customerId});

  @override
  ConsumerState<CustomerDetailScreen> createState() =>
      _CustomerDetailScreenState();
}
////////////////////////////////////////////////////////////////////////////////
///
////////////////////////////////////////////////////////////////////////////////

class _CustomerDetailScreenState extends ConsumerState<CustomerDetailScreen> {
  @override
  //////////////////////////////////////////////////////////////////////////////
  ///
  //////////////////////////////////////////////////////////////////////////////
  void initState() {
    super.initState();
    Future.microtask(() {
      ref
          .read(invoiceNotifierProvider.notifier)
          .loadAll(customerId: widget.customerId);
    });
  }

  //////////////////////////////////////////////////////////////////////////////
  ///
  //////////////////////////////////////////////////////////////////////////////

  Future<void> _openEdit(CustomerEntity customer) async {
    final result = await Navigator.of(context).push<Map<String, dynamic>>(
      MaterialPageRoute(builder: (_) => CustomerCreatePage(existing: customer)),
    );
    if (result == null || !mounted) return;
    final ok = await ref
        .read(customerNotifierProvider.notifier)
        .update(
          customerId: widget.customerId,
          name: result['name'],
          phone: result['phone'],
          email: result['email'],
          avatar: result['avatar'],
        );
    if (!mounted) return;
    AppSnackBar.show(
      context,
      message: ok
          ? 'Customer updated successfully.'
          : 'Failed to update customer.',
      type: ok ? SnackType.success : SnackType.error,
    );
  }
  //////////////////////////////////////////////////////////////////////////////
  ///
  //////////////////////////////////////////////////////////////////////////////

  @override
  Widget build(BuildContext context) {
    ////////////////////////////////////////////////////////////////////////////
    /// Theme-aware palette wiring
    ////////////////////////////////////////////////////////////////////////////

    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = isDark ? Pallets.backgroundDark : Pallets.backgroundLight;
    final cardBg = isDark ? Pallets.surfaceCard : Pallets.surfaceLight;
    final borderColor = isDark ? Pallets.borderDark : Pallets.borderLight;
    final textPrimary = isDark
        ? Pallets.textPrimaryDark
        : Pallets.textPrimaryLight;
    final textSecondary = isDark
        ? Pallets.textSecondaryDark
        : Pallets.textSecondaryLight;

    final customer = ref
        .watch(customerNotifierProvider)
        .customers
        .cast<CustomerEntity?>()
        .firstWhere(
          (c) => c?.customerId == widget.customerId,
          orElse: () => null,
        );

    ///////////////////////////////////////

    final invoiceState = ref.watch(invoiceNotifierProvider);

    if (customer == null) {
      return Scaffold(
        backgroundColor: bg,
        appBar: AppBar(
          backgroundColor: cardBg,
          title: Text('Customer detail', style: TextStyle(color: textPrimary)),
        ),
        // ✅ not-found message, not a loading shimmer
        body: Center(
          child: Text(
            'Customer not found or has been removed.',
            style: TextStyle(color: textSecondary),
          ),
        ),
      );
    }

    final initials = _initials(customer.name);
    final avatarBg = _avatarBg(customer.name, isDark);
    final avatarFg = _avatarFg(customer.name, isDark);
    final fmt = DateFormat('MMM d, yyyy');
    final currencyFmt = NumberFormat.currency(symbol: '\$', decimalDigits: 2);
    final invoices = invoiceState.invoices;

    ////////////////////////////////////////////////////////////////////////////
    ///
    ////////////////////////////////////////////////////////////////////////////

    return Scaffold(
      backgroundColor: bg,

      //////////////////////////////////////////////////////////////////////////
      ///
      //////////////////////////////////////////////////////////////////////////
      appBar: AppBar(
        backgroundColor: cardBg,
        elevation: 0,
        surfaceTintColor: Pallets.transparent,
        ////////////////////////////////////////////////////////////////////////
        ///
        ////////////////////////////////////////////////////////////////////////
        leading: IconButton(
          icon: Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: isDark ? Pallets.surfaceElevated : Pallets.backgroundLight,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.arrow_back_ios_new_rounded,
              size: 16,
              color: textPrimary,
            ),
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),

        ////////////////////////////////////////////////////////////////////////
        //
        ////////////////////////////////////////////////////////////////////////
        title: Text(
          customer.name,
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w500,
            color: textPrimary,
          ),
        ),

        ////////////////////////////////////////////////////////////////////////
        ///
        ////////////////////////////////////////////////////////////////////////
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: TextButton.icon(
              onPressed: () => _openEdit(customer),
              icon: const Icon(Icons.edit_outlined, size: 15),
              label: const Text('Edit', style: TextStyle(fontSize: 13)),
              style: TextButton.styleFrom(
                foregroundColor: Pallets.blurple,
                backgroundColor: Pallets.infoTint,
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 6,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
        ],
        ////////////////////////////////////////////////////////////////////////
        ///
        ////////////////////////////////////////////////////////////////////////
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(0.5),
          child: Divider(
            height: 0.5,
            thickness: 0.5,
            color: isDark ? Pallets.dividerDark : Pallets.dividerLight,
          ),
        ),
      ),

      //////////////////////////////////////////////////////////////////////////
      ///
      //////////////////////////////////////////////////////////////////////////
      body: ListView(
        children: [
          // ── Hero ───────────────────────────────────────────────────────────
          Container(
            color: cardBg,
            padding: const EdgeInsets.symmetric(vertical: 28),
            child: Column(
              children: [
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: customer.avatarUrl != null
                        ? Pallets.transparent
                        : avatarBg,
                  ),
                  child: customer.avatarUrl != null
                      ? ClipOval(
                          child: Image.network(
                            customer.avatarUrl!,
                            fit: BoxFit.cover,
                            // ✅ graceful fallback if the image fails to load
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                color: avatarBg,
                                child: Center(
                                  child: Text(
                                    initials,
                                    style: TextStyle(
                                      fontSize: 26,
                                      fontWeight: FontWeight.w500,
                                      color: avatarFg,
                                    ),
                                  ),
                                ),
                              );
                            },
                            loadingBuilder: (context, child, progress) {
                              if (progress == null) return child;
                              return Container(
                                color: avatarBg,
                                child: Center(
                                  child: SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: avatarFg,
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        )
                      : Center(
                          child: Text(
                            initials,
                            style: TextStyle(
                              fontSize: 26,
                              fontWeight: FontWeight.w500,
                              color: avatarFg,
                            ),
                          ),
                        ),
                ),
                const SizedBox(height: 12),
                Text(
                  customer.name,
                  style: TextStyle(
                    fontSize: 19,
                    fontWeight: FontWeight.w500,
                    color: textPrimary,
                  ),
                ),
              ],
            ),
          ),
          Divider(
            height: 0.5,
            thickness: 0.5,
            color: isDark ? Pallets.dividerDark : Pallets.dividerLight,
          ),

          // ── Stats ──────────────────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: StatCard(
                    label: 'Total purchase',
                    // ✅ fixed: proper currency formatting w/ thousands separator + cents
                    value: currencyFmt.format(customer.totalPurchase),
                    cardBg: cardBg,
                    borderColor: borderColor,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: StatCard(
                    label: 'Invoices',
                    value: '${invoices.length}',
                    cardBg: cardBg,
                    borderColor: borderColor,
                  ),
                ),
              ],
            ),
          ),

          // ── Contact info ───────────────────────────────────────────────────
          SectionLabel(label: 'Contact info', textSecondary: textSecondary),
          InfoCard(
            cardBg: cardBg,
            borderColor: borderColor,
            rows: [
              if (customer.phone != null)
                InfoRow(
                  icon: Icons.phone_outlined,
                  label: 'Phone',
                  value: customer.phone!,
                ),
              if (customer.email != null)
                InfoRow(
                  icon: Icons.mail_outline_rounded,
                  label: 'Email',
                  value: customer.email!,
                ),
              if (customer.phone == null && customer.email == null)
                InfoRow(
                  icon: Icons.info_outline_rounded,
                  label: 'Contact',
                  value: 'No contact info',
                ),
            ],
          ),

          // ── Account info ───────────────────────────────────────────────────
          SectionLabel(label: 'Account info', textSecondary: textSecondary),
          InfoCard(
            cardBg: cardBg,
            borderColor: borderColor,
            rows: [
              InfoRow(
                icon: Icons.calendar_today_outlined,
                label: 'Member since',
                value: fmt.format(customer.createdAt),
              ),
              InfoRow(
                icon: Icons.update_rounded,
                label: 'Last updated',
                value: fmt.format(customer.updatedAt),
              ),
            ],
          ),

          // ── Invoices ───────────────────────────────────────────────────────
          SectionLabel(label: 'Invoices', textSecondary: textSecondary),

          if (invoiceState.isLoading)
            const AppListShimmer(itemCount: 1)
          else if (invoices.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: cardBg,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: borderColor, width: 0.5),
                ),
                child: Center(
                  child: Text(
                    'No invoices yet',
                    style: TextStyle(fontSize: 14, color: textSecondary),
                  ),
                ),
              ),
            )
          else
            ...invoices.map(
              (inv) => InvoiceTile(
                invoice: inv,
                cardBg: cardBg,
                borderColor: borderColor,
                fmt: fmt,
              ),
            ),

          const SizedBox(height: 32),
        ],
      ),
    );
  }

  // ✅ fixed: no longer throws on an empty name
  String _initials(String name) {
    final trimmed = name.trim();
    if (trimmed.isEmpty) return '?';
    final parts = trimmed.split(' ').where((p) => p.isNotEmpty).toList();
    if (parts.length >= 2) return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    return trimmed.substring(0, trimmed.length >= 2 ? 2 : 1).toUpperCase();
  }

  // ── Avatar colors now derived from Pallets instead of hardcoded hex ──────
  Color _avatarBg(String name, bool isDark) {
    if (name.isEmpty)
      return isDark ? Pallets.surfaceElevated : Pallets.infoTint;
    final darkColors = [
      Pallets.infoTint,
      Pallets.successTint,
      Pallets.surfaceElevated,
      Pallets.warningTint,
    ];
    final lightColors = [
      Pallets.infoTint,
      Pallets.successTint,
      Pallets.surfaceLight,
      Pallets.warningTint,
    ];
    final colors = isDark ? darkColors : lightColors;
    return colors[name.codeUnitAt(0) % colors.length];
  }

  Color _avatarFg(String name, bool isDark) {
    if (name.isEmpty) return Pallets.textMuted;
    final colors = [
      Pallets.blurple,
      Pallets.success,
      Pallets.blurpleDim,
      Pallets.warning,
    ];
    return colors[name.codeUnitAt(0) % colors.length];
  }
}
