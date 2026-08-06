import 'package:frontendmobile/features/inventory/product/domain/entities/product_entity.dart';

class DraftItem {
  final ProductVariantEntity variant;
  int quantity;
  DraftItem({required this.variant, this.quantity = 1});
  double get total => variant.price * quantity;
}
