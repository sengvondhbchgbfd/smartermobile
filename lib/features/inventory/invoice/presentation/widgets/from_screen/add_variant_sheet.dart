import 'package:flutter/material.dart';
import 'package:frontendmobile/features/inventory/invoice/presentation/widgets/invoice_theme_color.dart';
import 'package:frontendmobile/features/inventory/product/domain/entities/product_entity.dart';

Future<ProductVariantEntity?> showAddVariantSheet(
  BuildContext context,
  List<ProductVariantEntity> variants,
) {
  final colors = context.invoiceColors;

  return showModalBottomSheet<ProductVariantEntity>(
    context: context,
    backgroundColor: colors.overlay,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),

    ///////////////////////////////
    ///
    //////////////////////////////
    builder: (ctx) => SafeArea(
      child: ListView(
        ///////////////////////////////
        ///
        //////////////////////////////
        shrinkWrap: true,
        padding: const EdgeInsets.symmetric(vertical: 8),

        ///////////////////////////////
        ///
        //////////////////////////////
        children: variants.map((v) {
          ///////////////////////////////
          ///
          //////////////////////////////
          return ListTile(
            leading: CircleAvatar(
              radius: 18,
              backgroundColor: colors.accent.withOpacity(0.12),
              child: Icon(
                Icons.inventory_2_outlined,
                size: 18,
                color: colors.accent,
              ),
            ),

            ///////////////////////////////
            ///
            //////////////////////////////
            title: Text(
              v.sku?.isNotEmpty == true ? v.sku! : "Variant  #${v.variantId}",
              style: TextStyle(
                color: colors.textPrimary,
                fontWeight: FontWeight.w600,
              ),
            ),

            ///////////////////////////////
            ///
            //////////////////////////////
            subtitle: Text(
              '\$${v.price?.toStringAsFixed(2) ?? '0.00'}  •  Stock: ${v.stockQuantity ?? 0}',
              style: TextStyle(color: colors.textSecondary),
            ),
            onTap: () => Navigator.pop(ctx, v),
          );
        }).toList(),

        ///////////////////////////////
        ///
        //////////////////////////////
      ),
    ),
  );
}
