import '../../domain/entities/customer_entity.dart';

class CustomerModel extends CustomerEntity {
  const CustomerModel({
    required super.customerId,
    required super.companyId,
    required super.name,
    super.phone,
    super.email,
    super.avatarUrl,
    super.avatarPublicId,
    super.totalPurchase = 0.0,
    required super.createdAt,
    required super.updatedAt,
  });

  factory CustomerModel.fromJson(Map<String, dynamic> j) => CustomerModel(
    customerId:     j['customer_id']     as int,
    companyId:      j['company_id']      as int,
    name:           j['name']            as String,
    phone:          j['phone']           as String?,
    email:          j['email']           as String?,
    avatarUrl:      j['avatar_url']      as String?,
    avatarPublicId: j['avatar_public_id'] as String?,
    totalPurchase:  double.tryParse(j['total_purchase']?.toString() ?? '0') ?? 0.0,
    createdAt:      DateTime.parse(j['created_at'] as String),
    updatedAt:      DateTime.parse(j['updated_at'] as String),
  );
}