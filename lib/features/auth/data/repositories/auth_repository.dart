import 'package:frontendmobile/features/auth/domain/entities/user.dart';

abstract class AuthRepositoryImpl {
  Future<User> login(String email, String password);
}
