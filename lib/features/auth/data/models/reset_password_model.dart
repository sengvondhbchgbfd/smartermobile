class ResetPasswordRequestModel {
  final String newPassword;
  const ResetPasswordRequestModel({required this.newPassword});
  Map<String, dynamic> toJson() => {"new_password": newPassword};
}
