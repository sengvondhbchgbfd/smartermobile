import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontendmobile/core/themes/app_theme.dart';
import 'config/routes/app_router.dart';

class MyApp extends ConsumerWidget { 
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) { 
    return MaterialApp.router(
      themeMode: ThemeMode.system,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      debugShowCheckedModeBanner: false,
      routerConfig: AppRouter.router,
    );
  }
}
