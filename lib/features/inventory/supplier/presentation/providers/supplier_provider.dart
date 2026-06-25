import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontendmobile/core/errors/exceptions.dart';
import 'package:frontendmobile/features/inventory/supplier/data/datasources/supplier_remote_datasource.dart';
import 'package:frontendmobile/features/inventory/supplier/data/repository/supplier_repository_impl.dart';
import 'package:frontendmobile/features/inventory/supplier/domain/repository/supplier_repositories.dart';
import 'package:frontendmobile/features/inventory/supplier/presentation/providers/supplier_state.dart';
import 'package:frontendmobile/shared/providers/core_providers.dart'
    show dioClientProvider;
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../domain/usecase/supplier_usecase.dart';
part 'supplier_provider.g.dart';

// ── Infrastructure ────────────────────────────────────────────────────────────

@riverpod
Future<SupplierRemoteDataSource> supplierDataSource(Ref ref) async {
  final dioClient = await ref.watch(dioClientProvider.future);
  return SupplierRemoteDataSourceImpl(dioClient);
}

@riverpod
Future<SupplierRepository> supplierRepository(Ref ref) async {
  final dataSource = await ref.watch(supplierDataSourceProvider.future);
  return SupplierRepositoryImpl(dataSource);
}

// ── Use-case providers ─────────────────────────────────────────────────────────

@riverpod
Future<GetAllSuppliersUseCase> getAllSuppliersUC(Ref ref) async {
  final repo = await ref.watch(supplierRepositoryProvider.future);
  return GetAllSuppliersUseCase(repo);
}

@riverpod
Future<CreateSupplierUseCase> createSupplierUC(Ref ref) async {
  final repo = await ref.watch(supplierRepositoryProvider.future);
  return CreateSupplierUseCase(repo);
}

@riverpod
Future<UpdateSupplierUseCase> updateSupplierUC(Ref ref) async {
  final repo = await ref.watch(supplierRepositoryProvider.future);
  return UpdateSupplierUseCase(repo);
}

@riverpod
Future<DeleteSupplierAvatarUseCase> deleteSupplierAvatarUC(Ref ref) async {
  final repo = await ref.watch(supplierRepositoryProvider.future);
  return DeleteSupplierAvatarUseCase(repo);
}

@riverpod
Future<DeleteSupplierUseCase> deleteSupplierUC(Ref ref) async {
  final repo = await ref.watch(supplierRepositoryProvider.future);
  return DeleteSupplierUseCase(repo);
}

// ── Notifier ────────────────────────────────────────────────────────────────

@riverpod
class SupplierNotifier extends _$SupplierNotifier {
  @override
  SupplierState build() => const SupplierState();

  Future<GetAllSuppliersUseCase> get _getAllUC =>
      ref.read(getAllSuppliersUCProvider.future);
  Future<CreateSupplierUseCase> get _createUC =>
      ref.read(createSupplierUCProvider.future);
  Future<UpdateSupplierUseCase> get _updateUC =>
      ref.read(updateSupplierUCProvider.future);
  Future<DeleteSupplierAvatarUseCase> get _deleteAvatarUC =>
      ref.read(deleteSupplierAvatarUCProvider.future);
  Future<DeleteSupplierUseCase> get _deleteUC =>
      ref.read(deleteSupplierUCProvider.future);

  // ── Load ──────────────────────────────────────────────────────────────────

  Future<void> loadAll() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final uc = await _getAllUC;
      state = state.copyWith(suppliers: await uc(), isLoading: false);
    } on ApiException catch (e) {
      state = state.copyWith(isLoading: false, error: e.message);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  // ── Create ────────────────────────────────────────────────────────────────

  Future<bool> create({
    required String name,
    String? contactPerson,
    String? phone,
    String? phone2,
    String? email,
    String? address,
    File? avatar,
  }) async {
    state = state.copyWith(isCreating: true, error: null);
    try {
      final uc = await _createUC;
      final created = await uc(
        name: name,
        contactPerson: contactPerson,
        phone: phone,
        phone2: phone2,
        email: email,
        address: address,
        avatar: avatar,
      );
      state = state.copyWith(
        suppliers: [...state.suppliers, created],
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

  // ── Update ────────────────────────────────────────────────────────────────

  Future<bool> update({
    required int supplierId,
    required String name,
    String? contactPerson,
    String? phone,
    String? phone2,
    String? email,
    String? address,
    File? avatar,
  }) async {
    state = state.copyWith(
      loadingIds: {...state.loadingIds, supplierId},
      error: null,
    );
    try {
      final uc = await _updateUC;
      final updated = await uc(
        supplierId: supplierId,
        name: name,
        contactPerson: contactPerson,
        phone: phone,
        phone2: phone2,
        email: email,
        address: address,
        avatar: avatar,
      );
      state = state.copyWith(
        suppliers: state.suppliers
            .map((s) => s.supplierId == supplierId ? updated : s)
            .toList(),
        loadingIds: state.loadingIds.difference({supplierId}),
      );
      return true;
    } on ApiException catch (e) {
      state = state.copyWith(
        error: e.message,
        loadingIds: state.loadingIds.difference({supplierId}),
      );
      return false;
    } catch (e) {
      state = state.copyWith(
        error: e.toString(),
        loadingIds: state.loadingIds.difference({supplierId}),
      );
      return false;
    }
  }

  // ── Delete avatar ─────────────────────────────────────────────────────────

  Future<bool> deleteAvatar(int supplierId) async {
    state = state.copyWith(
      loadingIds: {...state.loadingIds, supplierId},
      error: null,
    );
    try {
      final uc = await _deleteAvatarUC;
      await uc(supplierId);

      // Refresh items to inherit updated layout schema from server safely
      await loadAll();
      state = state.copyWith(
        loadingIds: state.loadingIds.difference({supplierId}),
      );
      return true;
    } on ApiException catch (e) {
      state = state.copyWith(
        error: e.message,
        loadingIds: state.loadingIds.difference({supplierId}),
      );
      return false;
    } catch (e) {
      state = state.copyWith(
        error: e.toString(),
        loadingIds: state.loadingIds.difference({supplierId}),
      );
      return false;
    }
  }

  // ── Delete ────────────────────────────────────────────────────────────────

  Future<bool> delete(int supplierId) async {
    state = state.copyWith(
      loadingIds: {...state.loadingIds, supplierId},
      error: null,
    );
    try {
      final uc = await _deleteUC;
      await uc(supplierId);
      state = state.copyWith(
        suppliers: state.suppliers
            .where((s) => s.supplierId != supplierId)
            .toList(),
        loadingIds: state.loadingIds.difference({supplierId}),
      );
      return true;
    } on ApiException catch (e) {
      state = state.copyWith(
        error: e.message,
        loadingIds: state.loadingIds.difference({supplierId}),
      );
      return false;
    } catch (e) {
      state = state.copyWith(
        error: e.toString(),
        loadingIds: state.loadingIds.difference({supplierId}),
      );
      return false;
    }
  }

  void clearError() => state = state.copyWith(error: null);
}
