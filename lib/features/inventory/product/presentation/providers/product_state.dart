import 'package:frontendmobile/features/inventory/product/domain/entities/product_entity.dart';

class ProductState {
  final List<ProductEntity> products;
  final bool isLoading;
  final bool isCreating;
  final String? error;
  final Set<int> loadingIds;

  const ProductState({
    this.products = const [],
    this.isLoading = false,
    this.isCreating = false,
    this.error,
    this.loadingIds = const {},
  });

  ProductState copyWith({
    List<ProductEntity>? products,
    bool? isLoading,
    bool? isCreating,
    String? error,
    Set<int>? loadingIds,
  }) => ProductState(
    products: products ?? this.products,
    isLoading: isLoading ?? this.isLoading,
    isCreating: isCreating ?? this.isCreating,
    error: error, // Intentional pass-through to let us clear errors explicitly
    loadingIds: loadingIds ?? this.loadingIds,
  );
}
