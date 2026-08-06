import 'package:flutter/material.dart';
import 'section_card.dart';

class PricingSection extends StatelessWidget {
  final TextEditingController discountCtrl;
  final TextEditingController taxCtrl;
  final TextEditingController noteCtrl;

  const PricingSection({
    super.key,
    required this.discountCtrl,
    required this.taxCtrl,
    required this.noteCtrl,
  });

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      title: 'Pricing',
      children: [
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: discountCtrl,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                decoration: const InputDecoration(labelText: 'Discount'),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: TextField(
                controller: taxCtrl,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                decoration: const InputDecoration(labelText: 'Tax'),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        TextField(
          controller: noteCtrl,
          maxLines: 2,
          decoration: const InputDecoration(labelText: 'Note'),
        ),
      ],
    );
  }
}