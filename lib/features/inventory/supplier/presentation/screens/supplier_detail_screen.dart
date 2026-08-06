import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontendmobile/core/themes/app_pallets.dart';
import 'package:frontendmobile/features/inventory/supplier/domain/entities/supplier.dart';
import 'package:frontendmobile/features/inventory/supplier/presentation/widgets/supplier_form_screen.dart';
import 'package:frontendmobile/features/inventory/supplier/presentation/widgets/supplier_info_tile.dart';
import 'package:frontendmobile/features/inventory/supplier/presentation/widgets/supplier_price_in_line_list.dart';
import 'package:frontendmobile/features/inventory/supplier_product_price/presentation/screens/supplier_product_price_list_screen.dart';
import 'package:frontendmobile/features/inventory/product/presentation/providers/product_provider.dart';
import '../providers/supplier_provider.dart';

////////////////////////////////////////////////////////////////////////////////
///
////////////////////////////////////////////////////////////////////////////////

class SupplierDetailScreen extends ConsumerStatefulWidget {
  final int supplierId;
  const SupplierDetailScreen({super.key, required this.supplierId});
  @override
  ConsumerState<SupplierDetailScreen> createState() =>
      _SupplierDetailScreenState();
}

////////////////////////////////////////////////////////////////////////////////
///
////////////////////////////////////////////////////////////////////////////////

class _SupplierDetailScreenState extends ConsumerState<SupplierDetailScreen> {
  //////////////////////////////////////////////////////////////////////////////
  ///
  //////////////////////////////////////////////////////////////////////////////
  @override
  void initState() {
    super.initState();
    Future.microtask(() => ref.read(variantLabelsProvider.future));
  }

  //////////////////////////////////////////////////////////////////////////////
  ///
  //////////////////////////////////////////////////////////////////////////////
  void _openEdit(SupplierEntity supplier) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => SupplierFormScreen(existing: supplier)),
    );
  }

  //////////////////////////////////////////////////////////////////////////////
  ///  GO CREATE SUPPLIER PRODUCT NOTED
  //////////////////////////////////////////////////////////////////////////////
  void _openAddPrice(SupplierEntity supplier) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => SupplierProductPriceListScreen(
          supplierId: supplier.supplierId,
          supplierNames: {supplier.supplierId: supplier.name},
          variantLabels: ref.read(variantLabelsProvider).value ?? {},
        ),
      ),
    );
  }

  //////////////////////////////////////////////////////////////////////////////
  ///
  //////////////////////////////////////////////////////////////////////////////
  String _initials(String name) {
    final parts = name.trim().split(RegExp(r'\s+'));
    if (parts.isEmpty || parts.first.isEmpty) return '?';
    if (parts.length == 1) return parts.first.substring(0, 1).toUpperCase();
    return (parts.first.substring(0, 1) + parts.last.substring(0, 1))
        .toUpperCase();
  }
  //////////////////////////////////////////////////////////////////////////////
  ///
  //////////////////////////////////////////////////////////////////////////////

  @override
  Widget build(BuildContext context) {
    ////////////////////////////////////////////////////////////////////////////
    ///
    ////////////////////////////////////////////////////////////////////////////

    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final bg = isDark ? Pallets.backgroundDark : Pallets.backgroundLight;
    final surface = isDark ? Pallets.surfaceCard : Pallets.surfaceLight;
    final border = isDark ? Pallets.borderDark : Pallets.borderLight;
    final textPrimary = isDark
        ? Pallets.textPrimaryDark
        : Pallets.textPrimaryLight;
    final textSecondary = isDark
        ? Pallets.textSecondaryDark
        : Pallets.textSecondaryLight;
    final state = ref.watch(supplierNotifierProvider);
    final supplier = state.suppliers.cast<SupplierEntity?>().firstWhere(
      (s) => s?.supplierId == widget.supplierId,
      orElse: () => null,
    );

    ////////////////////////////////////////////////////////////////////////////
    ///
    ////////////////////////////////////////////////////////////////////////////

    if (supplier == null) {
      return Scaffold(
        backgroundColor: bg,
        appBar: AppBar(
          backgroundColor: bg,
          elevation: 0,
          title: Text('Detail view', style: TextStyle(color: textPrimary)),
        ),
        body: Center(
          child: Text(
            'Supplier not found or has been removed.',
            style: TextStyle(color: textSecondary),
          ),
        ),
      );
    }

    ////////////////////////////////////////////////////////////////////////////
    ///
    ////////////////////////////////////////////////////////////////////////////

    final isWorking = state.loadingIds.contains(supplier.supplierId);

    ////////////////////////////////////////////////////////////////////////////
    ///
    ////////////////////////////////////////////////////////////////////////////

    return Scaffold(
      backgroundColor: bg,
      extendBodyBehindAppBar: true,

      /////////////////////////////////////////////////////
      ///
      ////////////////////////////////////////////////////
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.white,
        title: const Text(''),

        actions: [
          if (!isWorking)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: TextButton.icon(
                onPressed: () => _openEdit(supplier),
                icon: const Icon(Icons.edit_outlined, size: 15),
                label: const Text('Edit', style: TextStyle(fontSize: 13)),
                style: TextButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.white.withOpacity(0.18),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 6,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                    side: BorderSide(color: Colors.white.withOpacity(0.25)),
                  ),
                ),
              ),
            ),
        ],
      ),

      /////////////////////////////////////////////////////
      ///
      ////////////////////////////////////////////////////
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ////////////////////////////////////////////////////////////////////
            // ── Gradient hero header ─────────────────────────────────
            ////////////////////////////////////////////////////////////////////
            Container(
              width: double.infinity,
              decoration: const BoxDecoration(gradient: Pallets.brandGradient),
              padding: EdgeInsets.fromLTRB(
                24,
                MediaQuery.of(context).padding.top + 56,
                24,
                36,
              ),
              child: Column(
                children: [
                  Container(
                    width: 96,
                    height: 96,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white.withOpacity(0.16),
                      border: Border.all(
                        color: Colors.white.withOpacity(0.35),
                        width: 2,
                      ),
                    ),
                    alignment: Alignment.center,
                    child: supplier.avatarUrl != null
                        ? ClipOval(
                            child: Image.network(
                              supplier.avatarUrl!,
                              width: 92,
                              height: 92,
                              fit: BoxFit.cover,
                            ),
                          )
                        : Text(
                            _initials(supplier.name),
                            style: const TextStyle(
                              fontSize: 32,
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    supplier.name,
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  if (supplier.contactPerson != null &&
                      supplier.contactPerson!.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text(
                      supplier.contactPerson!,
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.85),
                        fontSize: 13.5,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ],
              ),
            ),

            ////////////////////////////////////////////////////////////////////
            // ── Info card ────────────────────────────────────────────
            ////////////////////////////////////////////////////////////////////
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
              child: Container(
                decoration: BoxDecoration(
                  color: surface,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: border),
                ),
                child: Column(
                  children: [
                    InfoTile(
                      icon: Icons.person_outline,
                      label: 'Contact person',
                      value: supplier.contactPerson,
                      textPrimary: textPrimary,
                      textSecondary: textSecondary,
                    ),
                    Divider(height: 1, color: border, indent: 56),
                    InfoTile(
                      icon: Icons.call_outlined,
                      label: 'Phone',
                      value: supplier.phone,
                      textPrimary: textPrimary,
                      textSecondary: textSecondary,
                    ),
                    if (supplier.phone2 != null) ...[
                      Divider(height: 1, color: border, indent: 56),
                      InfoTile(
                        icon: Icons.call_outlined,
                        label: 'Phone 2',
                        value: supplier.phone2,
                        textPrimary: textPrimary,
                        textSecondary: textSecondary,
                      ),
                    ],
                    Divider(height: 1, color: border, indent: 56),
                    InfoTile(
                      icon: Icons.mail_outline_rounded,
                      label: 'Email',
                      value: supplier.email,
                      textPrimary: textPrimary,
                      textSecondary: textSecondary,
                    ),
                    Divider(height: 1, color: border, indent: 56),
                    InfoTile(
                      icon: Icons.location_on_outlined,
                      label: 'Address',
                      value: supplier.address,
                      maxLines: 3,
                      textPrimary: textPrimary,
                      textSecondary: textSecondary,
                    ),
                  ],
                ),
              ),
            ),

            ////////////////////////////////////////////////////////////////////
            // ── Prices section header ────────────────────────────────
            ////////////////////////////////////////////////////////////////////
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 8, 16, 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ///////////////
                  ///
                  //////////////
                  Text(
                    'SUPPLIER PRICES',
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: textSecondary,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.7,
                    ),
                  ),
                  ///////////////
                  ///
                  //////////////
                  TextButton.icon(
                    onPressed: () => _openAddPrice(supplier),
                    icon: const Icon(Icons.add_rounded, size: 16),
                    label: const Text('Add', style: TextStyle(fontSize: 13)),
                    style: TextButton.styleFrom(
                      foregroundColor: Pallets.blurple,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                    ),
                  ),
                  ///////////////
                  ///
                  //////////////
                ],
              ),
            ),

            ////////////////////////////////////////////////////////////////////
            // ── Inline prices list ────────────────────────────────────
            ////////////////////////////////////////////////////////////////////
            SupplierPriceInlineList(
              supplierId: supplier.supplierId,
              supplierName: supplier.name,
              onManage: () => _openAddPrice(supplier),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
