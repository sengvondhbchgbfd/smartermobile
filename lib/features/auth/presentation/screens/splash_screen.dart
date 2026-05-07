import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontendmobile/features/auth/presentation/widgets/splash_ui.dart';
import 'package:go_router/go_router.dart';
import 'package:frontendmobile/config/routes/route_names.dart';
import 'package:frontendmobile/shared/providers/core_providers.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});
  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

////////////////////////////////////////////////////
//
///////////////////////////////////////////////////
class _SplashScreenState extends ConsumerState<SplashScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _checkAuth());
  }

  Future<void> _checkAuth() async {
    ///////////////////////////////////////////
    ///
    ///////////////////////////////////////////
    await Future.delayed(const Duration(seconds: 1));
    //////////////////////////////////////////
    ///
    //////////////////////////////////////////
    try {
      final dio = await ref.read(dioProvider.future);
      final response = await dio.get('/setup/status');
      final isInitialized = response.data?['initialized'] ?? false;
      if (!mounted) return;
      ///////////////////////////////////////////////////////////
      // ✅ Step 2 — not initialized → go to onboarding
      ///////////////////////////////////////////////////////////

      if (!isInitialized) {
        context.go(RouteNames.onboarding);
        return;
      }

      /////////////////////////////////////////////////////////
      // ✅ Step 3 — initialized → check token
      //////////////////////////////////////////////////////////
      final storage = ref.read(secureStorageProvider);
      final token = await storage.getAccessToken();
      if (!mounted) return;
      if (token == null) {
        context.go(RouteNames.login);
        return;
      }

      ////////////////////////////////////////////////////////////
      //
      ////////////////////////////////////////////////////////////

      // // ✅ Step 4 — validate token
      // final validateUseCase = await ref.read(
      //   validateTokenUseCaseProvider.future,
      // );
      // final isValid = await validateUseCase(token);

      // if (!mounted) return;
      // context.go(isValid ? RouteNames.home : RouteNames.login);

      ////////////////////////////////////////////////////////////
      //
      ////////////////////////////////////////////////////////////
    } catch (e) {
      // ✅ If API fails → fallback to login
      if (!mounted) return;
      context.go(RouteNames.login);
    }
  }

  @override
  Widget build(BuildContext context) {
    return const SplashUi();
  }
}
