import 'package:frontendmobile/features/inventory/supplier/domain/entities/supplier.dart';

class SupplierState {
  final List<SupplierEntity> suppliers;
  final bool isLoading;
  final bool isCreating;
  final String? error;
  final Set<int> loadingIds;

  const SupplierState({
    this.suppliers = const [],
    this.isLoading = false,
    this.isCreating = false,
    this.error,
    this.loadingIds = const {},
  });

  SupplierState copyWith({
    List<SupplierEntity>? suppliers,
    bool? isLoading,
    bool? isCreating,
    String? error,
    Set<int>? loadingIds,
    bool clearError = false,
  }) => SupplierState(
    suppliers: suppliers ?? this.suppliers,
    isLoading: isLoading ?? this.isLoading,
    isCreating: isCreating ?? this.isCreating,
    error: clearError || (isLoading == true) ? null : (error ?? this.error),
    loadingIds: loadingIds ?? this.loadingIds,
  );
}
