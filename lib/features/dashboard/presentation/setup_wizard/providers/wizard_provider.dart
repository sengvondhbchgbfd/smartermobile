import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontendmobile/features/company/domain/usecases/register_company_usecase.dart';
import 'package:frontendmobile/features/company/presentation/providers/company_provider.dart';
import 'package:frontendmobile/features/dashboard/presentation/setup_wizard/providers/wizard_state.dart';
import 'package:frontendmobile/features/dashboard/presentation/utils/wizard_steps.dart';
import 'package:frontendmobile/shared/providers/core_providers.dart';

class WizardNotifier extends StateNotifier<WizardState> {
  final Ref _ref;
  WizardNotifier(this._ref) : super(const WizardState());
  ///////////////////////////////////////////////////////////////
  //
  //////////////////////////////////////////////////////////////

  Future<bool> registerCompany({
    required String companyCode,
    required String companyName,
    required String currency,
    required String email,
    required int maxUsers,
    required String timezone,
    String planType = 'free',
  }) async {
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      final repo = await _ref.read(companyRepositoryProvider.future);
      final useCase = RegisterCompanyUseCase(repo);

      final result = await useCase(
        RegisterCompanyParams(
          companyCode: companyCode,
          companyName: companyName,
          currency: currency,
          email: email,
          maxUsers: maxUsers,
          timezone: timezone,
          planType: planType,
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
            companyId: response.companyId,
            companyName: companyName,
            companyCode: companyCode,
            currency: currency,
            email: email,
            maxUsers: maxUsers,
            timezone: timezone,
            currentStep: 1,
          );
          return true;
        },
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
      return false;
    }
  }

  ///////////////////////////////////////////////////////////////
  // getCompanyId
  ///////////////////////////////////////////////////////////////

  Future<int> getCompanyId() async {
    final storage = _ref.read(secureStorageProvider);
    final companyId = await storage.getCompanyId();
    if (companyId == null) {
      throw Exception("Company ID not found. User not logged in.");
    }
    return int.parse(companyId);
  }

  ///////////////////////////////////////////////////////////////
  // ── Step 1 — Create Role ──────────────────────────────────
  ///////////////////////////////////////////////////////////////

  Future<bool> assignRole({
    required String roleName,
    required bool isManager,
    required double baseSalary,
  }) async {
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      final dio = await _ref.read(dioProvider.future);
      final companyId = await getCompanyId();
      final response = await dio.post(
        '/roles/',
        data: {
          'company_id': companyId,
          'role_name': roleName,
          'is_manager': isManager,
          'base_salary': baseSalary,
        },
      );
      final roleId = response.data?['role_id'] as int?;
      state = state.copyWith(isLoading: false, currentStep: 2, roleId: roleId);
      return true;
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
      return false;
    }
  }
  ///////////////////////////////////////////////////////////////
  // ── Step 2 — Create Department ────────────────────────────
  ///////////////////////////////////////////////////////////////

  Future<bool> assignDepartment({required String departmentName}) async {
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      final dio = await _ref.read(dioProvider.future);
      final companyId = await getCompanyId();
      final response = await dio.post(
        '/departments/',
        data: {'company_id': companyId, 'department_name': departmentName},
      );
      final departmentId = response.data?['department_id'] as int?;
      state = state.copyWith(
        isLoading: false,
        currentStep: 3,
        departmentId: departmentId,
      );
      return true;
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
      return false;
    }
  }
  ///////////////////////////////////////////////////////////////
  // ── Step 3 — Select User Type ─────────────────────────────
  ///////////////////////////////////////////////////////////////

  void selectUserType(String type) {
    state = state.copyWith(userType: type, currentStep: 4);
  }
  ///////////////////////////////////////////////////////////////
  // ── Step 4 — Upload Avatar ─────────────────────────────────
  ///////////////////////////////////////////////////////////////

  Future<bool> uploadAvatar({
    required String filePath,
    required int staffId,
  }) async {
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      final dio = await _ref.read(dioProvider.future);
      final formData = FormData.fromMap({
        'avatar': await MultipartFile.fromFile(filePath),
      });
      await dio.patch(
        '/staff/$staffId/avatar',
        data: formData,
        options: Options(contentType: 'multipart/form-data'),
      );
      state = state.copyWith(isLoading: false, currentStep: 5);
      return true;
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
      return false;
    }
  }

  ////////////////////////////////////////////////////////////////
  //
  ///////////////////////////////////////////////////////////////

  void previousStep() {
    if (state.isBusy) return;

    if (state.currentStep > 0) {
      state = state.copyWith(currentStep: state.currentStep - 1);
    }
  }

  void nextStep() {
    if (state.currentStep < WizardSteps.steps.length - 1) {
      state = state.copyWith(currentStep: state.currentStep + 1);
    }
  }

  void clearError() => state = state.copyWith(clearError: true);

  void markComplete() => state = state.copyWith(isCompleted: true);
}

final wizardProvider = StateNotifierProvider<WizardNotifier, WizardState>(
  (ref) => WizardNotifier(ref),
);
