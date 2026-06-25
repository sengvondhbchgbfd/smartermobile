class SupplierEntity {
  final int supplierId;
  final int companyId;
  final String name;
  final String? contactPerson;
  final String? phone;
  final String? phone2; // ✅ add
  final String? email;
  final String? address;
  final String? avatarUrl;
  final String? avatarPublicId;
  final DateTime createdAt;
  final DateTime updatedAt;

  const SupplierEntity({
    required this.supplierId,
    required this.companyId,
    required this.name,
    this.contactPerson,
    this.phone,
    this.phone2, // ✅ add
    this.email,
    this.address,
    this.avatarUrl,
    this.avatarPublicId,
    required this.createdAt,
    required this.updatedAt,
  });
}
