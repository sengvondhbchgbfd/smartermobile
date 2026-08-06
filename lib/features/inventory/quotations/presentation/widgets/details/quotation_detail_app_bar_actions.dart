import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontendmobile/core/themes/app_pallets.dart';
import 'package:frontendmobile/features/inventory/quotations/domain/entities/quotation_entity.dart';
import 'package:frontendmobile/features/inventory/quotations/presentation/screen/quotation_form_screen.dart';
import 'package:frontendmobile/features/inventory/quotations/presentation/widgets/quotation_export_sheet.dart';

class QuotationDetailAppBarActions extends StatelessWidget {
  final QuotationEntity quotation;
  final void Function(BuildContext context) onChangeStatus;
  final VoidCallback onDelete;

  const QuotationDetailAppBarActions({
    super.key,
    required this.quotation,
    required this.onChangeStatus,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final q = quotation;
    return Row(
      children: [
        IconButton(
          icon: const Icon(Icons.ios_share_rounded),
          tooltip: 'Send to client',
          onPressed: () {
            final ref = ProviderScope.containerOf(context, listen: false);
            showQuotationExportSheet(
              context,
              ref as dynamic,
              quotation: q,
              items: q.items,
            );
          },
        ),
        if (q.isEditable)
          IconButton(
            icon: const Icon(Icons.edit_outlined),
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => QuotationFormScreen(existing: q),
              ),
            ),
          ),
        PopupMenuButton<String>(
          onSelected: (value) {
            if (value == 'status') {
              onChangeStatus(context);
            } else if (value == 'delete' && q.isDeletable) {
              onDelete();
            }
          },
          itemBuilder: (ctx) => [
            const PopupMenuItem(value: 'status', child: Text('Change status')),
            if (q.isDeletable)
              PopupMenuItem(
                value: 'delete',
                child: Text('Delete', style: TextStyle(color: Pallets.error)),
              ),
          ],
        ),
      ],
    );
  }
}
