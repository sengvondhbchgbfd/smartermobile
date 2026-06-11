import 'package:dio/dio.dart';
import 'package:frontendmobile/core/errors/exceptions.dart';
import 'package:frontendmobile/features/company/data/datasources/company_remote_datasource.dart';
import 'package:frontendmobile/features/company/data/datasources/base_remote_datasource.dart';
import 'package:frontendmobile/features/company/data/models/company_model.dart';
<<<<<<< HEAD
import 'package:frontendmobile/features/company/data/models/register_response_model.dart'; // ← add
import 'package:frontendmobile/features/company/domain/usecases/register_company_usecase.dart'; // ← add

=======
import 'package:frontendmobile/features/company/data/models/register_response_model.dart';
import 'package:frontendmobile/features/company/domain/usecases/register_company_usecase.dart';
>>>>>>> 9f1638c8060e11abffb348266a42c22f5d24569c
class CompanyRemoteDataSourceImpl extends BaseRemoteDatasource
    implements CompanyRemoteDatasource {
  final Dio dio;
  CompanyRemoteDataSourceImpl(this.dio);
<<<<<<< HEAD

  // ── Register Company + Admin ──────────────────────────────────────────
 @override
Future<RegisterResponseModel> registerCompany(
  RegisterCompanyParams params,
) {
  return safeRequest(
    request: () => dio.post(
      '/companies/',
      data: {
        'company_code': params.companyCode,
        'company_name': params.companyName,
        'currency': params.currency,
        'email': params.email,
        'max_users': params.maxUsers,
        'plan_type': params.planType,
        'timezone': params.timezone,
      },
    ),
    parser: (data) {
      print('DEBUG RESPONSE: $data');
      return RegisterResponseModel.fromJson(data);
    },
  );
}






=======
  // ── Register Company + Admin ──────────────────────────────────────────
  @override
  Future<RegisterResponseModel> registerCompany(RegisterCompanyParams params) {
    return safeRequest(
      request: () => dio.post(
        '/companies/',
        data: {
          'company_code': params.companyCode,
          'company_name': params.companyName,
          'currency': params.currency,
          'email': params.email,
          'max_users': params.maxUsers,
          'plan_type': params.planType,
          'timezone': params.timezone,
        },
      ),
      parser: (data) {
        print('DEBUG RESPONSE: $data');
        return RegisterResponseModel.fromJson(data);
      },
    );
  }
>>>>>>> 9f1638c8060e11abffb348266a42c22f5d24569c

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
<<<<<<< HEAD
=======

>>>>>>> 9f1638c8060e11abffb348266a42c22f5d24569c
  @override
  Future<String> uploadLogo({
    required int companyId,
    required String filePath,
<<<<<<< HEAD
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
=======
    bool isLogo = true,
    String? oldLogoPublicId,
    String? oldBannerPublicId,
  }) {
    return safeRequest<String>(
      request: () async {
        final fieldName = isLogo ? 'logo' : 'banner';
        final map = <String, dynamic>{
          fieldName: await MultipartFile.fromFile(filePath),
        };
        if (oldLogoPublicId != null)map['old_logo_public_id'] = oldLogoPublicId;
        if (oldBannerPublicId != null) map['old_banner_public_id'] = oldBannerPublicId;

        final formData = FormData.fromMap(map);
        return dio.patch('/companies/$companyId/media', data: formData);
      },
      parser: (data) {
        final url = isLogo ? data['logo_url'] : data['banner_url'];
        if (url == null || url is! String) {
          throw ServerEception(
            message: 'Invalid upload response',
            statusCode: 500,
          );
        }
        return url;
>>>>>>> 9f1638c8060e11abffb348266a42c22f5d24569c
      },
    );
  }
}
