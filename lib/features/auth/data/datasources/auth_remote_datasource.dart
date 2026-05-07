import 'package:frontendmobile/features/auth/data/models/register_model.dart';
import 'package:frontendmobile/features/auth/data/models/user_model.dart';

abstract class AuthRemoteDatasource {
  // Future<bool> validateToken(String token);
  Future<UserModel> login(String username, String password);
  Future<void> register(RegisterRequestModel model);
  Future<void> registerUser(RegisterUserRequestModel model);
  Future<void> logout();
}
