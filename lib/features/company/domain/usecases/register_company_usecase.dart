import 'package:dartz/dartz.dart';
import 'package:frontendmobile/core/errors/failures.dart';
import '../entities/register_response_entity.dart';
import '../repositories/company_repository.dart';

class RegisterCompanyParams {
  final String companyCode;
  final String companyName;
  final String currency;
  final String email;
  final int maxUsers;
  final String planType;
  final String timezone;

  // ── Owner / first user — becomes this company's superuser ──────────────
  final String adminUsername;
  final String adminPassword;
  final String adminFullName;

  const RegisterCompanyParams({
    required this.companyCode,
    required this.companyName,
    required this.currency,
    required this.email,
    required this.maxUsers,
    required this.timezone,
    required this.adminUsername,
    required this.adminPassword,
    required this.adminFullName,
    this.planType = 'free',
  });
}

class RegisterCompanyUseCase {
  final CompanyRepository repository;
  RegisterCompanyUseCase(this.repository);

  Future<Either<Failure, RegisterResponseEntity>> call(
    RegisterCompanyParams params,
  ) {
    return repository.registerCompany(params);
  }
}