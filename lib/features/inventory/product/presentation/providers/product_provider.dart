import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontendmobile/core/errors/exceptions.dart';
import 'package:frontendmobile/shared/providers/core_providers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/datasources/product_remote_datasource.dart';
import '../../data/repositories/product_repository_impl.dart';
import '../../domain/repositories/product_repository.dart';
import '../../domain/usecase/product_usecase.dart';
import 'product_state.dart';

part 'product_provider.g.dart';

// ── Infrastructure ────────────────────────────────────────────────────────────

@riverpod
Future<ProductRemoteDataSource> productDataSource(Ref ref) async {
  final client = await ref.watch(dioClientProvider.future);
  return ProductRemoteDataSourceImpl(client);
}

@riverpod
Future<ProductRepository> productRepository(Ref ref) async {
  final ds = await ref.watch(productDataSourceProvider.future);
  return ProductRepositoryImpl(ds);
}

// ── Use-case providers ────────────────────────────────────────────────────────

@riverpod
Future<GetAllProductsUseCase> getAllProductsUC(Ref ref) async {
  final repo = await ref.watch(productRepositoryProvider.future);
  return GetAllProductsUseCase(repo);
}

@riverpod
Future<CreateProductUseCase> createProductUC(Ref ref) async {
  final repo = await ref.watch(productRepositoryProvider.future);
  return CreateProductUseCase(repo);
}

@riverpod
Future<UpdateProductUseCase> updateProductUC(Ref ref) async {
  final repo = await ref.watch(productRepositoryProvider.future);
  return UpdateProductUseCase(repo);
}

@riverpod
Future<AddProductImageUseCase> addProductImageUC(Ref ref) async {
  final repo = await ref.watch(productRepositoryProvider.future);
  return AddProductImageUseCase(repo);
}

@riverpod
Future<SetPrimaryImageUseCase> setPrimaryImageUC(Ref ref) async {
  final repo = await ref.watch(productRepositoryProvider.future);
  return SetPrimaryImageUseCase(repo);
}

@riverpod
Future<DeleteProductImageUseCase> deleteProductImageUC(Ref ref) async {
  final repo = await ref.watch(productRepositoryProvider.future);
  return DeleteProductImageUseCase(repo);
}

@riverpod
Future<DeleteProductUseCase> deleteProductUC(Ref ref) async {
  final repo = await ref.watch(productRepositoryProvider.future);
  return DeleteProductUseCase(repo);
}

@riverpod
Future<GetProductByIdUseCase> getProductByIdUC(Ref ref) async {
  final repo = await ref.watch(productRepositoryProvider.future);
  return GetProductByIdUseCase(repo);
}

@riverpod
Future<Map<int, String>> variantLabels(Ref ref) async {
  final uc = await ref.watch(getAllProductsUCProvider.future);
  final products = await uc();
  return {
    for (final p in products)
      for (final v in p.variants)
        v.variantId: v.sku != null && v.sku!.isNotEmpty
            ? '${p.name} — ${v.sku}'
            : p.name,
  };
}

// ── Notifier ──────────────────────────────────────────────────────────────────

@riverpod
class ProductNotifier extends _$ProductNotifier {
  Future<GetAllProductsUseCase> get _getAllUC =>
      ref.read(getAllProductsUCProvider.future);
  Future<CreateProductUseCase> get _createUC =>
      ref.read(createProductUCProvider.future);
  Future<UpdateProductUseCase> get _updateUC =>
      ref.read(updateProductUCProvider.future);
  Future<AddProductImageUseCase> get _addImageUC =>
      ref.read(addProductImageUCProvider.future);
  Future<SetPrimaryImageUseCase> get _setPrimaryUC =>
      ref.read(setPrimaryImageUCProvider.future);
  Future<DeleteProductImageUseCase> get _deleteImageUC =>
      ref.read(deleteProductImageUCProvider.future);
  Future<DeleteProductUseCase> get _deleteUC =>
      ref.read(deleteProductUCProvider.future);

  @override
  ProductState build() {
    Future.microtask(() => loadAll());
    return const ProductState();
  }

  // ── Load ───────────────────────────────────────────────────────────────────

  Future<void> loadAll({int? categoryId}) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final uc = await _getAllUC;
      final result = await uc(categoryId: categoryId);
      state = state.copyWith(products: result, isLoading: false);
    } on ApiException catch (e) {
      state = state.copyWith(isLoading: false, error: e.message);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  // ── Create ─────────────────────────────────────────────────────────────────

  Future<bool> create({
    required String name,
    int? categoryId,
    String? description,
    // ✅ removed: price, unit, lengthWidth, stockQuantity
  }) async {
    state = state.copyWith(isCreating: true, error: null);
    try {
      final uc = await _createUC;
      final created = await uc(
        name: name,
        categoryId: categoryId,
        description: description,
      );
      state = state.copyWith(
        products: [...state.products, created],
        isCreating: false,
      );
      ref.invalidate(variantLabelsProvider);
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

  Future<bool> updateProduct({
    required int productId,
    String? name,
    int? categoryId,
    String? description,
    // ✅ removed: price, unit, lengthWidth, stockQuantity
  }) async {
    state = state.copyWith(
      loadingIds: {...state.loadingIds, productId},
      error: null,
    );
    try {
      final uc = await _updateUC;
      final updated = await uc(
        productId: productId,
        name: name,
        categoryId: categoryId,
        description: description,
      );
      state = state.copyWith(
        products: state.products
            .map((p) => p.productId == productId ? updated : p)
            .toList(),
        loadingIds: state.loadingIds.difference({productId}),
      );
      ref.invalidate(variantLabelsProvider);
      return true;
    } on ApiException catch (e) {
      state = state.copyWith(
        error: e.message,
        loadingIds: state.loadingIds.difference({productId}),
      );
      return false;
    } catch (e) {
      state = state.copyWith(
        error: e.toString(),
        loadingIds: state.loadingIds.difference({productId}),
      );
      return false;
    }
  }

  // ── Add image ──────────────────────────────────────────────────────────────

  Future<bool> addImage({
    required int productId,
    required File image,
    bool isPrimary = false,
    int sortOrder = 0,
  }) async {
    state = state.copyWith(
      loadingIds: {...state.loadingIds, productId},
      error: null,
    );
    try {
      final uc = await _addImageUC;
      await uc(
        productId: productId,
        image: image,
        isPrimary: isPrimary,
        sortOrder: sortOrder,
      );
      // ✅ refresh full product to get updated images list
      final getByIdUc = await ref.read(getProductByIdUCProvider.future);
      final refreshed = await getByIdUc(productId);
      state = state.copyWith(
        products: state.products
            .map((p) => p.productId == productId ? refreshed : p)
            .toList(),
        loadingIds: state.loadingIds.difference({productId}),
      );
      return true;
    } on ApiException catch (e) {
      state = state.copyWith(
        error: e.message,
        loadingIds: state.loadingIds.difference({productId}),
      );
      return false;
    } catch (e) {
      state = state.copyWith(
        error: e.toString(),
        loadingIds: state.loadingIds.difference({productId}),
      );
      return false;
    }
  }

  // ── Set primary image ──────────────────────────────────────────────────────

  Future<bool> setPrimaryImage({
    required int productId,
    required int imageId,
  }) async {
    state = state.copyWith(
      loadingIds: {...state.loadingIds, productId},
      error: null,
    );
    try {
      final uc = await _setPrimaryUC;
      await uc(productId: productId, imageId: imageId);
      final getByIdUc = await ref.read(getProductByIdUCProvider.future);
      final refreshed = await getByIdUc(productId);
      state = state.copyWith(
        products: state.products
            .map((p) => p.productId == productId ? refreshed : p)
            .toList(),
        loadingIds: state.loadingIds.difference({productId}),
      );
      return true;
    } on ApiException catch (e) {
      state = state.copyWith(
        error: e.message,
        loadingIds: state.loadingIds.difference({productId}),
      );
      return false;
    } catch (e) {
      state = state.copyWith(
        error: e.toString(),
        loadingIds: state.loadingIds.difference({productId}),
      );
      return false;
    }
  }

  // ── Delete image ───────────────────────────────────────────────────────────

  Future<bool> deleteImage({
    required int productId,
    required int imageId,
  }) async {
    state = state.copyWith(
      loadingIds: {...state.loadingIds, productId},
      error: null,
    );
    try {
      final uc = await _deleteImageUC;
      await uc(productId: productId, imageId: imageId);
      state = state.copyWith(
        products: state.products.map((p) {
          if (p.productId != productId) return p;
          return p.copyWith(
            images: p.images.where((i) => i.imageId != imageId).toList(),
          );
        }).toList(),
        loadingIds: state.loadingIds.difference({productId}),
      );
      return true;
    } on ApiException catch (e) {
      state = state.copyWith(
        error: e.message,
        loadingIds: state.loadingIds.difference({productId}),
      );
      return false;
    } catch (e) {
      state = state.copyWith(
        error: e.toString(),
        loadingIds: state.loadingIds.difference({productId}),
      );
      return false;
    }
  }

  // ── Delete ─────────────────────────────────────────────────────────────────

  Future<bool> delete(int productId) async {
    state = state.copyWith(
      loadingIds: {...state.loadingIds, productId},
      error: null,
    );
    try {
      final uc = await _deleteUC;
      await uc(productId);
      state = state.copyWith(
        products: state.products
            .where((p) => p.productId != productId)
            .toList(),
        loadingIds: state.loadingIds.difference({productId}),
      );
      ref.invalidate(variantLabelsProvider);
      return true;
    } on ApiException catch (e) {
      state = state.copyWith(
        error: e.message,
        loadingIds: state.loadingIds.difference({productId}),
      );
      return false;
    } catch (e) {
      state = state.copyWith(
        error: e.toString(),
        loadingIds: state.loadingIds.difference({productId}),
      );
      return false;
    }
  }

  void clearError() => state = state.copyWith(error: null);
}
