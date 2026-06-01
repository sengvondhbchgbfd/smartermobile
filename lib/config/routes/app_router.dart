import 'package:frontendmobile/config/routes/route_names.dart';
import 'package:frontendmobile/features/auth/presentation/screens/register_screen.dart';
import 'package:frontendmobile/features/auth/presentation/screens/login_screen.dart';
import 'package:frontendmobile/features/auth/presentation/screens/splash_screen.dart';
import 'package:frontendmobile/features/communication/chat/presentation/screens/chat_groups_screen.dart';
import 'package:frontendmobile/features/communication/chat/presentation/screens/chat_screen.dart';
import 'package:frontendmobile/features/company/presentation/screens/company_screen.dart';
import 'package:frontendmobile/features/dashboard/presentation/screens/dashboard_screen.dart';
import 'package:frontendmobile/features/dashboard/presentation/setup_wizard/screens/wizard_screen.dart';
import 'package:frontendmobile/features/home/presentation/screens/home_screen.dart';
import 'package:frontendmobile/features/hr/attendance/presentation/screens/attendance_screen.dart';
import 'package:frontendmobile/features/hr/leave/presentation/screens/leave_screen.dart';
import 'package:frontendmobile/features/hr/salaries/presentation/screens/salary_screen.dart';
import 'package:frontendmobile/features/hr/staff/presentation/screens/staff_detail_screen.dart';
import 'package:frontendmobile/features/hr/staff/presentation/screens/staff_role_screen.dart';
import 'package:frontendmobile/features/hr/staff/presentation/screens/staff_screen.dart';
import 'package:frontendmobile/features/onboarding/presentation/screens/onboarding_screen.dart';
import 'package:frontendmobile/features/profile/presentation/screens/profile_screen.dart';
import 'package:frontendmobile/features/users/presentation/screen/user_screen.dart';
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
        path: RouteNames.chat,
        builder: (context, state) => const ChatGroupsScreen(),
      ),

      GoRoute(
        path: RouteNames.profile,
        builder: (context, state) => const ProfileScreen(),
      ),

      GoRoute(
        path: RouteNames.users,
        builder: (context, state) => const UserScreen(),
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
      GoRoute(
        path: RouteNames.dashboard,
        builder: (context, state) => const DashboardScreen(),
      ),

      // 🔥 COMPANY SCREEN ROUTE
      // GoRoute(
      //   path: "/companies/:id",
      //   builder: (context, state) {
      //     final id = int.parse(state.pathParameters['id']!);
      //     return CompanyScreen(companyId: id);
      //   },
      // ),
      GoRoute(
        path: RouteNames.companyDetail,
        builder: (context, state) {
          final id = int.parse(state.pathParameters['id']!);
          return CompanyScreen(companyId: id);
        },
      ),

      /////////////////////////////////////////////////////
      // ── HR Staff ──────────────────────────
      ////////////////////////////////////////////////////
      GoRoute(
        path: RouteNames.staffRoles,
        builder: (context, state) => const StaffRoleScreen(),
      ),
      GoRoute(
        path: RouteNames.staff,
        builder: (context, state) => const StaffScreen(),
      ),
      GoRoute(
        path: RouteNames.staffDetail,
        builder: (context, state) {
          final id = int.parse(state.pathParameters['id']!);
          return StaffDetailScreen(staffId: id);
        },
      ),

      /////////////////////////////////////////////////////
      // ── SALARIES ──────────────────────────
      /////////////////////////////////////////////////////
      GoRoute(
        path: RouteNames.salaries,
        builder: (context, state) => const SalaryScreen(),
      ),

      // GoRoute(
      //   path: RouteNames.salaryMy,
      //   builder: (context, state) => const SalaryMyScreen(),
      // ),

      // GoRoute(
      //   path: RouteNames.salarySummary,
      //   builder: (context, state) => const SalarySummaryScreen(),
      // ),

      // GoRoute(
      //   path: RouteNames.salaryAdjustments,
      //   builder: (context, state) => const SalaryAdjustmentsScreen(),
      // ),

      ////////////////////////////////////////////////////////
      ///
      ///////////////////////////////////////////////////////
      GoRoute(
        path: RouteNames.leaves, // /leave-requests → full tab screen
        builder: (context, state) => const LeaveScreen(),
      ),
      GoRoute(
        path: RouteNames.leaveMy, // /leave-requests/my → staff tab directly
        builder: (context, state) => const LeaveScreen(),
      ),
      GoRoute(
        path: RouteNames
            .leavePending, // /leave-requests/pending → manager tab directly
        builder: (context, state) => const LeaveScreen(),
      ),
      GoRoute(
        path: RouteNames.leaveDetail, // /leave-requests/:id
        builder: (context, state) => const LeaveScreen(),
      ),

      /////////////////////////////////////////////////
      ///
      ////////////////////////////////////////////////

      /// GET /attendance
      GoRoute(
        path: RouteNames.attendance,
        builder: (context, state) => const AttendanceScreen(),
      ),
      GoRoute(
        path: RouteNames.attendanceMy,
        builder: (context, state) => const AttendanceScreen(),
      ),
    ],
  );
}
