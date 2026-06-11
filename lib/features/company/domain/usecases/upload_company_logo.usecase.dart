import 'package:dartz/dartz.dart';
import 'package:frontendmobile/core/errors/failures.dart';
import 'package:frontendmobile/features/company/domain/repositories/company_repository.dart';

class UploadLogoParams {
  final int companyId;
  final String filePath;
  final String? oldLogoPublicId; 

  const UploadLogoParams({
    required this.companyId,
    required this.filePath,
    this.oldLogoPublicId, 
  });
}

class UploadCompanyLogoUseCase {
  final CompanyRepository repository;
  UploadCompanyLogoUseCase(this.repository);

  Future<Either<Failure, String>> call(UploadLogoParams params) {
    return repository.uploadLogo(
      companyId: params.companyId,
      filePath: params.filePath,
      oldLogoPublicId: params.oldLogoPublicId, 
    );
  }
}