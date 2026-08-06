import '../../domain/entities/register_response_entity.dart';

class RegisterResponseModel extends RegisterResponseEntity {
  const RegisterResponseModel({
    required super.accessToken,
    required super.refreshToken,
    required super.accessExpiresIn,
    required super.refreshExpiresIn,
    required super.tokenType,
    required super.companyId,
    required super.companyName,
    required super.companyCode,
    required super.planType,
    required super.status,
    required super.maxUsers,
    required super.userId,
    required super.username,
    required super.fullName,
    required super.role,
  });

  factory RegisterResponseModel.fromJson(Map<String, dynamic> json) {
    final company = json['company'] as Map<String, dynamic>;
    final user = json['user'] as Map<String, dynamic>;

    return RegisterResponseModel(
      accessToken: json['access_token'] as String,
      refreshToken: json['refresh_token'] as String,
      accessExpiresIn: json['access_expires_in'] as int,
      refreshExpiresIn: json['refresh_expires_in'] as int,
      tokenType: json['token_type'] as String,
      companyId: company['company_id'] as int,
      companyName: company['company_name'] as String,
      companyCode: company['company_code'] as String,
      planType: company['plan_type'] as String,
      status: company['status'] as String,
      maxUsers: company['max_users'] as int,
      userId: user['user_id'] as int,
      username: user['username'] as String,
      fullName: user['full_name'] as String,
      role: user['role'] as String,
    );
  }
}
