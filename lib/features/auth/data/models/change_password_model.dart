class ChangePasswordRequestModel  {
  final String oldPassword;
  final String newPassword;

  const ChangePasswordRequestModel ({
    required this.oldPassword,
    required this.newPassword,
  });

  Map<String, dynamic> toJson() => {
    "old_passwor": oldPassword,
    "new_password": newPassword,
  };
}
