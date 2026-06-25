import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontendmobile/core/errors/exceptions.dart';
import 'package:frontendmobile/features/inventory/product/presentation/providers/product_provider.dart';
import 'package:frontendmobile/features/inventory/product_variant/domain/usecase/product_variant_usecase.dart';
import 'package:frontendmobile/shared/providers/core_providers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/datasources/product_variant_remote_datasource.dart';
import '../../data/repositories/product_variant_repository_impl.dart';
import '../../domain/repositories/product_variant_repository.dart';
import 'product_variant_state.dart';
part 'product_variant_provider.g.dart';

// ── Infrastructure ────────────────────────────────────────────────────────────
@riverpod
Future<ProductVariantRemoteDataSource> variantDataSource(Ref ref) async {
  final client = await ref.watch(dioClientProvider.future);
  return ProductVariantRemoteDataSourceImpl(client);
}

@riverpod
Future<ProductVariantRepository> variantRepository(Ref ref) async {
  final ds = await ref.watch(variantDataSourceProvider.future);
  return ProductVariantRepositoryImpl(ds);
}

// ── Use cases ─────────────────────────────────────────────────────────────────

@riverpod
Future<GetAllVariantsUseCase> getAllVariantsUC(Ref ref) async {
  final repo = await ref.watch(variantRepositoryProvider.future);
  return GetAllVariantsUseCase(repo);
}

@riverpod
Future<CreateVariantUseCase> createVariantUC(Ref ref) async {
  final repo = await ref.watch(variantRepositoryProvider.future);
  return CreateVariantUseCase(repo);
}

@riverpod
Future<UpdateVariantUseCase> updateVariantUC(Ref ref) async {
  final repo = await ref.watch(variantRepositoryProvider.future);
  return UpdateVariantUseCase(repo);
}

@riverpod
Future<DeleteVariantUseCase> deleteVariantUC(Ref ref) async {
  final repo = await ref.watch(variantRepositoryProvider.future);
  return DeleteVariantUseCase(repo);
}

@riverpod
Future<AddVariantImageUseCase> addVariantImageUC(Ref ref) async {
  final repo = await ref.watch(variantRepositoryProvider.future);
  return AddVariantImageUseCase(repo);
}

@riverpod
Future<SetPrimaryVariantImageUseCase> setPrimaryVariantImageUC(Ref ref) async {
  final repo = await ref.watch(variantRepositoryProvider.future);
  return SetPrimaryVariantImageUseCase(repo);
}

@riverpod
Future<DeleteVariantImageUseCase> deleteVariantImageUC(Ref ref) async {
  final repo = await ref.watch(variantRepositoryProvider.future);
  return DeleteVariantImageUseCase(repo);
}

// ── Notifier ──────────────────────────────────────────────────────────────────

@riverpod
class ProductVariantNotifier extends _$ProductVariantNotifier {
  @override
  ProductVariantState build() => const ProductVariantState();

  Future<GetAllVariantsUseCase> get _getAllUC =>
      ref.read(getAllVariantsUCProvider.future);
  Future<CreateVariantUseCase> get _createUC =>
      ref.read(createVariantUCProvider.future);
  Future<UpdateVariantUseCase> get _updateUC =>
      ref.read(updateVariantUCProvider.future);
  Future<DeleteVariantUseCase> get _deleteUC =>
      ref.read(deleteVariantUCProvider.future);
  Future<AddVariantImageUseCase> get _addImageUC =>
      ref.read(addVariantImageUCProvider.future);
  Future<SetPrimaryVariantImageUseCase> get _setPrimaryUC =>
      ref.read(setPrimaryVariantImageUCProvider.future);
  Future<DeleteVariantImageUseCase> get _deleteImageUC =>
      ref.read(deleteVariantImageUCProvider.future);

  // ── Load ───────────────────────────────────────────────────────────────────

  Future<void> loadAll(int productId) async {
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      final uc = await _getAllUC;
      final result = await uc(productId);
      state = state.copyWith(variants: result, isLoading: false);
    } on ApiException catch (e) {
      state = state.copyWith(isLoading: false, error: e.message);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  // ── Create ─────────────────────────────────────────────────────────────────

  Future<bool> create({
    required int productId,
    String? sku,
    required Map<String, dynamic> specs,
    required double price,
    required int stockQuantity,
  }) async {
    state = state.copyWith(isCreating: true, clearError: true);
    try {
      final uc = await _createUC;
      final created = await uc(
        productId: productId,
        sku: sku,
        specs: specs,
        price: price,
        stockQuantity: stockQuantity,
      );
      state = state.copyWith(
        variants: [...state.variants, created],
        isCreating: false,
      );
      ref.read(productNotifierProvider.notifier).loadAll();
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
    required int productId,
    required int variantId,
    String? sku,
    Map<String, dynamic>? specs,
    double? price,
    int? stockQuantity,
  }) async {
    state = state.copyWith(loadingIds: {...state.loadingIds, variantId});
    try {
      final uc = await _updateUC;
      final updated = await uc(
        productId: productId,
        variantId: variantId,
        sku: sku,
        specs: specs,
        price: price,
        stockQuantity: stockQuantity,
      );
      state = state.copyWith(
        variants: state.variants
            .map((v) => v.variantId == variantId ? updated : v)
            .toList(),
        loadingIds: state.loadingIds.difference({variantId}),
      );
      ref.read(productNotifierProvider.notifier).loadAll();
      return true;
    } on ApiException catch (e) {
      state = state.copyWith(
        error: e.message,
        loadingIds: state.loadingIds.difference({variantId}),
      );
      return false;
    } catch (e) {
      state = state.copyWith(
        error: e.toString(),
        loadingIds: state.loadingIds.difference({variantId}),
      );
      return false;
    }
  }

  // ── Delete ─────────────────────────────────────────────────────────────────

  Future<bool> delete(int productId, int variantId) async {
    state = state.copyWith(loadingIds: {...state.loadingIds, variantId});
    try {
      final uc = await _deleteUC;
      await uc(productId, variantId);
      state = state.copyWith(
        variants: state.variants
            .where((v) => v.variantId != variantId)
            .toList(),
        loadingIds: state.loadingIds.difference({variantId}),
      );
      ref.read(productNotifierProvider.notifier).loadAll();
      return true;
    } on ApiException catch (e) {
      state = state.copyWith(
        error: e.message,
        loadingIds: state.loadingIds.difference({variantId}),
      );
      return false;
    } catch (e) {
      state = state.copyWith(
        error: e.toString(),
        loadingIds: state.loadingIds.difference({variantId}),
      );
      return false;
    }
  }

  // ── Add image ──────────────────────────────────────────────────────────────

  Future<bool> addImage({
    required int productId,
    required int variantId,
    required File image,
    bool isPrimary = false,
    int sortOrder = 0,
  }) async {
    state = state.copyWith(loadingIds: {...state.loadingIds, variantId});
    try {
      final uc = await _addImageUC;
      await uc(
        productId: productId,
        variantId: variantId,
        image: image,
        isPrimary: isPrimary,
        sortOrder: sortOrder,
      );
      await loadAll(productId);
      return true;
    } on ApiException catch (e) {
      state = state.copyWith(
        error: e.message,
        loadingIds: state.loadingIds.difference({variantId}),
      );
      return false;
    } catch (e) {
      state = state.copyWith(
        error: e.toString(),
        loadingIds: state.loadingIds.difference({variantId}),
      );
      return false;
    }
  }

  // ── Set primary image ──────────────────────────────────────────────────────

  Future<bool> setPrimaryImage({
    required int productId,
    required int variantId,
    required int imageId,
  }) async {
    state = state.copyWith(loadingIds: {...state.loadingIds, variantId});
    try {
      final uc = await _setPrimaryUC;
      await uc(productId: productId, variantId: variantId, imageId: imageId);
      await loadAll(productId);
      return true;
    } on ApiException catch (e) {
      state = state.copyWith(
        error: e.message,
        loadingIds: state.loadingIds.difference({variantId}),
      );
      return false;
    } catch (e) {
      state = state.copyWith(
        error: e.toString(),
        loadingIds: state.loadingIds.difference({variantId}),
      );
      return false;
    }
  }

  // ── Delete image ───────────────────────────────────────────────────────────

  Future<bool> deleteImage({
    required int productId,
    required int variantId,
    required int imageId,
  }) async {
    state = state.copyWith(loadingIds: {...state.loadingIds, variantId});
    try {
      final uc = await _deleteImageUC;
      await uc(productId: productId, variantId: variantId, imageId: imageId);
      state = state.copyWith(
        variants: state.variants.map((v) {
          if (v.variantId != variantId) return v;
          return v.copyWith(
            images: v.images.where((i) => i.imageId != imageId).toList(),
          );
        }).toList(),
        loadingIds: state.loadingIds.difference({variantId}),
      );
      return true;
    } on ApiException catch (e) {
      state = state.copyWith(
        error: e.message,
        loadingIds: state.loadingIds.difference({variantId}),
      );
      return false;
    } catch (e) {
      state = state.copyWith(
        error: e.toString(),
        loadingIds: state.loadingIds.difference({variantId}),
      );
      return false;
    }
  }

  void clearError() => state = state.copyWith(clearError: true);
}
