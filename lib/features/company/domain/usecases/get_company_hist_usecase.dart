// lib/features/company/domain/usecases/get_company_status_history_usecase.dart

import 'package:dartz/dartz.dart';
import 'package:frontendmobile/core/errors/failures.dart';
import 'package:frontendmobile/features/company/domain/entities/compay_status_history_entity.dart';
import 'package:frontendmobile/features/company/domain/repositories/company_repository.dart';

class GetCompanyStatusHistoryUseCase {
  final CompanyRepository repo;
  GetCompanyStatusHistoryUseCase(this.repo);

  Future<Either<Failure, List<CompanyStatusHistoryEntity>>> call(
    int companyId,
  ) {
    return repo.getStatusHistory(companyId);
  }
}
