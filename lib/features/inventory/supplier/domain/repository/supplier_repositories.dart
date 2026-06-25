import 'dart:io';
import 'package:frontendmobile/features/inventory/supplier/domain/entities/supplier.dart';

abstract class SupplierRepository {
  Future<List<SupplierEntity>> getAll();
  Future<SupplierEntity> getById(int supplierId);
  Future<SupplierEntity> create({
    required String name,
    String? contactPerson,
    String? phone,
    String? phone2,
    String? email,
    String? address,
    File? avatar,
  });
  Future<SupplierEntity> update({
    required int supplierId,
    required String name,
    String? contactPerson,
    String? phone,
    String? phone2,
    String? email,
    String? address,
    File? avatar,
  });
  Future<void> deleteAvatar(int supplierId);
  Future<void> delete(int supplierId);
}
