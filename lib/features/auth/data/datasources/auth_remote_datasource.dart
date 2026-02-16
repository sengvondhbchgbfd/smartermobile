import 'package:dio/dio.dart';
import 'package:frontendmobile/core/constants/ApiEndpoints.dart';
import 'package:frontendmobile/features/auth/data/models/user_model.dart';

class AuthRemoteDatasource {
  final Dio dio;
  AuthRemoteDatasource(this.dio);
  Future<UserModel> login(String email, password) async {
    final response = await dio.post(
      // "/login",
      ApiEndpoints.login,
      data: {"email": email, "password": password},
    );
    return UserModel.formJson(response.data);
  }
}
