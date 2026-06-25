import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontendmobile/core/errors/exceptions.dart';
import 'package:frontendmobile/features/inventory/stock_movements/presentation/providers/stock_movement_state.dart';
import 'package:frontendmobile/shared/providers/core_providers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../data/datasources/stock_movement_remote_datasource.dart';
import '../../data/repositories/stock_movement_repository_impl.dart';
import '../../domain/repositories/stock_movement_repository.dart';
import '../../domain/usecase/stock_movement_usecase.dart';
part 'stock_movement_provider.g.dart';

// ── Infrastructure ────────────────────────────────────────────────────────────

@riverpod
Future<StockMovementRemoteDataSource> stockMovementDataSource(Ref ref) async {
  final dioClient = await ref.watch(dioClientProvider.future);
  return StockMovementRemoteDataSourceImpl(dioClient);
}

@riverpod
Future<StockMovementRepository> stockMovementRepository(Ref ref) async {
  final dataSource = await ref.watch(stockMovementDataSourceProvider.future);
  return StockMovementRepositoryImpl(dataSource);
}

// ── Use-case providers ────────────────────────────────────────────────────────

@riverpod
Future<GetAllStockMovementsUseCase> getAllStockMovementsUC(Ref ref) async {
  final repo = await ref.watch(stockMovementRepositoryProvider.future);
  return GetAllStockMovementsUseCase(repo);
}

@riverpod
Future<CreateStockMovementUseCase> createStockMovementUC(Ref ref) async {
  final repo = await ref.watch(stockMovementRepositoryProvider.future);
  return CreateStockMovementUseCase(repo);
}

@riverpod
Future<DeleteStockMovementUseCase> deleteStockMovementUC(Ref ref) async {
  final repo = await ref.watch(stockMovementRepositoryProvider.future);
  return DeleteStockMovementUseCase(repo);
}

// ── Notifier ──────────────────────────────────────────────────────────────────

@riverpod
class StockMovementNotifier extends _$StockMovementNotifier {
  @override
  StockMovementState build() => const StockMovementState();

  Future<GetAllStockMovementsUseCase> get _getAllUC =>
      ref.read(getAllStockMovementsUCProvider.future);
  Future<CreateStockMovementUseCase> get _createUC =>
      ref.read(createStockMovementUCProvider.future);
  Future<DeleteStockMovementUseCase> get _deleteUC =>
      ref.read(deleteStockMovementUCProvider.future);

  // ── Load ───────────────────────────────────────────────────────────────────

  Future<void> loadAll({int? variantId}) async {
    // ✅
    state = state.copyWith(isLoading: true, error: null);
    try {
      final uc = await _getAllUC;
      final result = await uc(variantId: variantId); // ✅
      state = state.copyWith(movements: result, isLoading: false);
    } on ApiException catch (e) {
      state = state.copyWith(isLoading: false, error: e.message);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  // ── Create ─────────────────────────────────────────────────────────────────

  Future<bool> create({
    required int variantId,
    required int productId, // ← add
    required int qtyIn,
    required int qtyOut,
    required String movementType,
    required DateTime date,
  }) async {
    try {
      final uc = await _createUC;
      final created = await uc(
        variantId: variantId,
        productId: productId, // ← add
        qtyIn: qtyIn,
        qtyOut: qtyOut,
        movementType: movementType,
        date: date,
      );
      state = state.copyWith(movements: [created, ...state.movements]);
      return true;
    } on ApiException catch (e) {
      state = state.copyWith(error: e.message);
      return false;
    }
  }

  // ── Delete ─────────────────────────────────────────────────────────────────

  Future<bool> delete(int movementId) async {
    try {
      final uc = await _deleteUC;
      await uc(movementId);
      state = state.copyWith(
        movements: state.movements
            .where((m) => m.movementId != movementId)
            .toList(),
      );
      return true;
    } on ApiException catch (e) {
      state = state.copyWith(error: e.message);
      return false;
    }
  }

  void clearError() => state = state.copyWith(error: null);
}
