class RegisterResponseEntity {
  final int companyId;
  final String companyName;
  final String username;
  final String role;
  final String message;

  const RegisterResponseEntity({
    required this.companyId,
    required this.companyName,
    required this.username,
    required this.role,
    required this.message,
  });
}