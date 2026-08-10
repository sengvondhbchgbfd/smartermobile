import 'package:frontendmobile/features/company/data/models/company_model.dart';
import 'package:frontendmobile/features/company/data/models/register_response_model.dart'; // ← add
import 'package:frontendmobile/features/company/domain/usecases/register_company_usecase.dart'; // ← add

abstract class CompanyRemoteDatasource {
  Future<RegisterResponseModel> registerCompany(RegisterCompanyParams params);
  Future<CompanyModel> getCompany(int companyId);

  Future<CompanyModel> updateCompany({
    required int companyId,
    Map<String, dynamic>? data,
  });

  Future<String> uploadLogo({
    required int companyId,
    required String filePath,
    bool isLogo = true,
    String? oldLogoPublicId,
    String? oldBannerPublicId,
  });

  Future<Map<String, dynamic>> updateStatus({
    required int companyId,
    required String status,
    String? reason,
  });
  Future<List<Map<String, dynamic>>> getStatusHistory(int companyId);
}
