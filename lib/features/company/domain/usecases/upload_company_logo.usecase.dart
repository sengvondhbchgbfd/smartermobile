import 'package:dartz/dartz.dart';
import 'package:frontendmobile/core/errors/failures.dart';
import 'package:frontendmobile/features/company/domain/repositories/company_repository.dart';

class UploadLogoParams {
  final int companyId;
  final String filePath;
  final bool isLogo;
  final String? oldLogoPublicId;
  final String? oldBannerPublicId;

  const UploadLogoParams({
    required this.companyId,
    required this.filePath,
    this.isLogo = true,
    this.oldLogoPublicId,
    this.oldBannerPublicId,
  });
}

class UploadCompanyLogoUseCase {
  final CompanyRepository repository;
  UploadCompanyLogoUseCase(this.repository);

  Future<Either<Failure, String>> call(UploadLogoParams params) {
    return repository.uploadLogo(
      companyId: params.companyId,
      filePath: params.filePath,
      isLogo: params.isLogo, // ✅
      oldLogoPublicId: params.oldLogoPublicId,
      oldBannerPublicId: params.oldBannerPublicId, // ✅
    );
  }
}
