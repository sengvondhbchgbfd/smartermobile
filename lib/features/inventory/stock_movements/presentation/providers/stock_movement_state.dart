import 'package:frontendmobile/features/inventory/stock_movements/domain/entities/stock_movement_entity.dart';

class StockMovementState {
  final List<StockMovementEntity> movements;
  final bool isLoading;
  final String? error;

  const StockMovementState({
    this.movements = const [],
    this.isLoading = false,
    this.error,
  });

  StockMovementState copyWith({
    List<StockMovementEntity>? movements,
    bool? isLoading,
    String? error,
    bool clearError = false,
  }) => StockMovementState(
    movements: movements ?? this.movements,
    isLoading: isLoading ?? this.isLoading,
    error: clearError ? null : (error ?? this.error),
  );
}