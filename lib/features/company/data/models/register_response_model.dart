import 'package:frontendmobile/features/company/domain/entities/register_response_entity.dart';

class RegisterResponseModel extends RegisterResponseEntity {
  const RegisterResponseModel({
    required super.companyId,
    required super.companyName,
    required super.username,
    required super.role,
    required super.message,
  });

  factory RegisterResponseModel.fromJson(Map<String, dynamic> json) {
    return RegisterResponseModel(
      companyId: json['company_id'] as int? ?? 0,
      companyName: json['company_name']?.toString() ?? '',
      username: json['username']?.toString() ?? '',
      role: json['role']?.toString() ?? '',
      message: json['message']?.toString() ?? '',
    );
  }
}
