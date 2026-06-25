import 'dart:io';
import '../entities/customer_entity.dart';

abstract class CustomerRepository {
  Future<List<CustomerEntity>> getAll();
  Future<CustomerEntity> getById(int customerId);
  Future<CustomerEntity> create({required String name, String? phone, String? email, String? address, File? avatar});
  Future<CustomerEntity> update({required int customerId, String? name, String? phone, String? email, String? address, File? avatar});
  Future<void> deleteAvatar(int customerId);
  Future<void> delete(int customerId);
}