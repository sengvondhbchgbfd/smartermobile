import 'package:dio/dio.dart';
import 'package:frontendmobile/core/errors/exceptions.dart';
import 'package:frontendmobile/features/company/data/datasources/company_remote_datasource.dart';
import 'package:frontendmobile/features/company/data/datasources/base_remote_datasource.dart';
import 'package:frontendmobile/features/company/data/models/company_model.dart';
import 'package:frontendmobile/features/company/data/models/register_response_model.dart'; // ← add
import 'package:frontendmobile/features/company/domain/usecases/register_company_usecase.dart'; // ← add

class CompanyRemoteDataSourceImpl extends BaseRemoteDatasource
    implements CompanyRemoteDatasource {
  final Dio dio;
  CompanyRemoteDataSourceImpl(this.dio);

  // ── Register Company + Admin ──────────────────────────────────────────
  @override
  Future<RegisterResponseModel> registerCompany(
    RegisterCompanyParams params, // ← changed
  ) {
    return safeRequest(
      request: () => dio.post(
        '/setup/register',
        data: {
          'company_name': params.companyName,
          'company_code': params.companyCode,
          'username': params.username,
          'password': params.password,
          'full_name': params.fullName,
          if (params.email != null) 'email': params.email,
          if (params.phone != null) 'phone': params.phone,
          if (params.maxUsers != null) 'max_users': params.maxUsers,
          if (params.timezone != null) 'timezone': params.timezone,
          if (params.currency != null) 'currency': params.currency,
          'plan_type': params.planType,
        },
      ),
      parser: (data) {
        print('DEBUG RESPONSE: $data'); 
        return RegisterResponseModel.fromJson(data);
      },
    );
  }

  // ── Get Company ───────────────────────────────────────────────────────
  @override
  Future<CompanyModel> getCompany(int companyId) {
    return safeRequest(
      request: () => dio.get('/companies/$companyId'),
      parser: (data) => CompanyModel.fromJson(data),
    );
  }

  // ── Update Company ────────────────────────────────────────────────────
  @override
  Future<CompanyModel> updateCompany({
    required int companyId,
    Map<String, dynamic>? data,
  }) {
    return safeRequest(
      request: () => dio.patch('/companies/$companyId', data: data),
      parser: (data) => CompanyModel.fromJson(data),
    );
  }

  // ── Upload Logo ───────────────────────────────────────────────────────
  @override
  Future<String> uploadLogo({
    required int companyId,
    required String filePath,
    String? oldLogoPublicId,
  }) {
    return safeRequest<String>(
      request: () async {
        final formData = FormData.fromMap({
          'logo': await MultipartFile.fromFile(filePath),
          if (oldLogoPublicId != null) 'old_logo_public_id': oldLogoPublicId,
        });
        return dio.patch('/companies/$companyId/media', data: formData);
      },
      parser: (data) {
        final logoUrl = data?['logo_url'];
        if (logoUrl == null || logoUrl is! String) {
          throw ServerEception(
            message: 'Invalid logo upload response',
            statusCode: 500,
          );
        }
        return logoUrl;
      },
    );
  }
}
