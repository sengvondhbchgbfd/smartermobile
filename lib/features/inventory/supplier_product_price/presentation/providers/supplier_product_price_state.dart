import '../../domain/entities/supplier_product_price_entity.dart';

class SupplierProductPriceState {
  final List<SupplierProductPriceEntity> prices;
  final bool isLoading;
  final bool isCreating;
  final Set<int> loadingIds;
  final String? error;

  const SupplierProductPriceState({
    this.prices = const [],
    this.isLoading = false,
    this.isCreating = false,
    this.loadingIds = const {},
    this.error,
  });

  SupplierProductPriceState copyWith({
    List<SupplierProductPriceEntity>? prices,
    bool? isLoading,
    bool? isCreating,
    Set<int>? loadingIds,
    String? error,
    bool clearError = false,
  }) => SupplierProductPriceState(
    prices: prices ?? this.prices,
    isLoading: isLoading ?? this.isLoading,
    isCreating: isCreating ?? this.isCreating,
    loadingIds: loadingIds ?? this.loadingIds,
    error: clearError ? null : error ?? this.error,
  );
}
