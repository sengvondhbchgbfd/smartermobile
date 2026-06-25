import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontendmobile/core/errors/exceptions.dart';
import 'package:frontendmobile/features/inventory/customer/presentation/providers/customer_state.dart';
import 'package:frontendmobile/shared/providers/core_providers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../data/datasources/customer_remote_datasource.dart';
import '../../data/repositories/customer_repository_impl.dart';
import '../../domain/repositories/customer_repository.dart';
import '../../domain/usecase/customer_usecase.dart';

part 'customer_provider.g.dart';

// ─── Infrastructure providers ────────────────────────────────────────────────

@riverpod
Future<CustomerRemoteDataSource> customerDataSource(Ref ref) async {
  final dioClient = await ref.watch(dioClientProvider.future);
  return CustomerRemoteDataSourceImpl(dioClient);
}

@riverpod
Future<CustomerRepository> customerRepository(Ref ref) async {
  final ds = await ref.watch(customerDataSourceProvider.future);
  return CustomerRepositoryImpl(ds);
}
// ─── Use-case providers ───────────────────────────────────────────────────────

@riverpod
Future<GetAllCustomersUseCase> getAllCustomersUC(Ref ref) async {
  final repo = await ref.watch(customerRepositoryProvider.future);
  return GetAllCustomersUseCase(repo);
}

@riverpod
Future<CreateCustomerUseCase> createCustomerUC(Ref ref) async {
  final repo = await ref.watch(customerRepositoryProvider.future);
  return CreateCustomerUseCase(repo);
}

@riverpod
Future<UpdateCustomerUseCase> updateCustomerUC(Ref ref) async {
  final repo = await ref.watch(customerRepositoryProvider.future);
  return UpdateCustomerUseCase(repo);
}

@riverpod
Future<DeleteCustomerAvatarUseCase> deleteCustomerAvatarUC(Ref ref) async {
  final repo = await ref.watch(customerRepositoryProvider.future);
  return DeleteCustomerAvatarUseCase(repo);
}

@riverpod
Future<DeleteCustomerUseCase> deleteCustomerUC(Ref ref) async {
  final repo = await ref.watch(customerRepositoryProvider.future);
  return DeleteCustomerUseCase(repo);
}

// ─── Notifier ─────────────────────────────────────────────────────────────────
@riverpod
class CustomerNotifier extends _$CustomerNotifier {
  @override
  CustomerState build() => const CustomerState();
  Future<GetAllCustomersUseCase> get _getAllUC =>
      ref.read(getAllCustomersUCProvider.future);
  Future<CreateCustomerUseCase> get _createUC =>
      ref.read(createCustomerUCProvider.future);
  Future<UpdateCustomerUseCase> get _updateUC =>
      ref.read(updateCustomerUCProvider.future);
  Future<DeleteCustomerAvatarUseCase> get _deleteAvatarUC =>
      ref.read(deleteCustomerAvatarUCProvider.future);
  Future<DeleteCustomerUseCase> get _deleteUC =>
      ref.read(deleteCustomerUCProvider.future);

  Future<void> loadAll() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final uc = await _getAllUC;
      state = state.copyWith(customers: await uc(), isLoading: false);
    } on ApiException catch (e) {
      state = state.copyWith(isLoading: false, error: e.message);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<bool> create({
    required String name,
    String? phone,
    String? email,
    String? address,
    File? avatar,
  }) async {
    try {
      final uc = await _createUC;
      final c = await uc(
        name: name,
        phone: phone,
        email: email,
        address: address,
        avatar: avatar,
      );
      state = state.copyWith(customers: [...state.customers, c]);
      return true;
    } on ApiException catch (e) {
      state = state.copyWith(error: e.message);
      return false;
    }
  }

  Future<bool> update({
    required int customerId,
    String? name,
    String? phone,
    String? email,
    String? address,
    File? avatar,
    bool removeAvatar = false,
  }) async {
    state = state.copyWith(loadingIds: {...state.loadingIds, customerId});
    try {
      final uc = await _updateUC;
      final updated = await uc(
        customerId: customerId,
        name: name,
        phone: phone,
        email: email,
        address: address,
        avatar: avatar,
        removeAvatar: removeAvatar,
      );
      state = state.copyWith(
        customers: state.customers
            .map((c) => c.customerId == customerId ? updated : c)
            .toList(),
        loadingIds: state.loadingIds.difference({customerId}),
      );
      return true;
    } on ApiException catch (e) {
      state = state.copyWith(
        error: e.message,
        loadingIds: state.loadingIds.difference({customerId}),
      );
      return false;
    } catch (e) {
      state = state.copyWith(
        error: 'Connection timeout. Please try again.',
        loadingIds: state.loadingIds.difference({customerId}),
      );
      return false;
    }
  }

  Future<bool> deleteAvatar(int customerId) async {
    state = state.copyWith(loadingIds: {...state.loadingIds, customerId});
    try {
      final uc = await _deleteAvatarUC;
      await uc(customerId);
      await loadAll();

      return true;
    } on ApiException catch (e) {
      state = state.copyWith(error: e.message);
      return false;
    }
  }

  Future<bool> delete(int customerId) async {
    state = state.copyWith(loadingIds: {...state.loadingIds, customerId});
    try {
      final uc = await _deleteUC;
      await uc(customerId);
      state = state.copyWith(
        customers: state.customers
            .where((c) => c.customerId != customerId)
            .toList(),
        loadingIds: state.loadingIds.difference({customerId}),
      );
      return true;
    } on ApiException catch (e) {
      state = state.copyWith(
        error: e.message,
        loadingIds: state.loadingIds.difference({customerId}),
      );
      return false;
    } catch (e) {
      state = state.copyWith(
        error: 'Connection timeout. Please try again.',
        loadingIds: state.loadingIds.difference({customerId}),
      );
      return false;
    }
  }

  void clearError() => state = state.copyWith(error: null);
}
