// lib/features/company/domain/usecases/update_company_status_usecase.dart

import 'package:dartz/dartz.dart';
import 'package:frontendmobile/core/errors/failures.dart';
import 'package:frontendmobile/features/company/domain/entities/compay_status_history_entity.dart';
import 'package:frontendmobile/features/company/domain/repositories/company_repository.dart';

class UpdateCompanyStatusParams {
  final int companyId;
  final String status;
  final String? reason;

  const UpdateCompanyStatusParams({
    required this.companyId,
    required this.status,
    this.reason,
  });
}

class UpdateCompanyStatusUseCase {
  final CompanyRepository repo;
  UpdateCompanyStatusUseCase(this.repo);

  Future<Either<Failure, CompanyStatusHistoryEntity>> call(
    UpdateCompanyStatusParams params,
  ) {
    return repo.updateStatus(
      companyId: params.companyId,
      status: params.status,
      reason: params.reason,
    );
  }
}
