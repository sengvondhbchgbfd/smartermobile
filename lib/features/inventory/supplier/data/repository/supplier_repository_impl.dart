import 'dart:io';

import 'package:frontendmobile/features/inventory/supplier/data/datasources/supplier_remote_datasource.dart';
import 'package:frontendmobile/features/inventory/supplier/domain/entities/supplier.dart';
import 'package:frontendmobile/features/inventory/supplier/domain/repository/supplier_repositories.dart';

class SupplierRepositoryImpl implements SupplierRepository {
  final SupplierRemoteDataSource _remote;
  const SupplierRepositoryImpl(this._remote);

  @override
  Future<List<SupplierEntity>> getAll() => _remote.getAll();
  @override
  Future<SupplierEntity> getById(int id) => _remote.getById(id);
  @override
  Future<SupplierEntity> create({
    required String name,
    String? contactPerson,
    String? phone,
    String? phone2,
    String? email,
    String? address,
    File? avatar,
  }) => _remote.create(
    name: name,
    contactPerson: contactPerson,
    phone: phone,
    phone2: phone2,
    email: email,
    address: address,
    avatar: avatar,
  );
  @override
  Future<SupplierEntity> update({
    required int supplierId,
    required String name,
    String? contactPerson,
    String? phone,
    String? phone2,
    String? email,
    String? address,
    File? avatar,
  }) => _remote.update(
    supplierId: supplierId,
    name: name,
    contactPerson: contactPerson,
    phone: phone,
    phone2: phone2,
    email: email,
    address: address,
    avatar: avatar,
  );
  @override
  Future<void> deleteAvatar(int id) => _remote.deleteAvatar(id);
  @override
  Future<void> delete(int id) => _remote.delete(id);
}