
import 'package:frontendmobile/features/inventory/product/domain/entities/product_entity.dart';

class ProductVariantState {
  final List<ProductVariantEntity> variants;
  final bool isLoading;
  final bool isCreating;
  final Set<int> loadingIds;
  final String? error;

  const ProductVariantState({
    this.variants = const [],
    this.isLoading = false,
    this.isCreating = false,
    this.loadingIds = const {},
    this.error,
  });

  ProductVariantState copyWith({
    List<ProductVariantEntity>? variants,
    bool? isLoading,
    bool? isCreating,
    Set<int>? loadingIds,
    String? error,
    bool clearError = false,
  }) => ProductVariantState(
    variants:   variants   ?? this.variants,
    isLoading:  isLoading  ?? this.isLoading,
    isCreating: isCreating ?? this.isCreating,
    loadingIds: loadingIds ?? this.loadingIds,
    error:      clearError ? null : error ?? this.error,
  );
}