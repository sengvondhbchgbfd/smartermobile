import 'dart:io';

import 'package:frontendmobile/features/inventory/supplier/domain/entities/supplier.dart';
import 'package:frontendmobile/features/inventory/supplier/domain/repository/supplier_repositories.dart';

class GetAllSuppliersUseCase {
  final SupplierRepository _repo;
  const GetAllSuppliersUseCase(this._repo);
  Future<List<SupplierEntity>> call() => _repo.getAll();
}

class GetSupplierByIdUseCase {
  final SupplierRepository _repo;
  const GetSupplierByIdUseCase(this._repo);
  Future<SupplierEntity> call(int id) => _repo.getById(id);
}

class CreateSupplierUseCase {
  final SupplierRepository _repo;
  const CreateSupplierUseCase(this._repo);
  Future<SupplierEntity> call({
    required String name,
    String? contactPerson,
    String? phone,
    String? phone2,
    String? email,
    String? address,
    File? avatar,
  }) => _repo.create(
    name: name,
    contactPerson: contactPerson,
    phone: phone,
    phone2: phone2,
    email: email,
    address: address,
    avatar: avatar,
  );
}

class UpdateSupplierUseCase {
  final SupplierRepository _repo;
  const UpdateSupplierUseCase(this._repo);
  Future<SupplierEntity> call({
    required int supplierId,
    required String name,
    String? contactPerson,
    String? phone,
    String? phone2,
    String? email,
    String? address,
    File? avatar,
  }) => _repo.update(
    supplierId: supplierId,
    name: name,
    contactPerson: contactPerson,
    phone: phone,
    phone2: phone2,
    email: email,
    address: address,
    avatar: avatar,
  );
}

class DeleteSupplierAvatarUseCase {
  final SupplierRepository _repo;
  const DeleteSupplierAvatarUseCase(this._repo);
  Future<void> call(int id) => _repo.deleteAvatar(id);
}

class DeleteSupplierUseCase {
  final SupplierRepository _repo;
  const DeleteSupplierUseCase(this._repo);
  Future<void> call(int id) => _repo.delete(id);
}
