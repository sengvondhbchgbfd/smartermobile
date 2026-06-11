import 'package:dartz/dartz.dart';
import 'package:frontendmobile/core/errors/failures.dart';
import 'package:frontendmobile/features/company/domain/entities/company_entity.dart';
import 'package:frontendmobile/features/company/domain/repositories/company_repository.dart';

class GetCompanyUseCase {
  final CompanyRepository repository;
  GetCompanyUseCase(this.repository);
  Future<Either<Failure, CompanyEntity>> call(int companyId) {
    return repository.getCompany(companyId);
  }
}
