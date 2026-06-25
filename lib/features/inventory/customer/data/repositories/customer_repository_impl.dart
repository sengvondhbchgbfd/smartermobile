import 'dart:io';
import '../../domain/entities/customer_entity.dart';
import '../../domain/repositories/customer_repository.dart';
import '../datasources/customer_remote_datasource.dart';

class CustomerRepositoryImpl implements CustomerRepository {
  final CustomerRemoteDataSource _remote;
  const CustomerRepositoryImpl(this._remote);

  @override
  Future<List<CustomerEntity>> getAll() => _remote.getAll();
  @override
  Future<CustomerEntity> getById(int id) => _remote.getById(id);
  @override
  Future<CustomerEntity> create({
    required String name,
    String? phone,
    String? email,
    String? address,
    File? avatar,
  }) => _remote.create(
    name: name,
    phone: phone,
    email: email,
    address: address,
    avatar: avatar,
  );
  @override
  Future<CustomerEntity> update({
    required int customerId,
    String? name,
    String? phone,
    String? email,
    String? address,
    File? avatar,
  }) => _remote.update(
    customerId: customerId,
    name: name,
    phone: phone,
    email: email,
    address: address,
    avatar: avatar,
  );
  @override
  Future<void> deleteAvatar(int id) => _remote.deleteAvatar(id);
  @override
  Future<void> delete(int id) => _remote.delete(id);
}
