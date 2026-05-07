import 'package:dio/dio.dart';
import 'package:frontendmobile/core/errors/api_error_handler.dart';
import 'package:frontendmobile/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:frontendmobile/features/auth/data/models/register_model.dart';
import 'package:frontendmobile/features/auth/data/models/user_model.dart';
import 'package:frontendmobile/features/auth/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDatasource _datasource;
  AuthRepositoryImpl(this._datasource);

  ////////////////////////////////////////////////////////////////////////
  //
  ///////////////////////////////////////////////////////////////////////

  @override
  Future<UserModel> login(String username, String password) async {
    try {
      return await _datasource.login(username, password);
    } on DioException catch (e) {
      throw ApiErrorHandler.getMessage(e);
    }
  }

  ////////////////////////////////////////////////////////////////////////
  //
  ///////////////////////////////////////////////////////////////////////

  // @override
  // Future<bool> validateToken(String token) async {
  //   try {
  //     return await _datasource.validateToken(token);
  //   } on DioException catch (e) {
  //     throw ApiErrorHandler.getMessage(e);
  //   }
  // }

  ////////////////////////////////////////////////////////////////////////
  //
  ///////////////////////////////////////////////////////////////////////

  @override
  Future<void> register({
    required String companyName,
    required String companyCode,
    required String username,
    required String password,
    required String fullName,
    required String timezone,
    required String currency,
  }) async {
    try {
      final model = RegisterRequestModel(
        companyName: companyName,
        companyCode: companyCode,
        username: username,
        password: password,
        fullName: fullName,
        timezone: timezone,
        currency: currency,
      );
      await _datasource.register(model);
    } on DioException catch (e) {
      print('REPOSITORY CAUGHT DIOEXCEPTION');
      throw ApiErrorHandler.getMessage(e);
    }
  }

  /////////////////////////////////////////////////////////////////////////
  ///
  ////////////////////////////////////////////////////////////////////////
  @override
  Future<void> registerUser({
    required String username,
    required String password,
    required String fullName,
    required int roleId,
    required int departmentId,
  }) async {
    try {
      final model = RegisterUserRequestModel(
        username: username,
        password: password,
        fullName: fullName,
        roleId: roleId,
        departmentId: departmentId,
      );
      await _datasource.registerUser(model);
    } on DioException catch (e) {
      throw ApiErrorHandler.getMessage(e);
    }
  }

  ////////////////////////////////////////////////////////////////////////
  //
  ///////////////////////////////////////////////////////////////////////

  @override
  Future<void> logout() async {
    try {
      await _datasource.logout();
    } on DioException catch (e) {
      throw ApiErrorHandler.getMessage(e);
    }
  }
}
