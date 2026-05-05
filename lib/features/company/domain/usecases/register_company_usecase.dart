import 'package:dartz/dartz.dart';
import 'package:frontendmobile/core/errors/failures.dart';
import '../entities/register_response_entity.dart';  // ← changed from company_entity
import '../repositories/company_repository.dart';

class RegisterCompanyParams {
  final String companyName;
  final String companyCode;
  final String username;
  final String password;
  final String fullName;
  final String? email;
  final String? phone;
  final int? maxUsers;
  final String? timezone;
  final String? currency;
  final String planType;

  const RegisterCompanyParams({
    required this.companyName,
    required this.companyCode,
    required this.username,
    required this.password,
    required this.fullName,
    this.email,
    this.phone,
    this.maxUsers,
    this.timezone,
    this.currency,
    this.planType = 'free',
  });
}

class RegisterCompanyUseCase {
  final CompanyRepository repository;
  RegisterCompanyUseCase(this.repository);

  Future<Either<Failure, RegisterResponseEntity>> call(  // ← changed return type
    RegisterCompanyParams params,
  ) {
    return repository.registerCompany(params);  // ← pass whole params object
  }
}