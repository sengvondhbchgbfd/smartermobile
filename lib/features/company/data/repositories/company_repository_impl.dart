import 'package:dartz/dartz.dart';
import 'package:frontendmobile/core/errors/exceptions.dart';
import 'package:frontendmobile/core/errors/failures.dart';
import 'package:frontendmobile/features/company/data/datasources/company_remote_datasource.dart';
import 'package:frontendmobile/features/company/domain/entities/company_entity.dart';
import 'package:frontendmobile/features/company/domain/entities/register_response_entity.dart'; // ← add
import 'package:frontendmobile/features/company/domain/repositories/company_repository.dart';
import 'package:frontendmobile/features/company/domain/usecases/register_company_usecase.dart'; // ← add

class CompanyRepositoryImpl implements CompanyRepository {
  final CompanyRemoteDatasource remoteDatasource;
  CompanyRepositoryImpl(this.remoteDatasource);

  // ── Register Company ──────────────────────────────────────────────────
  @override
  Future<Either<Failure, RegisterResponseEntity>> registerCompany(
    RegisterCompanyParams params,
  ) async {
    try {
      final result = await remoteDatasource.registerCompany(params);
      return Right(result);
    } on ServerEception catch (e) {
      return Left(ServerFailure(message: e.message, statusCode: e.statusCode));
    } catch (e) {
      return Left(ServerFailure(message: e.toString(), statusCode: 500));
    }
  }


  

  // ── Get Company ───────────────────────────────────────────────────────
  @override
  Future<Either<Failure, CompanyEntity>> getCompany(int companyId) async {
    try {
      final result = await remoteDatasource.getCompany(companyId);
      return Right(result);
    } on ServerEception catch (e) {
      return Left(ServerFailure(message: e.message, statusCode: e.statusCode));
    } catch (e) {
      return Left(ServerFailure(message: e.toString(), statusCode: 500));
    }
  }

  // ── Update Company ────────────────────────────────────────────────────
  @override
  Future<Either<Failure, CompanyEntity>> updateCompany({
    required int companyId,
    String? companyName,
    String? email,
    String? phone,
    String? timezone,
    String? currency,
  }) async {
    try {
      final data = <String, dynamic>{};
      if (companyName != null) data['company_name'] = companyName;
      if (email != null) data['email'] = email;
      if (phone != null) data['phone'] = phone;
      if (timezone != null) data['timezone'] = timezone;
      if (currency != null) data['currency'] = currency;

      final result = await remoteDatasource.updateCompany(
        companyId: companyId,
        data: data,
      );
      return Right(result);
    } on ServerEception catch (e) {
      return Left(ServerFailure(message: e.message, statusCode: e.statusCode));
    } catch (e) {
      return Left(ServerFailure(message: e.toString(), statusCode: 500));
    }
  }

  // ── Upload Logo ───────────────────────────────────────────────────────
  @override
  Future<Either<Failure, String>> uploadLogo({
    required int companyId,
    required String filePath,
    String? oldLogoPublicId,
  }) async {
    try {
      final url = await remoteDatasource.uploadLogo(
        companyId: companyId,
        filePath: filePath,
        oldLogoPublicId: oldLogoPublicId,
      );
      return Right(url);
    } on ServerEception catch (e) {
      return Left(ServerFailure(message: e.message, statusCode: e.statusCode));
    } catch (e) {
      return Left(ServerFailure(message: e.toString(), statusCode: 500));
    }
  }
}
