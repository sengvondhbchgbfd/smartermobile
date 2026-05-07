import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontendmobile/features/company/data/datasources/company_remote_datasource.dart';
import 'package:frontendmobile/features/company/data/datasources/company_remote_datasource_impl.dart';
import 'package:frontendmobile/features/company/data/repositories/company_repository_impl.dart';
import 'package:frontendmobile/features/company/domain/usecases/get_company_usecase.dart';
import 'package:frontendmobile/features/company/domain/usecases/register_company_usecase.dart';
import 'package:frontendmobile/features/company/domain/usecases/update_company_usecase.dart';
import 'package:frontendmobile/features/company/domain/usecases/upload_company_logo.usecase.dart';
import 'package:frontendmobile/features/company/presentation/providers/company_state.dart';
import 'package:frontendmobile/shared/providers/core_providers.dart';

//////////////////////////////////////////////////////////////////////////////
// ── Notifier ───────────────────────────────────────────────────────────────
//////////////////////////////////////////////////////////////////////////////
class CompanyNotifier extends AsyncNotifier<CompanyState> {
  late final GetCompanyUseCase _getCompany;
  late final UpdateCompanyUseCase _updateCompany;
  late final UploadCompanyLogoUseCase _uploadLogo;
  late final RegisterCompanyUseCase _createCompany;
  @override
  Future<CompanyState> build() async {
    final repo = await ref.watch(companyRepositoryProvider.future);

    _getCompany = GetCompanyUseCase(repo);
    _updateCompany = UpdateCompanyUseCase(repo);
    _uploadLogo = UploadCompanyLogoUseCase(repo);
    _createCompany = RegisterCompanyUseCase(repo);
    return const CompanyState();
  }
  /////////////////////////////////////////////////////////////////////////////
  //
  ////////////////////////////////////////////////////////////////////////////

  ////////////////////////////////////////////////////////////////////////////
  // CreateCompany
  ////////////////////////////////////////////////////////////////////////////
  Future<bool> registerCompany({
    required String companyCode,
    required String companyName,
    required String currency,
    required String email,
    required int maxUsers,
    required String timezone,
    String planType = 'free',
  }) async {
    final current = state.valueOrNull ?? const CompanyState();
    state = AsyncData(current.copyWith(isUpdating: true, error: null));

    final result = await _createCompany(
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
        state = AsyncData(
          current.copyWith(isUpdating: false, error: failure.message),
        );
        return false;
      },
      (response) {
        state = AsyncData(current.copyWith(isUpdating: false, error: null));
        fetchCompany(response.companyId);
        return true;
      },
    );
  }
  ////////////////////////////////////////////////////////////////////////////
  // ── Fetch (full screen loading) ──────────────────────────────────────────
  ////////////////////////////////////////////////////////////////////////////

  Future<void> fetchCompany(int companyId) async {
    await future;

    state = const AsyncLoading();
    final result = await _getCompany(companyId);
    state = result.fold(
      (failure) => AsyncError(failure.message, StackTrace.current),
      (company) => AsyncData(CompanyState(company: company)),
    );
  }

  ///////////////////////////////////////////////////////////////////////////
  // ── Update (button spinner only, company stays visible) ──────────────────
  ////////////////////////////////////////////////////////////////////////////

  Future<bool> updateCompany(UpdateCompanyParams params) async {
    final current = state.valueOrNull ?? const CompanyState();
    state = AsyncData(current.copyWith(isUpdating: true, error: null));
    final result = await _updateCompany(params);
    return result.fold(
      (failure) {
        state = AsyncData(
          current.copyWith(isUpdating: false, error: failure.message),
        );
        return false;
      },
      (company) {
        state = AsyncData(CompanyState(company: company));
        return true;
      },
    );
  }

  // ── Upload Logo (button spinner only) ────────────────────────────────────
  ////////////////////////////////////////////////////////////////////////////
  // ── Upload Logo (button spinner only) ────────────────────────────────────

  Future<bool> uploadLogo({
    required int companyId,
    required String filePath,
    String? oldLogoPublicId,
  }) async {
    final current = state.valueOrNull ?? const CompanyState();
    state = AsyncData(current.copyWith(isUpdating: true, error: null));
    final result = await _uploadLogo(
      UploadLogoParams(
        companyId: companyId,
        filePath: filePath,
        oldLogoPublicId: oldLogoPublicId,
      ),
    );
    bool success = false;
    result.fold(
      (failure) {
        state = AsyncData(
          current.copyWith(isUpdating: false, error: failure.message),
        );
      },
      (_) {
        success = true;
      },
    );

    if (success) {
      await fetchCompany(companyId);
      return true;
    }
    return false;
  }
}

/////////////////////////////////////////////////////////////////////////////
// ── Providers ──────────────────────────────────────────────────────────────
//////////////////////////////////////////////////////////////////////////////

final companyRemoteDataSourceProvider = FutureProvider<CompanyRemoteDatasource>(
  (ref) async {
    final dioClient = await ref.watch(dioClientProvider.future);
    return CompanyRemoteDataSourceImpl(dioClient.dio);
  },
);
////////////////////////////////////////////////////////////////////////////
//
////////////////////////////////////////////////////////////////////////////
final companyRepositoryProvider = FutureProvider<CompanyRepositoryImpl>((
  ref,
) async {
  final remote = await ref.watch(companyRemoteDataSourceProvider.future);
  return CompanyRepositoryImpl(remote);
});
//////////////////////////////////////////////////////////////////////////
//
/////////////////////////////////////////////////////////////////////////
final companyProvider = AsyncNotifierProvider<CompanyNotifier, CompanyState>(
  CompanyNotifier.new,
);
