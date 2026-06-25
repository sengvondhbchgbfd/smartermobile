import 'package:frontendmobile/features/inventory/supplier/domain/entities/supplier.dart';

class SupplierModel extends SupplierEntity {
  const SupplierModel({
    required super.supplierId,
    required super.companyId,
    required super.name,
    super.contactPerson,
    super.phone,
    super.phone2, // ✅ add
    super.email,
    super.address,
    super.avatarUrl,
    super.avatarPublicId,
    required super.createdAt,
    required super.updatedAt,
  });

  factory SupplierModel.fromJson(Map<String, dynamic> j) => SupplierModel(
    supplierId: j['supplier_id'] as int,
    companyId: j['company_id'] as int,
    name: j['name'] as String,
    contactPerson: j['contact_person'] as String?,
    phone: j['phone'] as String?,
    phone2: j['phone2'] as String?, // ✅ add
    email: j['email'] as String?,
    address: j['address'] as String?,
    avatarUrl: j['avatar_url'] as String?,
    avatarPublicId: j['avatar_public_id'] as String?,
    createdAt: DateTime.parse(j['created_at'] as String),
    updatedAt: DateTime.parse(j['updated_at'] as String),
  );
}
