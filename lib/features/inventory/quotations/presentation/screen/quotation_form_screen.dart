import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontendmobile/features/hr/staff/presentation/providers/staff_notifier.dart';
import 'package:frontendmobile/core/themes/app_pallets.dart';
import 'package:frontendmobile/features/inventory/quotations/presentation/widgets/quotations_form/artwork_delivery_section.dart';
import 'package:frontendmobile/features/inventory/quotations/presentation/widgets/quotations_form/basic_info_section.dart';
import 'package:frontendmobile/features/inventory/quotations/presentation/widgets/quotations_form/dates_production_section.dart';
import 'package:frontendmobile/features/inventory/quotations/presentation/widgets/quotations_form/items_section.dart';
import 'package:frontendmobile/features/inventory/quotations/presentation/widgets/quotations_form/pricing_section.dart';
import 'package:frontendmobile/shared/providers/core_providers.dart';
import '../../domain/entities/quotation_entity.dart';
import '../providers/quotation_form_provider.dart';
import '../widgets/quotation_item_form_sheet.dart';
import 'package:frontendmobile/features/inventory/customer/presentation/providers/customer_provider.dart';

class QuotationFormScreen extends ConsumerStatefulWidget {
  final QuotationEntity? existing;

  const QuotationFormScreen({super.key, this.existing});

  @override
  ConsumerState<QuotationFormScreen> createState() =>
      _QuotationFormScreenState();
}

class _QuotationFormScreenState extends ConsumerState<QuotationFormScreen> {
  late final _refNumberCtrl = TextEditingController(
    text: widget.existing?.refNumber ?? '',
  );
  late final _paymentTermsCtrl = TextEditingController(
    text: widget.existing?.paymentTerms ?? '',
  );
  late final _noteCtrl = TextEditingController(
    text: widget.existing?.note ?? '',
  );
  late final _productionDaysCtrl = TextEditingController(
    text: (widget.existing?.productionDays ?? 1).toString(),
  );
  late final _discountCtrl = TextEditingController(
    text: (widget.existing?.discount ?? 0).toString(),
  );
  late final _taxCtrl = TextEditingController(
    text: (widget.existing?.tax ?? 0).toString(),
  );

  int? _selectedCustomerId;
  String _selectedCustomerLabel = '';
  int? _selectedStaffId;
  String _selectedStaffLabel = '';

  bool _submitting = false;
  bool _customersLoaded = false;
  bool _staffLoaded = false;

  bool get _isEditing => widget.existing != null;

  @override
  void initState() {
    super.initState();
    _selectedCustomerId = widget.existing?.customerId;
    _selectedCustomerLabel = widget.existing?.customerName ?? '';
    _selectedStaffId = widget.existing?.staffId;

    Future.microtask(() async {
      await Future.wait([
        ref.read(customerNotifierProvider.notifier).loadAll(),
        ref.read(staffNotifierProvider.notifier).fetchAll(),
      ]);
      if (!mounted) return;

      final userInfo = await ref.read(currentUserInfoProvider.future);
      if (!mounted) return;

      setState(() {
        _customersLoaded = true;
        _staffLoaded = true;

        if (_selectedCustomerLabel.isEmpty && _selectedCustomerId != null) {
          final customers = ref.read(customerNotifierProvider).customers;
          for (final c in customers) {
            if (c.customerId == _selectedCustomerId) {
              _selectedCustomerLabel = c.name;
              break;
            }
          }
        }
        if (_selectedStaffId == null) {
          _selectedStaffId = userInfo?.staffId;
          _selectedStaffLabel = userInfo?.fullName ?? 'You';
        } else {
          final staffList = ref.read(staffNotifierProvider).valueOrNull ?? [];
          for (final s in staffList) {
            if (s.id == _selectedStaffId) {
              _selectedStaffLabel = s.name;
              break;
            }
          }
          if (_selectedStaffLabel.isEmpty) {
            _selectedStaffLabel = (_selectedStaffId == userInfo?.staffId)
                ? (userInfo?.fullName ?? 'You')
                : 'Staff #$_selectedStaffId';
          }
        }
      });
    });
  }

  @override
  void dispose() {
    _refNumberCtrl.dispose();
    _paymentTermsCtrl.dispose();
    _noteCtrl.dispose();
    _productionDaysCtrl.dispose();
    _discountCtrl.dispose();
    _taxCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit(QuotationFormNotifier notifier, int? quotationId) async {
    final formData = ref.read(
      quotationFormNotifierProvider(initial: widget.existing),
    );
    final userInfo = await ref.read(currentUserInfoProvider.future);
    final int? resolvedStaffId = _selectedStaffId ?? userInfo?.staffId;

    notifier
      ..setRefNumber(_refNumberCtrl.text)
      ..setPaymentTerms(_paymentTermsCtrl.text)
      ..setNote(_noteCtrl.text)
      ..setProductionDays(int.tryParse(_productionDaysCtrl.text) ?? 1)
      ..setDiscount(double.tryParse(_discountCtrl.text) ?? 0)
      ..setTax(double.tryParse(_taxCtrl.text) ?? 0)
      ..setCustomer(_selectedCustomerId ?? formData.customerId ?? 0)
      ..setStaff(resolvedStaffId);

    final updated = ref.read(
      quotationFormNotifierProvider(initial: widget.existing),
    );

    if (!_isEditing && !updated.isValid) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Please fill customer, ref number, and add at least one item.',
          ),
        ),
      );
      return;
    }

    setState(() => _submitting = true);
    try {
      if (_isEditing) {
        await notifier.submitUpdate(quotationId!);
      } else {
        await notifier.submitCreate();
      }
      if (mounted) Navigator.of(context).pop();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('$e')));
      }
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final formProvider = quotationFormNotifierProvider(
      initial: widget.existing,
    );
    final formData = ref.watch(formProvider);
    final notifier = ref.read(formProvider.notifier);

    final userInfoAsync = ref.watch(currentUserInfoProvider);
    final customerState = ref.watch(customerNotifierProvider);
    final customers = customerState.customers;
    final staffState = ref.watch(staffNotifierProvider);
    final staffList = staffState.valueOrNull ?? [];

    return Scaffold(
      backgroundColor: isDark
          ? Pallets.backgroundDark
          : Pallets.backgroundLight,
      appBar: AppBar(
        title: Text(_isEditing ? 'Edit Quotation' : 'New Quotation'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Pallets.blurple,
                foregroundColor: Pallets.onAccent,
                padding: const EdgeInsets.symmetric(vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              onPressed: _submitting
                  ? null
                  : () => _submit(notifier, widget.existing?.quotationId),
              child: _submitting
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : Text(_isEditing ? 'Save Changes' : 'Create Quotation'),
            ),
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
        children: [
          BasicInfoSection(
            customersLoaded: _customersLoaded,
            staffLoaded: _staffLoaded,
            customers: customers,
            staffList: staffList,
            selectedCustomerId: _selectedCustomerId,
            selectedCustomerLabel: _selectedCustomerLabel,
            onCustomerSelected: (c) => setState(() {
              _selectedCustomerId = c.customerId;
              _selectedCustomerLabel = c.name;
            }),
            selectedStaffId: _selectedStaffId,
            selectedStaffLabel: _selectedStaffLabel,
            onStaffSelected: (s) => setState(() {
              _selectedStaffId = s.id;
              _selectedStaffLabel = s.name;
            }),
            myStaffId: userInfoAsync.valueOrNull?.staffId,
            myFullName: userInfoAsync.valueOrNull?.fullName,
            onAssignToMe: (staffId, fullName) => setState(() {
              _selectedStaffId = staffId;
              _selectedStaffLabel = fullName;
            }),
            refNumberCtrl: _refNumberCtrl,
          ),
          const SizedBox(height: 16),
          DatesProductionSection(
            quotationDate: formData.quotationDate,
            expiryDate: formData.expiryDate,
            productionDaysCtrl: _productionDaysCtrl,
            onQuotationDatePicked: notifier.setQuotationDate,
            onExpiryDatePicked: notifier.setExpiryDate,
          ),
          const SizedBox(height: 16),
          ArtworkDeliverySection(
            artworkStatus: formData.artworkStatus,
            deliveryMethod: formData.deliveryMethod,
            paymentTermsCtrl: _paymentTermsCtrl,
            onArtworkChanged: notifier.setArtworkStatus,
            onDeliveryChanged: notifier.setDeliveryMethod,
          ),
          const SizedBox(height: 16),
          PricingSection(
            discountCtrl: _discountCtrl,
            taxCtrl: _taxCtrl,
            noteCtrl: _noteCtrl,
          ),
          if (!_isEditing) ...[
            const SizedBox(height: 16),
            ItemsSection(
              items: formData.items,
              subtotal: formData.subtotal,
              totalAmount: formData.totalAmount,
              onAdd: () async {
                final item = await showQuotationItemFormSheet(
                  context,
                  nextSortOrder: formData.items.length + 1,
                );
                if (item != null) notifier.addLocalItem(item);
              },
              onEdit: (index) async {
                final updated = await showQuotationItemFormSheet(
                  context,
                  initial: formData.items[index],
                  nextSortOrder: formData.items[index].sortOrder,
                );
                if (updated != null) notifier.updateLocalItem(index, updated);
              },
              onDelete: (index) => notifier.removeLocalItem(index),
            ),
          ],
        ],
      ),
    );
  }
}
