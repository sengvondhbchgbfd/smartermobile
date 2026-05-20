import 'package:dartz/dartz.dart';
import 'package:frontendmobile/core/errors/failures.dart';
import 'package:frontendmobile/features/company/domain/entities/company_entity.dart';
import 'package:frontendmobile/features/company/domain/entities/register_response_entity.dart'; // ← add
import 'package:frontendmobile/features/company/domain/usecases/register_company_usecase.dart'; // ← add

abstract class CompanyRepository {
  // ── Register Company ──────────────────────────────────────────────────
  Future<Either<Failure, RegisterResponseEntity>> registerCompany(
    RegisterCompanyParams params,
  );



  // ── Get Company ───────────────────────────────────────────────────────

  Future<Either<Failure, CompanyEntity>> getCompany(int companyId);

  // ── Update Company ────────────────────────────────────────────────────
  Future<Either<Failure, CompanyEntity>> updateCompany({
    required int companyId,
    String? companyName,
    String? email,
    String? phone,
    String? address,
    int? max_users,
    String? timezone,
    String? currency,
  });

  // ── Upload Logo ───────────────────────────────────────────────────────
  Future<Either<Failure, String>> uploadLogo({
    required int companyId,
    required String filePath,
    String? oldLogoPublicId,
  });
}
