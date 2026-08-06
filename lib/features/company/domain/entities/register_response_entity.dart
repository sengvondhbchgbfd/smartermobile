class RegisterResponseEntity {
  final String accessToken;
  final String refreshToken;
  final int accessExpiresIn;
  final int refreshExpiresIn;
  final String tokenType;

  final int companyId;
  final String companyName;
  final String companyCode;
  final String planType;
  final String status;
  final int maxUsers;

  final int userId;
  final String username;
  final String fullName;
  final String role;

  const RegisterResponseEntity({
    required this.accessToken,
    required this.refreshToken,
    required this.accessExpiresIn,
    required this.refreshExpiresIn,
    required this.tokenType,
    required this.companyId,
    required this.companyName,
    required this.companyCode,
    required this.planType,
    required this.status,
    required this.maxUsers,
    required this.userId,
    required this.username,
    required this.fullName,
    required this.role,
  });
}