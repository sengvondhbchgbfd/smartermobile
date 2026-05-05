import 'package:frontendmobile/features/company/domain/entities/company_entity.dart';

class CompanyModel extends CompanyEntity {
  const CompanyModel({
    required super.id,
    required super.companyName,
    super.companyCode,
    super.email,
    super.phone,
    required super.planType,
    required super.status,
    super.timezone,
    super.currency,
    super.maxUsers,
    super.logoUrl,
    super.logoPublicId,
    super.bannerUrl,
    super.bannerPublicId,
    super.createdAt,
    super.expiresAt,
  });

  factory CompanyModel.fromJson(Map<String, dynamic> json) {
    return CompanyModel(
      id: json['company_id'],
      companyName: json['company_name'],
      companyCode: json['company_code'],
      email: json['email'],
      phone: json['phone'],
      planType: json['plan_type'] ?? 'free',
      status: json['status'] ?? 'active',
      timezone: json['timezone'],
      currency: json['currency'],
      maxUsers: json['max_users'],
      logoUrl: json['logo_url'],
      logoPublicId: json['logo_public_id'],
      bannerUrl: json['banner_url'],
      bannerPublicId: json['banner_public_id'],
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : null,
      expiresAt: json['expires_at'] != null
          ? DateTime.parse(json['expires_at'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'company_id': id,
      'company_name': companyName,
      'company_code': companyCode,
      'email': email,
      'phone': phone,
      'plan_type': planType,
      'status': status,
      'timezone': timezone,
      'currency': currency,
      'max_users': maxUsers,
      'logo_url': logoUrl,
      'logo_public_id': logoPublicId,
      'banner_url': bannerUrl,
      'banner_public_id': bannerPublicId,
      'created_at': createdAt?.toIso8601String(),
      'expires_at': expiresAt?.toIso8601String(),
    };
  }
}
