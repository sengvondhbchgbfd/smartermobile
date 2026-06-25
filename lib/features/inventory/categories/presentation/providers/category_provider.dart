import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontendmobile/core/errors/exceptions.dart';
import 'package:frontendmobile/features/inventory/categories/data/repositories/category_repository_impl.dart';
import 'package:frontendmobile/features/inventory/categories/domain/repositories/category_repository.dart';
import 'package:frontendmobile/features/inventory/categories/domain/usecase/category_usecase.dart';
import 'package:frontendmobile/features/inventory/categories/presentation/providers/category_state.dart';
import 'package:frontendmobile/shared/providers/core_providers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../data/datasources/category_remote_datasource.dart';
part 'category_provider.g.dart';

// ─── Infrastructure providers ────────────────────────────────────────────────

@riverpod
Future<CategoryRemoteDataSource> categoryDataSource(Ref ref) async {
  final dioClient = await ref.watch(dioClientProvider.future);
  return CategoryRemoteDataSourceImpl(dioClient);
}

@riverpod
Future<CategoryRepository> categoryRepository(Ref ref) async {
  final dataSource = await ref.watch(categoryDataSourceProvider.future);
  return CategoryRepositoryImpl(dataSource);
}

// ─── Use-case providers ───────────────────────────────────────────────────────

@riverpod
Future<GetAllCategoriesUseCase> getAllCategoriesUC(Ref ref) async {
  final repo = await ref.watch(categoryRepositoryProvider.future);
  return GetAllCategoriesUseCase(repo);
}

@riverpod
Future<CreateCategoryUseCase> createCategoryUC(Ref ref) async {
  final repo = await ref.watch(categoryRepositoryProvider.future);
  return CreateCategoryUseCase(repo);
}

@riverpod
Future<UpdateCategoryUseCase> updateCategoryUC(Ref ref) async {
  final repo = await ref.watch(categoryRepositoryProvider.future);
  return UpdateCategoryUseCase(repo);
}

@riverpod
Future<DeleteCategoryImageUseCase> deleteCategoryImageUC(Ref ref) async {
  final repo = await ref.watch(categoryRepositoryProvider.future);
  return DeleteCategoryImageUseCase(repo);
}

@riverpod
Future<DeleteCategoryUseCase> deleteCategoryUC(Ref ref) async {
  final repo = await ref.watch(categoryRepositoryProvider.future);
  return DeleteCategoryUseCase(repo);
}

// ─── Notifier ────────────────────────────────────────────────────────────────

@riverpod
class CategoryNotifier extends _$CategoryNotifier {
  @override
  CategoryState build() => const CategoryState();

  Future<GetAllCategoriesUseCase> get _getAllUC =>
      ref.read(getAllCategoriesUCProvider.future);
  Future<CreateCategoryUseCase> get _createUC =>
      ref.read(createCategoryUCProvider.future);
  Future<UpdateCategoryUseCase> get _updateUC =>
      ref.read(updateCategoryUCProvider.future);
  Future<DeleteCategoryImageUseCase> get _deleteImageUC =>
      ref.read(deleteCategoryImageUCProvider.future);
  Future<DeleteCategoryUseCase> get _deleteUC =>
      ref.read(deleteCategoryUCProvider.future);

  // ── Load ──────────────────────────────────────────────────────────────────

  Future<void> loadAll() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final uc = await _getAllUC;
      final categories = await uc();
      state = state.copyWith(categories: categories, isLoading: false);
    } on ApiException catch (e) {
      state = state.copyWith(isLoading: false, error: e.message);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  // ── Create ────────────────────────────────────────────────────────────────

  Future<bool> create({required String categoryName, File? image}) async {
    try {
      final uc = await _createUC;
      final category = await uc(categoryName: categoryName, image: image);
      state = state.copyWith(categories: [...state.categories, category]);
      return true;
    } on ApiException catch (e) {
      state = state.copyWith(error: e.message);
      return false;
    } catch (e) {
      state = state.copyWith(error: e.toString());
      return false;
    }
  }

  // ── Update ────────────────────────────────────────────────────────────────

  Future<bool> update({
    required int categoryId,
    String? categoryName,
    File? image,
  }) async {
    state = state.copyWith(
      loadingIds: {...state.loadingIds, categoryId},
      clearError: true,
    );

    try {
      final uc = await _updateUC;
      final updated = await uc(
        categoryId: categoryId,
        categoryName: categoryName,
        image: image,
      );
      state = state.copyWith(
        categories: state.categories
            .map((c) => c.categoryId == categoryId ? updated : c)
            .toList(),
        loadingIds: state.loadingIds.difference({categoryId}),
      );
      return true;
    } on ApiException catch (e) {
      state = state.copyWith(error: e.message);
      return false;
    } catch (e) {
      state = state.copyWith(error: e.toString());
      return false;
    }
  }

  // ── Delete image ──────────────────────────────────────────────────────────

  Future<bool> deleteImage(int categoryId) async {
    try {
      final uc = await _deleteImageUC;
      await uc(categoryId);
      await loadAll();
      return true;
    } on ApiException catch (e) {
      state = state.copyWith(error: e.message);
      return false;
    } catch (e) {
      state = state.copyWith(error: e.toString());
      return false;
    }
  }

  // ── Delete ────────────────────────────────────────────────────────────────

  Future<bool> delete(int categoryId) async {
    state = state.copyWith(
      loadingIds: {...state.loadingIds, categoryId},
      clearError: true,
    );
    try {
      final uc = await _deleteUC;
      await uc(categoryId);
      state = state.copyWith(
        categories: state.categories
            .where((c) => c.categoryId != categoryId)
            .toList(),
        loadingIds: state.loadingIds.difference({categoryId}),
      );
      return true;
    } on ApiException catch (e) {
      state = state.copyWith(
        error: e.message,
        loadingIds: state.loadingIds.difference({categoryId}),
      );
      return false;
    } catch (e) {
      state = state.copyWith(
        error: e.toString(),
        loadingIds: state.loadingIds.difference({categoryId}),
      );
      return false;
    }
  }

  void clearError() => state = state.copyWith(error: null);
}
