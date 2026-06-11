import 'package:dartz/dartz.dart';
import 'package:frontendmobile/core/errors/failures.dart';
import 'package:frontendmobile/features/company/domain/repositories/company_repository.dart';

class UploadLogoParams {
  final int companyId;
  final String filePath;
<<<<<<< HEAD
  final String? oldLogoPublicId; 
=======
  final bool isLogo;
  final String? oldLogoPublicId;
  final String? oldBannerPublicId;
>>>>>>> 9f1638c8060e11abffb348266a42c22f5d24569c

  const UploadLogoParams({
    required this.companyId,
    required this.filePath,
<<<<<<< HEAD
    this.oldLogoPublicId, 
=======
    this.isLogo = true,
    this.oldLogoPublicId,
    this.oldBannerPublicId,
>>>>>>> 9f1638c8060e11abffb348266a42c22f5d24569c
  });
}

class UploadCompanyLogoUseCase {
  final CompanyRepository repository;
  UploadCompanyLogoUseCase(this.repository);

  Future<Either<Failure, String>> call(UploadLogoParams params) {
    return repository.uploadLogo(
      companyId: params.companyId,
      filePath: params.filePath,
<<<<<<< HEAD
      oldLogoPublicId: params.oldLogoPublicId, 
    );
  }
}
=======
      isLogo: params.isLogo, // ✅
      oldLogoPublicId: params.oldLogoPublicId,
      oldBannerPublicId: params.oldBannerPublicId, // ✅
    );
  }
}
>>>>>>> 9f1638c8060e11abffb348266a42c22f5d24569c
