import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontendmobile/config/routes/app_shell.dart';
import 'package:frontendmobile/config/routes/go_router_refresh_stream.dart';
import 'package:frontendmobile/config/routes/route_names.dart';
import 'package:frontendmobile/features/auth/presentation/providers/auth_provider.dart';
import 'package:frontendmobile/features/auth/presentation/screens/register_screen.dart';
import 'package:frontendmobile/features/auth/presentation/screens/login_screen.dart';
import 'package:frontendmobile/features/auth/presentation/screens/splash_screen.dart';
import 'package:frontendmobile/features/communication/chat/presentation/screens/chat_groups_screen.dart';
import 'package:frontendmobile/features/communication/notifications/presentation/screens/notification_screen.dart';
import 'package:frontendmobile/features/company/domain/entities/company_entity.dart';
import 'package:frontendmobile/features/company/presentation/screens/company_register_screen.dart';
import 'package:frontendmobile/features/company/presentation/screens/company_screen.dart';
import 'package:frontendmobile/features/company/presentation/widgets/form/company_edit_screen.dart';
import 'package:frontendmobile/features/dashboard/presentation/screens/dashboard_screen.dart';
import 'package:frontendmobile/features/dashboard/presentation/setup_wizard/screens/wizard_screen.dart';
import 'package:frontendmobile/features/dashboard/presentation/searching/page/search_page.dart';
import 'package:frontendmobile/features/home/presentation/screens/home_screen.dart';
import 'package:frontendmobile/features/hr/attendance/presentation/screens/attendance_screen.dart';
import 'package:frontendmobile/features/hr/attendance/presentation/screens/attendance_settings_page.dart';
import 'package:frontendmobile/features/hr/leave/presentation/screens/leave_screen.dart';
import 'package:frontendmobile/features/hr/salaries/presentation/screens/salary_screen.dart';
import 'package:frontendmobile/features/hr/staff/domain/entities/staff_entity.dart';
import 'package:frontendmobile/features/hr/staff/domain/entities/staff_role_entity.dart';
import 'package:frontendmobile/features/hr/staff/presentation/screens/staff_avatar_update_screen.dart';
import 'package:frontendmobile/features/hr/staff/presentation/screens/staff_detail_screen.dart';
import 'package:frontendmobile/features/hr/staff/presentation/screens/staff_form_screen.dart';
import 'package:frontendmobile/features/hr/staff/presentation/screens/staff_role_from_screen.dart';
import 'package:frontendmobile/features/hr/staff/presentation/screens/staff_role_screen.dart';
import 'package:frontendmobile/features/hr/staff/presentation/screens/staff_screen.dart';
import 'package:frontendmobile/features/inventory/categories/presentation/screens/categories_detail.dart';
import 'package:frontendmobile/features/inventory/categories/presentation/screens/categories_screen.dart';
import 'package:frontendmobile/features/inventory/customer/presentation/screens/customer_detail_screen.dart';
import 'package:frontendmobile/features/inventory/invoice/presentation/screens/invoice_detail_screen.dart';
import 'package:frontendmobile/features/inventory/invoice/presentation/screens/invoice_screen.dart';
import 'package:frontendmobile/features/inventory/product/presentation/screens/product_detail_screen.dart';
import 'package:frontendmobile/features/inventory/product/presentation/screens/product_screen.dart';
import 'package:frontendmobile/features/inventory/quotations/presentation/screen/my_quotations_screen.dart';
import 'package:frontendmobile/features/inventory/quotations/presentation/screen/quotation_detail_screen.dart';
import 'package:frontendmobile/features/inventory/quotations/presentation/screen/quotation_list_screen.dart';
import 'package:frontendmobile/features/inventory/supplier/presentation/screens/supplier_detail_screen.dart';
import 'package:frontendmobile/features/inventory/supplier/presentation/screens/supplier_screen.dart';
import 'package:frontendmobile/features/onboarding/presentation/screens/onboarding_screen.dart';
import 'package:frontendmobile/features/profile/domain/entities/profile_entity.dart';
import 'package:frontendmobile/features/profile/presentation/providers/profile_providers.dart';
import 'package:frontendmobile/features/profile/presentation/screens/profile_screen.dart';
import 'package:frontendmobile/features/profile/presentation/widgets/profile_edit_card.dart';
import 'package:frontendmobile/features/settings/domain/entities/system_setting_entity.dart';
import 'package:frontendmobile/features/settings/domain/models/setting_create_extra.dart';
import 'package:frontendmobile/features/settings/presentation/screens/setting_detail_page.dart';
import 'package:frontendmobile/features/settings/presentation/screens/settings_screen.dart';
import 'package:frontendmobile/features/settings/presentation/widgets/setting_create_page.dart';
import 'package:frontendmobile/features/settings/presentation/widgets/setting_edit_page.dart';
import 'package:frontendmobile/features/settings/presentation/widgets/theme_mode_page.dart';
import 'package:frontendmobile/features/users/domain/entities/role_entity.dart';
import 'package:frontendmobile/features/users/domain/entities/user_entity.dart';
import 'package:frontendmobile/features/users/presentation/screen/user_screen.dart';
import 'package:frontendmobile/features/users/presentation/screen/fillter_users_screen.dart';
import 'package:frontendmobile/features/users/presentation/screen/user_detail_screen.dart';
import 'package:frontendmobile/features/users/presentation/widgets/creates/create_department_page.dart';
import 'package:frontendmobile/features/users/presentation/widgets/creates/create_role_page.dart';
import 'package:frontendmobile/features/users/presentation/widgets/creates/create_user_page.dart';
import 'package:frontendmobile/features/users/presentation/widgets/tabs/role_permissions_screen.dart';
import 'package:frontendmobile/features/users/presentation/widgets/update_user_page.dart';
import 'package:go_router/go_router.dart';

import 'package:frontendmobile/features/inventory/customer/presentation/screens/customer_screen.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: RouteNames.splash,
    refreshListenable: GoRouterRefreshStream(
      ref.watch(currentUserProvider.notifier).stream,
    ),

    redirect: (context, state) {
      final loggedIn = ref.read(currentUserProvider) != null;
      final loggingIn =
          state.matchedLocation == RouteNames.login ||
          state.matchedLocation == RouteNames.register;
      final onSplash = state.matchedLocation == RouteNames.splash;

      if (onSplash) return null;
      if (!loggedIn && !loggingIn) return RouteNames.login;
      if (loggedIn && loggingIn) return RouteNames.dashboard;

      return null;
    },

    routes: [
      //////////////////////////////////////////////////////////////////////////
      // ── Auth / Onboarding (no shell) ──────────────────────────────────────
      //////////////////////////////////////////////////////////////////////////
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

      //////////////////////////////////////////////////////////////////////////
      // ── Pushed screens — full screen, NO shell ────────────────────────────
      //////////////////////////////////////////////////////////////////////////
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

      //////////////////////////////////////////////////////////////////////////
      // ── Company ───────────────────────────────────────────────────────────
      //////////////////////////////////////////////////////////////////////////
      GoRoute(
        path: RouteNames.companyRegister,
        builder: (context, state) => const CompanyRegisterScreen(),
      ),

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

      //////////////////////////////////////////////////////////////////////////
      // ── HR Staff ──────────────────────────────────────────────────────────
      //////////////////////////////////////////////////////////////////////////
      GoRoute(
        path: RouteNames.staffRoles,
        builder: (context, state) => const StaffRoleScreen(),
      ),
      GoRoute(
        path: RouteNames.staffRoleForm,
        builder: (context, state) {
          final existing = state.extra as StaffRoleEntity?;
          return StaffRoleFormScreen(existing: existing);
        },
      ),
      GoRoute(
        path: RouteNames.staff,
        builder: (context, state) => const StaffScreen(),
      ),
      GoRoute(
        path: RouteNames.staffForm,
        builder: (context, state) {
          final existing = state.extra as StaffEntity?;
          return StaffFormScreen(existing: existing);
        },
      ),
      GoRoute(
        path: RouteNames.staffAvatarUpdate,
        builder: (context, state) {
          final id = int.parse(state.pathParameters['id']!);
          final args = state.extra as Map<String, dynamic>?;
          return StaffAvatarUpdateScreen(
            staffId: id,
            name: args?['name'] ?? '',
            currentAvatarUrl: args?['avatarUrl'],
          );
        },
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

      ////////////////////////////////////////////////////////////////////////
      ///
      ///////////////////////////////////////////////////////////////////////
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

      //////////////////////////////////////////////////////////////////////////
      // ── Users (outside shell — full screen pages) ─────────────────────────
      //////////////////////////////////////////////////////////////////////////
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
      GoRoute(
        path: '/users/role-permissions',
        builder: (context, state) {
          final role = state.extra as RoleEntity;
          return RolePermissionsScreen(role: role);
        },
      ),

      //////////////////////////////////////////////////////////////////////////
      // ── Inventory ─────────────────────────────────────────────────────────
      //////////////////////////////////////////////////////////////////////////
      GoRoute(
        path: RouteNames.categories,
        builder: (context, state) => const CategoriesScreen(),
      ),
      GoRoute(
        path: RouteNames.categoryDetail,
        name: 'categoryDetail',
        builder: (context, state) {
          final id = int.parse(state.pathParameters['id']!);
          return CategoryDetailScreen(categoryId: id);
        },
      ),
      GoRoute(
        path: RouteNames.products,
        builder: (context, state) => const ProductsScreen(),
      ),
      GoRoute(
        path: RouteNames.productDetail,
        builder: (context, state) {
          final id = int.parse(state.pathParameters['id']!);
          return ProductDetailScreen(productId: id);
        },
      ),

      //////////////////////////////////////////////////////////////////////////
      // ── Suppliers ─────────────────────────────────────────────────────────
      //////////////////////////////////////////////////////////////////////////
      GoRoute(
        path: RouteNames.suppliers,
        builder: (context, state) => const SuppliersScreen(),
      ),
      GoRoute(
        path: RouteNames.supplierDetail,
        builder: (context, state) {
          final idStr = state.pathParameters['id'];
          final id = int.tryParse(idStr ?? '');
          if (id == null) {
            return const Scaffold(
              body: Center(child: Text('Invalid supplier id.')),
            );
          }
          return SupplierDetailScreen(supplierId: id);
        },
      ),
      GoRoute(
        path: RouteNames.customers,
        builder: (context, state) => const CustomersScreen(),
      ),

      //////////////////////////////////////////////////////////////////////////
      //
      //////////////////////////////////////////////////////////////////////////
      GoRoute(
        path: RouteNames.customerDetail,
        builder: (context, state) {
          final id = int.parse(state.pathParameters['id']!);
          return CustomerDetailScreen(customerId: id);
        },
      ),

      //////////////////////////////////////////////////////////////////////////
      // ── Invoices ──────────────────────────────────────────────────────────
      //////////////////////////////////////////////////////////////////////////
      GoRoute(
        path: RouteNames.invoices,
        builder: (context, state) => const InvoicesScreen(),
      ),
      GoRoute(
        path: RouteNames.invoiceDetail,
        builder: (context, state) {
          final id = int.parse(state.pathParameters['id']!);
          return InvoiceDetailScreen(invoiceId: id);
        },
      ),

      ///////////////////////////////settings///////////////////////////////////
      ///
      //////////////////////////////////////////////////////////////////////////
      GoRoute(
        path: RouteNames.settings,
        builder: (context, state) => const SystemSettingsScreen(),
      ),
      GoRoute(
        path: RouteNames.systemSettingCreate,
        builder: (_, state) {
          final extra = state.extra;
          if (extra is SettingCreateExtra) {
            return SettingCreatePage(
              prefillKey: extra.key,
              prefillHint: extra.hint,
            );
          }
          return const SettingCreatePage();
        },
      ),
      GoRoute(
        path: RouteNames.systemSettingEdit,
        builder: (_, state) =>
            SettingEditPage(setting: state.extra as SystemSettingEntity),
      ),
      GoRoute(
        path: RouteNames.theme,
        builder: (context, state) => const ThemeModePage(),
      ),
      GoRoute(
        path: '/settings/payroll/currency',
        builder: (context, state) => SettingDetailPage(
          settingKey: 'currency_code',
          label: 'Currency Code',
          existing: state.extra as SystemSettingEntity?,
        ),
      ),
      GoRoute(
        path: '/settings/payroll/day',
        builder: (context, state) => SettingDetailPage(
          settingKey: 'payroll_day',
          label: 'Payroll Day',
          existing: state.extra as SystemSettingEntity?,
        ),
      ),
      GoRoute(
        path: '/settings/payroll/overtime',
        builder: (context, state) => SettingDetailPage(
          settingKey: 'overtime_rate_multiplier',
          label: 'Overtime Rate',
          existing: state.extra as SystemSettingEntity?,
        ),
      ),
      GoRoute(
        path: '/settings/leave/annual',
        builder: (context, state) => SettingDetailPage(
          settingKey: 'annual_leave_days',
          label: 'Annual Leave Days',
          existing: state.extra as SystemSettingEntity?,
        ),
      ),
      GoRoute(
        path: '/settings/leave/sick',
        builder: (context, state) => SettingDetailPage(
          settingKey: 'sick_leave_days',
          label: 'Sick Leave Days',
          existing: state.extra as SystemSettingEntity?,
        ),
      ),
      GoRoute(
        path: '/settings/leave/approval',
        builder: (context, state) => SettingDetailPage(
          settingKey: 'leave_approval_required',
          label: 'Approval Required',
          existing: state.extra as SystemSettingEntity?,
        ),
      ),
      //////////////////////////////////////////////////////////////////////////
      // Inventory
      //////////////////////////////////////////////////////////////////////////
      GoRoute(
        path: '/settings/inventory/low-stock',
        builder: (context, state) => SettingDetailPage(
          settingKey: 'low_stock_threshold',
          label: 'Low Stock Threshold',
          existing: state.extra as SystemSettingEntity?,
        ),
      ),
      GoRoute(
        path: '/settings/inventory/movement-approval',
        builder: (context, state) => SettingDetailPage(
          settingKey: 'stock_movement_approval',
          label: 'Movement Approval',
          existing: state.extra as SystemSettingEntity?,
        ),
      ),

      // Notifications
      GoRoute(
        path: '/settings/notifications/retention',
        builder: (context, state) => SettingDetailPage(
          settingKey: 'notification_retention_days',
          label: 'Retention Days',
          existing: state.extra as SystemSettingEntity?,
        ),
      ),
      GoRoute(
        path: '/settings/notifications/push',
        builder: (context, state) => SettingDetailPage(
          settingKey: 'push_notifications_enabled',
          label: 'Push Notifications',
          existing: state.extra as SystemSettingEntity?,
        ),
      ),

      // Company
      GoRoute(
        path: '/settings/company/timezone',
        builder: (context, state) => SettingDetailPage(
          settingKey: 'company_timezone',
          label: 'Timezone',
          existing: state.extra as SystemSettingEntity?,
        ),
      ),
      GoRoute(
        path: '/settings/company/language',
        builder: (context, state) => SettingDetailPage(
          settingKey: 'company_language',
          label: 'Language',
          existing: state.extra as SystemSettingEntity?,
        ),
      ),
      GoRoute(
        path: '/settings/company/max-staff',
        builder: (context, state) => SettingDetailPage(
          settingKey: 'max_staff_count',
          label: 'Max Staff Count',
          existing: state.extra as SystemSettingEntity?,
        ),
      ),

      GoRoute(
        path: '/settings/attendance',
        builder: (context, state) => const AttendanceSettingsPage(),
      ),

      //////////////////////////////////////////////////////////////////////////
      // ── Shell (persistent bottom nav) ─────────────────────────────────────
      //////////////////////////////////////////////////////////////////////////
      GoRoute(
        path: RouteNames.searchPage,
        builder: (context, state) => const SearchPage(),
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

      //////////////////////////////////////////////////////////////////////////
      ///
      //////////////////////////////////////////////////////////////////////////
      GoRoute(
        path: '/quotations',
        builder: (context, state) => const QuotationListScreen(),
      ),
      GoRoute(
        path: '/quotations/my',
        builder: (context, state) => const MyQuotationsScreen(),
      ),
      GoRoute(
        path: '/quotations/:id',
        builder: (context, state) => QuotationDetailScreen(
          quotationId: int.parse(state.pathParameters['id']!),
        ),
      ),

      ////////////////////////////////////////////////////////////////////////////
      ///
      ////////////////////////////////////////////////////////////////////////////
      ShellRoute(
        builder: (context, state, child) => Consumer(
          builder: (context, ref, _) {
            final profile = ref.watch(profileNotifierProvider);
            return AppShell(
              avatarUrl: profile.valueOrNull?.avatarUrl,
              child: child,
            );
          },
        ),
        routes: [
          GoRoute(
            path: RouteNames.dashboard,
            builder: (context, state) => const DashboardScreen(),
          ),
          GoRoute(
            path: RouteNames.users,
            builder: (context, state) => const UserScreen(),
          ),
          GoRoute(
            path: RouteNames.profile,
            builder: (context, state) => const ProfileScreen(),
          ),
        ],
      ),
    ],
  );
});
