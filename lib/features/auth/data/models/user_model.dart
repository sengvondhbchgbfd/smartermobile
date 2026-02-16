import 'package:frontendmobile/features/auth/domain/entities/user.dart';

class UserModel extends User {
  UserModel({required super.token});
  factory UserModel.formJson(Map<String, dynamic> json) {
    return UserModel(token: json['token']);
  }
}
