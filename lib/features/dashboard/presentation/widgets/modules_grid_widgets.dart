import 'package:flutter/material.dart';
import 'package:frontendmobile/config/routes/route_names.dart';
import 'package:frontendmobile/core/themes/app_pallets.dart';
import 'package:frontendmobile/features/dashboard/data/models/models.dart';
import 'package:go_router/go_router.dart';

// Each module carries its target route. Null = coming soon (shows snackbar).
final List<DashboardModule> modules = const [
  DashboardModule(
    title: 'User Control',
    subtitle: 'Roles & Permissions',
    icon: Icons.admin_panel_settings_rounded,
    color: Colors.indigo,
    route: RouteNames.staffRoles,
  ),
  DashboardModule(
    title: 'Attendance',
    subtitle: 'QR & Face Scan',
    icon: Icons.qr_code_scanner_rounded,
    color: Colors.green,
    route: RouteNames.attendance,
  ),
  DashboardModule(
    title: 'Chat System',
    subtitle: 'DM & Groups',
    icon: Icons.chat_rounded,
    color: Colors.purple,
    route: RouteNames.chat,
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
    route: null, // not yet implemented
  ),
  DashboardModule(
    title: 'Invoices',
    subtitle: 'Billing System',
    icon: Icons.receipt_long_rounded,
    color: Colors.orange,
    route: null, // not yet implemented
  ),
  DashboardModule(
    title: 'CRM',
    subtitle: 'Customers',
    icon: Icons.groups_rounded,
    color: Colors.red,
    route: null, // not yet implemented
  ),
  DashboardModule(
    title: 'Payroll',
    subtitle: 'Salary & Bonus',
    icon: Icons.payments_rounded,
    color: Colors.amber,
    route: RouteNames.salaries,
  ),
];

Widget buildModules(double screenWidth) {
  final cellWidth = (screenWidth - screenWidth * 0.09 - 14) / 2;
  final cellHeight = cellWidth * 0.85;

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const Text(
        'System Modules',
        style: TextStyle(
          color: Colors.white,
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
              const _tabRoutes = {
                RouteNames.dashboard,
                RouteNames.attendance,
                RouteNames.chat,
                RouteNames.users,
                RouteNames.settings,
              };

              Future.microtask(() {
                if (_tabRoutes.contains(route)) {
                  context.go(route);
                } else {
                  context.push(route);
                }
              });
            },
            child: Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Pallets.surfaceDark,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Pallets.borderDark),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: module.color.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(13),
                    ),
                    child: Icon(module.icon, color: module.color, size: 22),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        module.title,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 3),
                      Text(
                        module.subtitle,
                        style: const TextStyle(
                          color: Pallets.textSecondaryDark,
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
