import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontendmobile/core/errors/exceptions.dart';
import 'package:frontendmobile/features/inventory/supplier_product_price/data/datasource/supplier_product_price_datasource.dart';
import 'package:frontendmobile/features/inventory/supplier_product_price/domain/repositories/supplier_product_price_repo.dart';
import 'package:frontendmobile/shared/providers/core_providers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/repositories/supplier_product_price_repository_impl.dart';
import '../../domain/usecase/supplier_product_price_usecase.dart';
import 'supplier_product_price_state.dart';

part 'supplier_product_price_provider.g.dart';

// ── Infrastructure ────────────────────────────────────────────────────────────
@riverpod
Future<SupplierProductPriceRemoteDataSource> supplierProductPriceDataSource(
  Ref ref,
) async {
  final client = await ref.watch(dioClientProvider.future);
  return SupplierProductPriceRemoteDataSourceImpl(client);
}

@riverpod
Future<SupplierProductPriceRepository> supplierProductPriceRepository(
  Ref ref,
) async {
  final ds = await ref.watch(supplierProductPriceDataSourceProvider.future);
  return SupplierProductPriceRepositoryImpl(ds);
}

// ── Use cases ─────────────────────────────────────────────────────────────────

@riverpod
Future<GetAllSupplierProductPricesUseCase> getAllSupplierProductPricesUC(
  Ref ref,
) async {
  final repo = await ref.watch(supplierProductPriceRepositoryProvider.future);
  return GetAllSupplierProductPricesUseCase(repo);
}

// Not wired into the notifier below (mirrors product_variant, which also has
// no single-item fetch in its notifier) — call this directly from a detail
// screen if/when you need it, e.g. ref.read(getSupplierProductPriceByIdUCProvider.future).
@riverpod
Future<GetSupplierProductPriceByIdUseCase> getSupplierProductPriceByIdUC(
  Ref ref,
) async {
  final repo = await ref.watch(supplierProductPriceRepositoryProvider.future);
  return GetSupplierProductPriceByIdUseCase(repo);
}

@riverpod
Future<CreateSupplierProductPriceUseCase> createSupplierProductPriceUC(
  Ref ref,
) async {
  final repo = await ref.watch(supplierProductPriceRepositoryProvider.future);
  return CreateSupplierProductPriceUseCase(repo);
}

@riverpod
Future<UpdateSupplierProductPriceUseCase> updateSupplierProductPriceUC(
  Ref ref,
) async {
  final repo = await ref.watch(supplierProductPriceRepositoryProvider.future);
  return UpdateSupplierProductPriceUseCase(repo);
}

@riverpod
Future<DeleteSupplierProductPriceUseCase> deleteSupplierProductPriceUC(
  Ref ref,
) async {
  final repo = await ref.watch(supplierProductPriceRepositoryProvider.future);
  return DeleteSupplierProductPriceUseCase(repo);
}

// ── Notifier ──────────────────────────────────────────────────────────────────

@riverpod
class SupplierProductPriceNotifier extends _$SupplierProductPriceNotifier {
  @override
  SupplierProductPriceState build() => const SupplierProductPriceState();

  Future<GetAllSupplierProductPricesUseCase> get _getAllUC =>
      ref.read(getAllSupplierProductPricesUCProvider.future);
  Future<CreateSupplierProductPriceUseCase> get _createUC =>
      ref.read(createSupplierProductPriceUCProvider.future);


      
  Future<UpdateSupplierProductPriceUseCase> get _updateUC =>



      ref.read(updateSupplierProductPriceUCProvider.future);
  Future<DeleteSupplierProductPriceUseCase> get _deleteUC =>
      ref.read(deleteSupplierProductPriceUCProvider.future);

  // ── Load ───────────────────────────────────────────────────────────────────

  Future<void> loadAll({int? supplierId, int? variantId}) async {
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      final uc = await _getAllUC;
      final result = await uc(supplierId: supplierId, variantId: variantId);
      state = state.copyWith(prices: result, isLoading: false);
    } on ApiException catch (e) {
      state = state.copyWith(isLoading: false, error: e.message);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  // ── Create ─────────────────────────────────────────────────────────────────

  Future<bool> create({
    required int supplierId,
    required int variantId,
    required double unitPrice,
    String? note,
  }) async {
    state = state.copyWith(isCreating: true, clearError: true);
    try {
      final uc = await _createUC;
      final created = await uc(
        supplierId: supplierId,
        variantId: variantId,
        unitPrice: unitPrice,
        note: note,
      );
      state = state.copyWith(
        prices: [...state.prices, created],
        isCreating: false,
      );
      return true;
    } on ApiException catch (e) {
      state = state.copyWith(error: e.message, isCreating: false);
      return false;
    } catch (e) {
      state = state.copyWith(error: e.toString(), isCreating: false);
      return false;
    }
  }

  // ── Update ─────────────────────────────────────────────────────────────────

  Future<bool> update({
    required int priceId,
    int? supplierId,
    int? variantId,
    double? unitPrice,
    String? note,
  }) async {
    state = state.copyWith(loadingIds: {...state.loadingIds, priceId});
    try {
      final uc = await _updateUC;
      final updated = await uc(
        priceId: priceId,
        supplierId: supplierId,
        variantId: variantId,
        unitPrice: unitPrice,
        note: note,
      );
      state = state.copyWith(
        prices: state.prices
            .map((p) => p.priceId == priceId ? updated : p)
            .toList(),
        loadingIds: state.loadingIds.difference({priceId}),
      );
      return true;
    } on ApiException catch (e) {
      state = state.copyWith(
        error: e.message,
        loadingIds: state.loadingIds.difference({priceId}),
      );
      return false;
    } catch (e) {
      state = state.copyWith(
        error: e.toString(),
        loadingIds: state.loadingIds.difference({priceId}),
      );
      return false;
    }
  }

  // ── Delete ─────────────────────────────────────────────────────────────────

  Future<bool> delete(int priceId) async {
    state = state.copyWith(loadingIds: {...state.loadingIds, priceId});
    try {
      final uc = await _deleteUC;
      await uc(priceId);
      state = state.copyWith(
        prices: state.prices.where((p) => p.priceId != priceId).toList(),
        loadingIds: state.loadingIds.difference({priceId}),
      );
      return true;
    } on ApiException catch (e) {
      state = state.copyWith(
        error: e.message,
        loadingIds: state.loadingIds.difference({priceId}),
      );
      return false;
    } catch (e) {
      state = state.copyWith(
        error: e.toString(),
        loadingIds: state.loadingIds.difference({priceId}),
      );
      return false;
    }
  }

  void clearError() => state = state.copyWith(clearError: true);
}
