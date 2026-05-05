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
      companyId:   json['company_id']   as int,
      companyName: json['company_name'] as String,
      username:    json['username']     as String,
      role:        json['role']         as String,
      message:     json['message']      as String,
    );
  }
}