import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontendmobile/features/company/domain/usecases/register_company_usecase.dart';
import 'package:frontendmobile/features/company/presentation/providers/company_provider.dart';
import 'package:frontendmobile/features/onboarding/presentation/providers/onboarding_state.dart';

class OnboardingNotifier extends StateNotifier<OnboardingState> {
  final Ref _ref;
  OnboardingNotifier(this._ref) : super(const OnboardingState());
  /////////////////////////////////////////////////////////////////////////
  // ── Step 1 — Register Company + Admin ────────────────────────────────
  ////////////////////////////////////////////////////////////////////////





  Future<bool> registerCompanyAndAdmin({
    required String companyName,
    required String companyCode,
    required String username,
    required String password,
    required String fullName,
    required String timezone,
    required String currency,
  }) async {
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      final repo = await _ref.read(companyRepositoryProvider.future);
      final useCase = RegisterCompanyUseCase(repo);

      final result = await useCase(
        RegisterCompanyParams(
          companyName: companyName,
          companyCode: companyCode,
          username: username,
          password: password,
          fullName: fullName,
          timezone: timezone,
          currency: currency,
        ),
      );

      return result.fold(
        (failure) {
          state = state.copyWith(isLoading: false, error: failure.message);
          return false;
        },
        (response) {
          state = state.copyWith(
            isLoading: false,
            currentStep: 1,
            companyName: companyName,
            companyCode: companyCode,
            timezone: timezone,
            currency: currency,
            companyId: response.companyId,
          );
          return true;
        },
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
      return false;
    }
  }



  
  /////////////////////////////////////////////////////////////////////////

  // ── Go back ──────────────────────────────────────────────────────────
  /////////////////////////////////////////////////////////////////////////

  void previousStep() {
    if (state.currentStep > 0) {
      state = state.copyWith(currentStep: state.currentStep - 1);
    }
  }
  /////////////////////////////////////////////////////////////////////////

  // ── Complete onboarding ──────────────────────────────────────────────
  /////////////////////////////////////////////////////////////////////////

  void complete() => state = state.copyWith(currentStep: 5);
  /////////////////////////////////////////////////////////////////////////

  // ── Clear error ──────────────────────────────────────────────────────
  /////////////////////////////////////////////////////////////////////////

  void clearError() => state = state.copyWith(clearError: true);
}

final onboardingProvider =
    StateNotifierProvider<OnboardingNotifier, OnboardingState>(
      (ref) => OnboardingNotifier(ref),
    );
