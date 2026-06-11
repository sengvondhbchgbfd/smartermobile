import 'package:dio/dio.dart';
import 'package:frontendmobile/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:frontendmobile/features/auth/data/models/change_password_model.dart';
import 'package:frontendmobile/features/auth/data/models/login_request_model.dart';
import 'package:frontendmobile/features/auth/data/models/register_model.dart';
import 'package:frontendmobile/features/auth/data/models/reset_password_model.dart';
import 'package:frontendmobile/features/auth/data/models/auth_user_model.dart';

class AuthRemoteDatasourceImpl implements AuthRemoteDatasource {
  final Dio _dio;
  AuthRemoteDatasourceImpl(this._dio);

  @override
  Future<void> registerUser(RegisterUserRequestModel model) async {
    await _dio.post('/auth/register', data: model.toJson());
  }

  ////////////////////////////////////////////////////////////////////////
  //
  ///////////////////////////////////////////////////////////////////////

  // @override
  // Future<bool> validateToken(String token) async {
  //   final response = await _dio.get(
  //     "auth/validate",
  //     options: Options(headers: {'Authorization': 'Bearer $token'}),
  //   );
  //   return response.statusCode == 200;
  // }

  ////////////////////////////////////////////////////////////////////////
  //
  ///////////////////////////////////////////////////////////////////////
  @override
  Future<UserModel> login(String username, String password) async {
    final model = LoginRequestModel(username: username, password: password);
    final response = await _dio.post('/auth/login', data: model.toJson());
<<<<<<< HEAD
    print('LOGIN RESPONSE: ${response.data}');
=======
>>>>>>> 9f1638c8060e11abffb348266a42c22f5d24569c
    return UserModel.fromJson(response.data);
  }

  ////////////////////////////////////////////////////////////////////////
  //
  ///////////////////////////////////////////////////////////////////////

  @override
  Future<void> register(RegisterRequestModel model) async {
    await _dio.post('/setup/register', data: model.toJson());
  }

  ////////////////////////////////////////////////////////////////////////
  //
  ///////////////////////////////////////////////////////////////////////

  @override
  Future<void> logout() async {
    await _dio.post('/auth/logout');
  }

  //////////////////////////////////////////////////////////////////////
  // GET USERS
  //////////////////////////////////////////////////////////////////////

  @override
  Future<List<UserInfo>> getUsers() async {
    final response = await _dio.get("/auth/users");
    final List data = response.data;
    return data.map((e) => UserInfo.fromJson(e)).toList();
  }

  //////////////////////////////////////////////////////////////////////
  // GET USER BY ID
  //////////////////////////////////////////////////////////////////////
  @override
  Future<UserInfo> getUserById(int userId) async {
<<<<<<< HEAD
    final response = await _dio.get("/auth/users/$userId");
=======
    final response = await _dio.get("/auth/users/${userId}");
>>>>>>> 9f1638c8060e11abffb348266a42c22f5d24569c
    return UserInfo.fromJson(response.data);
  }
  //////////////////////////////////////////////////////////////////////
  // UPDATE USER
  //////////////////////////////////////////////////////////////////////

  @override
  Future<void> updateUser(int userId, Map<String, dynamic> data) async {
<<<<<<< HEAD
    await _dio.patch("/auth/users$userId", data: data);
=======
    await _dio.patch("/auth/users${userId}", data: data);
>>>>>>> 9f1638c8060e11abffb348266a42c22f5d24569c
  }

  //////////////////////////////////////////////////////////////////////
  // CHANGE PASSWORD
  //////////////////////////////////////////////////////////////////////

  @override
  Future<void> changePassword(ChangePasswordRequestModel model) async {
    await _dio.post("/auth/change-password", data: model.toJson());
  }

  //////////////////////////////////////////////////////////////////////
  // RESET PASSWORD
  //////////////////////////////////////////////////////////////////////
  @override
  Future<void> resetPassword(
    int userId,
    ResetPasswordRequestModel model,
  ) async {
    await _dio.post('/auth/reset-password/$userId', data: model.toJson());
  }

  //////////////////////////////////////////////////////////////////////
  // REFRESH TOKEN
  //////////////////////////////////////////////////////////////////////

  @override
  Future<UserModel> refreshToken(String refreshToken) async {
    final response = await _dio.post(
      '/auth/refresh',
      data: {"refresh_token": refreshToken},
    );
    return UserModel.fromJson(response.data);
  }

  //////////////////////////////////////////////////////////////////////
  // ACTIVATE USER
  //////////////////////////////////////////////////////////////////////

  @override
  Future<void> activateUser(int userId) async {
    await _dio.post('/auth/users/$userId/activate');
  }

  //////////////////////////////////////////////////////////////////////
  // DEACTIVATE USER
  //////////////////////////////////////////////////////////////////////

  @override
  Future<void> deactivateUser(int userId) async {
    await _dio.post('/auth/users/$userId/deactivate');
  }
}
