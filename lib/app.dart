import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontendmobile/core/themes/app_theme.dart';
import 'package:frontendmobile/features/auth/presentation/providers/auth_provider.dart';
import 'config/routes/app_router.dart';

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch currentUserProvider so the router rebuilds when auth state changes
    // (login → home, logout → login)
    ref.watch(currentUserProvider);

    return MaterialApp.router(
      themeMode: ThemeMode.system,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      debugShowCheckedModeBanner: false,
      routerConfig: AppRouter.router,
    );
  }
}
