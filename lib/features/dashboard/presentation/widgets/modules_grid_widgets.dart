import 'package:flutter/material.dart';
import 'package:frontendmobile/config/routes/route_names.dart';
import 'package:frontendmobile/core/extensions/user_info_extensions.dart';
import 'package:frontendmobile/core/themes/app_pallets.dart';
import 'package:frontendmobile/features/auth/data/models/auth_user_model.dart';
import 'package:frontendmobile/features/dashboard/data/models/models.dart';
import 'package:go_router/go_router.dart';

////////////////////////////////////////////////////////////////////////////////
///
////////////////////////////////////////////////////////////////////////////////

final List<DashboardModule> allModules = const [
  DashboardModule(
    title: 'Attendance',
    subtitle: 'QR &  Scan',
    icon: Icons.qr_code_scanner_rounded,
    color: Colors.green,
    route: RouteNames.attendance,
  ),
  DashboardModule(
    title: 'HR / Staff',
    subtitle: 'Employees',
    icon: Icons.people_alt_rounded,
    color: Colors.blue,
    route: RouteNames.staff,
  ),
  DashboardModule(
    title: 'Inventory',
    subtitle: 'Products & Stock',
    icon: Icons.inventory_2_rounded,
    color: Colors.teal,
    route: RouteNames.products,
  ),
  DashboardModule(
    title: 'Categories',
    subtitle: 'Product Groups',
    icon: Icons.category_rounded,
    color: Colors.cyan,
    route: RouteNames.categories,
  ),
  DashboardModule(
    title: 'Invoices',
    subtitle: 'Billing System',
    icon: Icons.receipt_long_rounded,
    color: Colors.orange,
    route: RouteNames.invoices,
  ),
  DashboardModule(
    title: 'Quotations',
    subtitle: 'Quotes & Estimates',
    icon: Icons.request_quote_rounded,
    color: Colors.pink,
    route: RouteNames.quotations,
  ),
  DashboardModule(
    title: 'Customers',
    subtitle: 'CRM',
    icon: Icons.groups_rounded,
    color: Colors.red,
    route: RouteNames.customers,
  ),
  DashboardModule(
    title: 'Suppliers',
    subtitle: 'Vendors',
    icon: Icons.local_shipping_rounded,
    color: Colors.brown,
    route: RouteNames.suppliers,
  ),
  DashboardModule(
    title: 'Payroll',
    subtitle: 'Salary & Bonus',
    icon: Icons.payments_rounded,
    color: Colors.amber,
    route: RouteNames.salaries,
  ),
  DashboardModule(
    title: 'Leave',
    subtitle: 'Time Off Requests',
    icon: Icons.event_busy_rounded,
    color: Colors.deepPurple,
    route: RouteNames.leaves,
  ),
];

////////////////////////////////////////////////////////////////////////////////
///
////////////////////////////////////////////////////////////////////////////////

List<DashboardModule> visibleModules(UserInfo? currentUser) {
  final canManageUsers = currentUser?.canManageUsers ?? false;
  final canViewStaff = currentUser?.canViewStaff ?? false;

  return allModules.where((m) {
    if (m.route == RouteNames.staffRoles) return canManageUsers;
    if (m.route == RouteNames.staff) return canViewStaff;
    return true;
  }).toList();
}

Widget buildModules(
  BuildContext context,
  double screenWidth,
  List<DashboardModule> modules,
) {
  final isDark = Theme.of(context).brightness == Brightness.dark;
  final cellWidth = (screenWidth - screenWidth * 0.09 - 14) / 2;
  final cellHeight = cellWidth * 0.85;

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        'System Modules',
        style: TextStyle(
          color: isDark ? Pallets.textPrimaryDark : Pallets.textPrimaryLight,
          fontWeight: FontWeight.bold,
          fontSize: 17,
        ),
      ),
      const SizedBox(height: 14),
      GridView.builder(
        shrinkWrap: true,
        itemCount: modules.length,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 14,
          mainAxisSpacing: 14,
          childAspectRatio: cellWidth / cellHeight,
        ),
        itemBuilder: (context, index) {
          final module = modules[index];
          final route = module.route;
          return InkWell(
            borderRadius: BorderRadius.circular(20),
            onTap: () {
              if (route == null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('${module.title} coming soon'),
                    duration: const Duration(seconds: 1),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
                return;
              }
              const tabRoutes = {
                RouteNames.dashboard,
                RouteNames.attendance,
                RouteNames.chat,
                RouteNames.users,
                RouteNames.settings,
              };
              Future.microtask(() {
                if (tabRoutes.contains(route)) {
                  context.go(route);
                } else {
                  context.push(route);
                }
              });
            },
            child: Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: isDark ? Pallets.surfaceCard : Pallets.surfaceLight,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isDark ? Pallets.borderDark : Pallets.borderLight,
                ),
                boxShadow: isDark
                    ? null
                    : [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.06),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: module.color.withOpacity(isDark ? 0.15 : 0.10),
                      borderRadius: BorderRadius.circular(13),
                    ),
                    child: Icon(module.icon, color: module.color, size: 22),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        module.title,
                        style: TextStyle(
                          color: isDark
                              ? Pallets.textPrimaryDark
                              : Pallets.textPrimaryLight,
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 3),
                      Text(
                        module.subtitle,
                        style: TextStyle(
                          color: isDark
                              ? Pallets.textSecondaryDark
                              : Pallets.textSecondaryLight,
                          fontSize: 11,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    ],
  );
}
