class OnboardingState {
  final int currentStep;
  final bool isLoading;
  final String? error;
  
  final String? companyName;
  final String? companyCode;
  final String? email;
  final String? timezone;
  final String? currency;
  final int? companyId;
  final int? staffId;
  final int? userId;
  final int? roleId;
  final int? departmentId;
  final String? userType;

  const OnboardingState({
    this.currentStep = 0,
    this.isLoading = false,
    this.error,
    this.companyName,
    this.companyCode,
    this.email,
    this.timezone,
    this.currency,
    this.companyId,
    this.staffId,
    this.userId,
    this.roleId,
    this.departmentId,
    this.userType,
  });

  OnboardingState copyWith({
    int? currentStep,
    bool? isLoading,
    String? error,
    bool clearError = false,
    String? companyName,
    String? companyCode,
    String? email,
    String? timezone,
    String? currency,
    int? companyId,
    int? staffId,
    int? userId,
    int? roleId,
    int? departmentId,
    String? userType,
  }) {
    return OnboardingState(
      currentStep: currentStep ?? this.currentStep,
      isLoading: isLoading ?? this.isLoading,
      error: clearError ? null : (error ?? this.error),
      companyName: companyName ?? this.companyName,
      companyCode: companyCode ?? this.companyCode,
      email: email ?? this.email,
      timezone: timezone ?? this.timezone,
      currency: currency ?? this.currency,
      companyId: companyId ?? this.companyId,
      staffId: staffId ?? this.staffId,
      userId: userId ?? this.userId,
      roleId: roleId ?? this.roleId,
      departmentId: departmentId ?? this.departmentId,
      userType: userType ?? this.userType,
    );
  }
}
