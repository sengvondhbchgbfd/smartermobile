import 'package:frontendmobile/features/auth/data/models/auth_user_model.dart';

class AuthState {
  final bool isLoading;
  final UserInfo? user;
  final String? error;

  const AuthState({
    this.isLoading = false,
    this.user,
    this.error,
  });
  AuthState copyWith({
    bool? isLoading,
    UserInfo? user,
    String? error,
  }) {
    return AuthState(
      isLoading: isLoading ?? this.isLoading,
      user: user ?? this.user,
      error: error,
    );
  }
}