import 'package:flutter/material.dart';
import 'package:frontendmobile/features/inventory/quotations/presentation/widgets/quotations_form/date_field.dart';
import 'package:intl/intl.dart';
import 'section_card.dart';

class DatesProductionSection extends StatelessWidget {
  final DateTime quotationDate;
  final DateTime expiryDate;
  final TextEditingController productionDaysCtrl;
  final ValueChanged<DateTime> onQuotationDatePicked;
  final ValueChanged<DateTime> onExpiryDatePicked;

  const DatesProductionSection({
    super.key,
    required this.quotationDate,
    required this.expiryDate,
    required this.productionDaysCtrl,
    required this.onQuotationDatePicked,
    required this.onExpiryDatePicked,
  });

  Future<void> _pickDate(
    BuildContext context,
    DateTime initial,
    ValueChanged<DateTime> onPicked,
  ) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now().add(const Duration(days: 365 * 2)),
    );
    if (picked != null) onPicked(picked);
  }

  @override
  Widget build(BuildContext context) {
    final dateFmt = DateFormat('dd MMM yyyy');
    return SectionCard(
      title: 'Dates & Production',
      children: [
        DateField(
          label: 'Quotation date',
          value: dateFmt.format(quotationDate),
          onTap: () => _pickDate(context, quotationDate, onQuotationDatePicked),
        ),
        const SizedBox(height: 12),
        DateField(
          label: 'Expiry date',
          value: dateFmt.format(expiryDate),
          onTap: () => _pickDate(context, expiryDate, onExpiryDatePicked),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: productionDaysCtrl,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(labelText: 'Production days'),
        ),
      ],
    );
  }
}