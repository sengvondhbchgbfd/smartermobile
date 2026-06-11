class CompanyEntity {
  final int id;
  final String companyName;
  final String? companyCode;
  final String? email;
  final String? phone;
  final String? address;
  final String planType;
  final String status;
  final String? timezone;
  final String? currency;
  final int? maxUsers;
  final String? logoUrl;
  final String? logoPublicId;
  final String? bannerUrl;
  final String? bannerPublicId;
  final DateTime? createdAt;
  final DateTime? expiresAt;

  const CompanyEntity({
    required this.id,
    required this.companyName,
    this.companyCode,
    this.email,
    this.phone,
    this.address,
    required this.planType,
    required this.status,
    this.timezone,
    this.currency,
    this.maxUsers,
    this.logoUrl,
    this.logoPublicId,
    this.bannerUrl,
    this.bannerPublicId,
    this.createdAt,
    this.expiresAt,
  });
}
