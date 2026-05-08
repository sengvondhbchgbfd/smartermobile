import 'package:frontendmobile/features/auth/data/models/user_model.dart';

abstract class AuthRepository {
  /////////////////////////////////////////////////
  ///
  ////////////////////////////////////////////////
  Future<UserModel> login(String username, String password);
  /////////////////////////////////////////////////
  ///
  ////////////////////////////////////////////////

  Future<void> logout();

  // Future<bool> validateToken(String token);

  /////////////////////////////////////////////////
  ///
  ////////////////////////////////////////////////
  Future<void> register({
    required String companyName,
    required String companyCode,
    required String username,
    required String password,
    required String fullName,
    required String timezone,
    required String currency,
  });

  ///////////////////////////////////////////////////
  ///
  ////////////////////////////////////////////////////

  Future<void> registerUser({
    required String username,
    required String password,
    required String fullName,
    required int roleId,
    required int departmentId,
  });

  ///////////////////////////////////////////////////
  ///
  ////////////////////////////////////////////////////

  Future<List<UserInfo>> getUsers();
  Future<UserInfo> getUserById(int userId);

  ///////////////////////////////////////////////////
  ///
  ////////////////////////////////////////////////////

  Future<void> updateUser({
    required int userId,
    String? fullName,
    int? roleId,
    int? departmentId,
    String? status,
  });




  
}
