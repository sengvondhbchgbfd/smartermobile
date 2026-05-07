import 'package:dio/dio.dart';
import 'package:frontendmobile/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:frontendmobile/features/auth/data/models/login_request_model.dart';
import 'package:frontendmobile/features/auth/data/models/register_model.dart';
import 'package:frontendmobile/features/auth/data/models/user_model.dart';

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
    print('LOGIN RESPONSE: ${response.data}');
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
}
