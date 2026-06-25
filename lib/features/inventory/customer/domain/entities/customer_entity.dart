class CustomerEntity {
  final int customerId;
  final int companyId;
  final String name;
  final String? phone;
  final String? email;
  final String? avatarUrl;
  final String? avatarPublicId;
  final double totalPurchase;
  final DateTime createdAt;
  final DateTime updatedAt;

  const CustomerEntity({
    required this.customerId,
    required this.companyId,
    required this.name,
    this.phone,
    this.email,
    this.avatarUrl,
    this.avatarPublicId,
    this.totalPurchase = 0.0,
    required this.createdAt,
    required this.updatedAt,
  });
}