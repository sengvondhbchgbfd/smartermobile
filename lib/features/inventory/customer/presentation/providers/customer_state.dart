import 'package:frontendmobile/features/inventory/customer/domain/entities/customer_entity.dart';

class CustomerState {
  final List<CustomerEntity> customers;
  final bool isLoading;
  final bool isCreating;  // ← add
  final String? error;
  final Set<int> loadingIds;

  const CustomerState({
    this.customers = const [],
    this.isLoading = false,
    this.isCreating = false,  // ← add
    this.error,
    this.loadingIds = const {},
  });

  CustomerState copyWith({
    List<CustomerEntity>? customers,
    bool? isLoading,
    bool? isCreating,  // ← add
    String? error,
    Set<int>? loadingIds,
    bool clearError = false,
  }) {
    return CustomerState(
      customers: customers ?? this.customers,
      isLoading: isLoading ?? this.isLoading,
      isCreating: isCreating ?? this.isCreating,  // ← add
      error: clearError || (isLoading == true) ? null : (error ?? this.error),
      loadingIds: loadingIds ?? this.loadingIds,
    );
  }
}