import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:frontendmobile/features/auth/presentation/providers/auth_provider.dart';
import 'package:frontendmobile/shared/providers/core_providers.dart';
import 'app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SharedPreferences.getInstance();

  // ── Restore session before the app renders any screen ──────────────────────
  final container = ProviderContainer();

  final storage = container.read(secureStorageProvider);
  final token = await storage.getAccessToken();
  final user = await storage.getUserInfo();

  if (token != null && user != null) {
    // Restore exactly what AuthNotifier.login() sets
    container.read(currentUserProvider.notifier).state = user;
  }

  runApp(UncontrolledProviderScope(container: container, child: const MyApp()));
}
