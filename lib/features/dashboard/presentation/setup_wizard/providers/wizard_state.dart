class WizardState {
  final int currentStep;
  final bool isLoading;
  final bool isBusy;
  final bool isCompleted;
  final String? error;


  final String? companyName;
  final String? companyCode;
  final String? email;
  final String? timezone;
  final String? currency;
  final int? maxUsers;
  final int? companyId;
  final int? roleId;
  final int? departmentId;
  final String? userType;

  const WizardState({
    this.currentStep = 0,
    this.isLoading = false,
    this.isBusy = false,
    this.isCompleted = false,
    this.error,
    this.companyName,
    this.companyCode,
    this.email,
    this.timezone,
    this.currency,
    this.maxUsers,
    this.companyId,
    this.roleId,
    this.departmentId,
    this.userType,
  });

  WizardState copyWith({
    int? currentStep,
    bool? isLoading,
    bool? isBusy,
    bool? isCompleted,
    String? error,
    bool clearError = false,
    String? companyName,
    String? companyCode,
    String? email,
    String? timezone,
    String? currency,
    int? maxUsers,
    int? companyId,
    int? roleId,
    int? departmentId,
    String? userType,
  }) {
    return WizardState(
      currentStep: currentStep ?? this.currentStep,
      isLoading: isLoading ?? this.isLoading,
      isBusy: isBusy ?? this.isBusy,
      isCompleted: isCompleted ?? this.isCompleted,
      error: clearError ? null : (error ?? this.error),
      companyName: companyName ?? this.companyName,
      companyCode: companyCode ?? this.companyCode,
      email: email ?? this.email,
      timezone: timezone ?? this.timezone,
      currency: currency ?? this.currency,
      maxUsers: maxUsers ?? this.maxUsers,
      companyId: companyId ?? this.companyId,
      roleId: roleId ?? this.roleId,
      departmentId: departmentId ?? this.departmentId,
      userType: userType ?? this.userType,
    );
  }
}