import 'package:frontendmobile/config/routes/route_names.dart';
import 'package:frontendmobile/features/auth/presentation/screens/register_screen.dart';
import 'package:frontendmobile/features/auth/presentation/screens/login_screen.dart';
import 'package:frontendmobile/features/auth/presentation/screens/splash_screen.dart';
import 'package:frontendmobile/features/company/presentation/screens/company_screen.dart';
import 'package:frontendmobile/features/dashboard/presentation/setup_wizard/screens/wizard_screen.dart';
import 'package:frontendmobile/features/home/presentation/screens/home_screen.dart';
import 'package:frontendmobile/features/onboarding/presentation/screens/onboarding_screen.dart';
import 'package:go_router/go_router.dart';

class AppRouter {
  // /////////////////////////////////////////
  //
  // /////////////////////////////////////////
  static final GoRouter router = GoRouter(
    initialLocation: RouteNames.splash,
    routes: [
      GoRoute(
        path: RouteNames.splash,
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: RouteNames.setupWizard,
        builder: (context, state) => const WizardScreen(),
      ),

      GoRoute(
        path: RouteNames.onboarding,
        builder: (context, state) => const OnboardingScreen(),
      ),

      GoRoute(
        path: RouteNames.register,
        builder: (context, state) => const RegisterScreen(),
      ),

      GoRoute(
        path: RouteNames.login,
        builder: (context, state) => const LoginScreen(),
      ),

      GoRoute(
        path: RouteNames.home,
        builder: (context, state) => const HomeScreen(),
      ),

      // 🔥 COMPANY SCREEN ROUTE
      GoRoute(
        path: "/company/:id",
        builder: (context, state) {
          final id = int.parse(state.pathParameters['id']!);
          return CompanyScreen(companyId: id);
        },
      ),
    ],
  );
}
