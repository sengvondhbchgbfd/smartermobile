import 'dart:io';
import '../entities/customer_entity.dart';
import '../repositories/customer_repository.dart';

class GetAllCustomersUseCase {
  final CustomerRepository _repo;
  const GetAllCustomersUseCase(this._repo);
  Future<List<CustomerEntity>> call() => _repo.getAll();
}

class GetCustomerByIdUseCase {
  final CustomerRepository _repo;
  const GetCustomerByIdUseCase(this._repo);
  Future<CustomerEntity> call(int id) => _repo.getById(id);
}

class CreateCustomerUseCase {
  final CustomerRepository _repo;
  const CreateCustomerUseCase(this._repo);
  Future<CustomerEntity> call({
    required String name,
    String? phone,
    String? email,
    String? address,
    File? avatar,
  }) => _repo.create(
    name: name,
    phone: phone,
    email: email,
    address: address,
    avatar: avatar,
  );
}

class UpdateCustomerUseCase {
  final CustomerRepository _repo;
  const UpdateCustomerUseCase(this._repo);
  Future<CustomerEntity> call({
    required int customerId,
    String? name,
    String? phone,
    String? email,
    String? address,
    File? avatar,
    bool? removeAvatar,
  }) => _repo.update(
    customerId: customerId,
    name: name,
    phone: phone,
    email: email,
    address: address,
    avatar: avatar,
  );
}

class DeleteCustomerAvatarUseCase {
  final CustomerRepository _repo;
  const DeleteCustomerAvatarUseCase(this._repo);
  Future<void> call(int id) => _repo.deleteAvatar(id);
}

class DeleteCustomerUseCase {
  final CustomerRepository _repo;
  const DeleteCustomerUseCase(this._repo);
  Future<void> call(int id) => _repo.delete(id);
}
