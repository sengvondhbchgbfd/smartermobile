import 'package:dartz/dartz.dart';
import 'package:frontendmobile/core/errors/failures.dart';
import '../entities/company_entity.dart';
import '../repositories/company_repository.dart';

/////////////////////////////////////////////////////////////

class UpdateCompanyParams {
  final int companyId;
  final String? companyName;
  final String? email;
  final String? phone;
  final String? address;
  final int? max_users;
  final String? timezone;
  final String? currency;

  const UpdateCompanyParams({
    required this.companyId,
    this.companyName,
    this.email,
    this.phone,
    this.address,
    this.max_users,
    this.timezone,
    this.currency,
  });
}

///////////////////////////////////////////////////////////////////

class UpdateCompanyUseCase {
  final CompanyRepository repository;

  UpdateCompanyUseCase(this.repository);

  Future<Either<Failure, CompanyEntity>> call(UpdateCompanyParams params) {
    return repository.updateCompany(
      companyId: params.companyId,
      companyName: params.companyName,
      email: params.email,
      phone: params.phone,
      address: params.address,
      max_users: params.max_users,
      timezone: params.timezone,
      currency: params.currency,
    );
  }
}
