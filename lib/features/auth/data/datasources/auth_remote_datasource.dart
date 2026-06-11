import 'package:frontendmobile/features/auth/data/models/register_model.dart';
import 'package:frontendmobile/features/auth/data/models/reset_password_model.dart';
import 'package:frontendmobile/features/auth/data/models/auth_user_model.dart';
import 'package:frontendmobile/features/auth/data/models/change_password_model.dart';

abstract class AuthRemoteDatasource {
  // Future<bool> validateToken(String token);
  Future<UserModel> login(String username, String password);
  Future<void> register(RegisterRequestModel model);
  Future<void> registerUser(RegisterUserRequestModel model);
  Future<void> logout();
  Future<List<UserInfo>> getUsers();
  Future<UserInfo> getUserById(int userId);
  Future<void> updateUser(int userId, Map<String, dynamic> date);
  Future<void> changePassword(ChangePasswordRequestModel model);
  Future<void> resetPassword(int userId, ResetPasswordRequestModel model);
  Future<UserModel> refreshToken(String refrshToken);
  Future<void> activateUser(int userId);
  Future<void> deactivateUser(int userId);
  
}
