import 'package:dio/dio.dart';
import 'package:frontendmobile/core/errors/api_error_handler.dart';
import 'package:frontendmobile/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:frontendmobile/features/auth/data/models/change_password_model.dart';
import 'package:frontendmobile/features/auth/data/models/register_model.dart';
import 'package:frontendmobile/features/auth/data/models/reset_password_model.dart';
import 'package:frontendmobile/features/auth/data/models/auth_user_model.dart';
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

  //////////////////////////////////////////////////////////////////////
  // GET USERS
  //////////////////////////////////////////////////////////////////////
  @override
  Future<List<UserInfo>> getUsers() async {
    try {
      return await _datasource.getUsers();
    } on DioException catch (e) {
      throw ApiErrorHandler.getMessage(e);
    }
  }

  //////////////////////////////////////////////////////////////////////
  // GET USER BY ID

  //////////////////////////////////////////////////////////////////////
  @override
  Future<UserInfo> getUserById(int userId) async {
    try {
      return await _datasource.getUserById(userId);
    } on DioException catch (e) {
      throw ApiErrorHandler.getMessage(e);
    }
  }

  //////////////////////////////////////////////////////////////////////
  // UPDATE USER
  //////////////////////////////////////////////////////////////////////

  @override
  Future<void> updateUser({
    required int userId,
    String? fullName,
    int? roleId,
    int? departmentId,
    String? status,
  }) async {
    try {
      final data = <String, dynamic>{
        if (fullName != null) 'full_name': fullName,
        if (roleId != null) 'role_id': roleId,
        if (departmentId != null)
          if (status != null) 'status': status,
      };
      await _datasource.updateUser(userId, data);
    } on DioException catch (e) {
      throw ApiErrorHandler.getMessage(e);
    }
  }

  //////////////////////////////////////////////////////////////////////
  // CHANGE PASSWORD
  //////////////////////////////////////////////////////////////////////

  @override
  Future<void> changePassword({
    required String oldPassword,
    required String newPassword,
  }) async {
    try {
      final model = ChangePasswordRequestModel(
        oldPassword: oldPassword,
        newPassword: newPassword,
      );

      await _datasource.changePassword(model);
    } on DioException catch (e) {
      throw ApiErrorHandler.getMessage(e);
    }
  }
  //////////////////////////////////////////////////////////////////////
  // RESET PASSWORD
  //////////////////////////////////////////////////////////////////////

  @override
  Future<void> resetPassword({
    required int userId,
    required String newPassword,
  }) async {
    try {
      final model = ResetPasswordRequestModel(newPassword: newPassword);

      await _datasource.resetPassword(userId, model);
    } on DioException catch (e) {
      throw ApiErrorHandler.getMessage(e);
    }
  }

  //////////////////////////////////////////////////////////////////////
  // REFRESH TOKEN
  //////////////////////////////////////////////////////////////////////

  @override
  Future<UserModel> refreshToken(String refreshToken) async {
    try {
      return await _datasource.refreshToken(refreshToken);
    } on DioException catch (e) {
      throw ApiErrorHandler.getMessage(e);
    }
  }

  //////////////////////////////////////////////////////////////////////
  // ACTIVATE USER
  //////////////////////////////////////////////////////////////////////

  @override
  Future<void> activateUser(int userId) async {
    try {
      await _datasource.activateUser(userId);
    } on DioException catch (e) {
      throw ApiErrorHandler.getMessage(e);
    }
  }

  //////////////////////////////////////////////////////////////////////
  // DEACTIVATE USER
  //////////////////////////////////////////////////////////////////////

  @override
  Future<void> deactivateUser(int userId) async {
    try {
      await _datasource.deactivateUser(userId);
    } on DioException catch (e) {
      throw ApiErrorHandler.getMessage(e);
    }
  }
}
