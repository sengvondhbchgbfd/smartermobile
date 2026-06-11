import 'package:frontendmobile/config/routes/app_shell.dart';
import 'package:frontendmobile/config/routes/route_names.dart';
import 'package:frontendmobile/features/auth/presentation/screens/register_screen.dart';
import 'package:frontendmobile/features/auth/presentation/screens/login_screen.dart';
import 'package:frontendmobile/features/auth/presentation/screens/splash_screen.dart';
import 'package:frontendmobile/features/communication/chat/presentation/screens/chat_groups_screen.dart';
import 'package:frontendmobile/features/communication/notifications/presentation/screens/notification_screen.dart';
import 'package:frontendmobile/features/company/domain/entities/company_entity.dart';
import 'package:frontendmobile/features/company/presentation/screens/company_screen.dart';
import 'package:frontendmobile/features/company/presentation/widgets/company_edit_screen.dart';
import 'package:frontendmobile/features/dashboard/presentation/screens/dashboard_screen.dart';
import 'package:frontendmobile/features/dashboard/presentation/setup_wizard/screens/wizard_screen.dart';
import 'package:frontendmobile/features/home/presentation/screens/home_screen.dart';
import 'package:frontendmobile/features/hr/attendance/presentation/screens/attendance_screen.dart';
import 'package:frontendmobile/features/hr/leave/presentation/screens/leave_screen.dart';
import 'package:frontendmobile/features/hr/salaries/presentation/screens/salary_screen.dart';
import 'package:frontendmobile/features/hr/staff/domain/entities/staff_entity.dart';
import 'package:frontendmobile/features/hr/staff/presentation/screens/staff_detail_screen.dart';
import 'package:frontendmobile/features/hr/staff/presentation/screens/staff_role_screen.dart';
import 'package:frontendmobile/features/hr/staff/presentation/screens/staff_screen.dart';
import 'package:frontendmobile/features/onboarding/presentation/screens/onboarding_screen.dart';
import 'package:frontendmobile/features/profile/domain/entities/profile_entity.dart';
import 'package:frontendmobile/features/profile/presentation/screens/profile_screen.dart';
import 'package:frontendmobile/features/profile/presentation/widgets/profile_edit_card.dart';
import 'package:frontendmobile/features/users/domain/entities/user_entity.dart';
import 'package:frontendmobile/features/users/presentation/screen/user_screen.dart';
import 'package:frontendmobile/features/users/presentation/screen/fillter_users_screen.dart';
import 'package:frontendmobile/features/users/presentation/screen/user_detail_screen.dart';
import 'package:frontendmobile/features/users/presentation/widgets/creates/create_department_page.dart';
import 'package:frontendmobile/features/users/presentation/widgets/creates/create_role_page.dart';
import 'package:frontendmobile/features/users/presentation/widgets/creates/create_user_page.dart';
import 'package:frontendmobile/features/users/presentation/widgets/update_user_page.dart';
import 'package:go_router/go_router.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: RouteNames.splash,
    routes: [
      // ── Auth / Onboarding (no shell) ──────────────────────────────────────
      GoRoute(
        path: RouteNames.splash,
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: RouteNames.onboarding,
        builder: (context, state) => const OnboardingScreen(),
      ),
      GoRoute(
        path: RouteNames.setupWizard,
        builder: (context, state) => const WizardScreen(),
      ),
      GoRoute(
        path: RouteNames.login,
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: RouteNames.register,
        builder: (context, state) => const RegisterScreen(),
      ),
      GoRoute(
        path: RouteNames.home,
        builder: (context, state) => const HomeScreen(),
      ),

      // ── Pushed screens — full screen, NO shell ────────────────────────────
      GoRoute(
        path: RouteNames.profile,
        builder: (context, state) => const ProfileScreen(),
      ),

      GoRoute(
        path: RouteNames.editedProfile,
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>;
          return EditProfilePage(
            profile: extra['profile'] as ProfileEntity,
            staff: extra['staff'] as StaffEntity,
          );
        },
      ),

      GoRoute(
        path: RouteNames.notifications,
        builder: (context, state) => const NotificationScreen(),
      ),

      // ── Company ───────────────────────────────────────────────────────────
      GoRoute(
        path: RouteNames.companyDetail,
        builder: (context, state) {
          final id = int.parse(state.pathParameters['id']!);
          return CompanyScreen(companyId: id);
        },
      ),
      GoRoute(
        path: RouteNames.companyEdit,
        builder: (context, state) {
          final company = state.extra as CompanyEntity;
          return CompanyEditScreen(company: company);
        },
      ),

      // ── HR Staff ──────────────────────────────────────────────────────────
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
      GoRoute(
        path: RouteNames.salaries,
        builder: (context, state) => const SalaryScreen(),
      ),
      GoRoute(
        path: RouteNames.leaves,
        builder: (context, state) => const LeaveScreen(),
      ),
      GoRoute(
        path: RouteNames.leaveMy,
        builder: (context, state) => const LeaveScreen(),
      ),
      GoRoute(
        path: RouteNames.leavePending,
        builder: (context, state) => const LeaveScreen(),
      ),
      GoRoute(
        path: RouteNames.leaveDetail,
        builder: (context, state) => const LeaveScreen(),
      ),

      // ── Users (outside shell — full screen pages) ─────────────────────────
      GoRoute(
        path: '/users/create-user',
        builder: (context, state) => const CreateUserPage(),
      ),
      GoRoute(
        path: '/users/create-role',
        builder: (context, state) => const CreateRolePage(),
      ),
      GoRoute(
        path: '/users/create-department',
        builder: (context, state) => const CreateDepartmentPage(),
      ),
      GoRoute(
        path: '/users/update-user',
        builder: (context, state) {
          final user = state.extra as UserEntity;
          return UpdateUserPage(user: user);
        },
      ),
      GoRoute(
        path: '/users/detail',
        builder: (context, state) {
          final user = state.extra as UserEntity;
          return UserDetailScreen(user: user);
        },
      ),
      GoRoute(
        path: '/users/filtered',
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>;
          return FilteredUsersScreen(
            type: extra['type'] as String,
            id: extra['id'] as int,
            title: extra['title'] as String,
          );
        },
      ),

      // ── Shell (persistent bottom nav) ─────────────────────────────────────
      ShellRoute(
        builder: (context, state, child) => AppShell(child: child),
        routes: [
          GoRoute(
            path: RouteNames.dashboard,
            builder: (context, state) => const DashboardScreen(),
          ),
          GoRoute(
            path: RouteNames.attendance,
            builder: (context, state) => const AttendanceScreen(),
            routes: [
              GoRoute(
                path: 'my',
                builder: (context, state) => const AttendanceScreen(),
              ),
            ],
          ),
          GoRoute(
            path: RouteNames.chat,
            builder: (context, state) => const ChatGroupsScreen(),
          ),

          GoRoute(
            path: RouteNames.users,
            builder: (context, state) => const UserScreen(),
          ),

          GoRoute(
            path: RouteNames.settings,
            builder: (context, state) => const ProfileScreen(),
          ),
        ],
      ),
    ],
  );
}
