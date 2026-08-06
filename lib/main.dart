import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontendmobile/features/hr/staff/presentation/providers/staff_notifier.dart';
import 'package:frontendmobile/features/inventory/product/presentation/providers/product_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:frontendmobile/features/auth/presentation/providers/auth_provider.dart';
import 'package:frontendmobile/shared/providers/core_providers.dart';
import 'app.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");

  await SharedPreferences.getInstance();

  // ── Restore session before the app renders any screen ──────────────────────
  // override diolcient
  //

  final container = ProviderContainer(
    // overrides: [
    //   customerDioClientProvider.overrideWith(
    //     (ref) => ref.watch(dioClientProvider).requireValue,
    //   ),
    //   invoiceDioClientProvider.overrideWith(
    //     (ref) => ref.watch(dioClientProvider).requireValue,
    //   ),
    // ],
  );

  //////////////////////////////////////////////////////////////////////////////
  final storage = container.read(secureStorageProvider);
  final token = await storage.getAccessToken();
  final user = await storage.getUserInfo();

  if (token != null && user != null) {
    container.read(currentUserProvider.notifier).state = user;
    unawaited(container.read(staffNotifierProvider.future));
    unawaited(container.read(productNotifierProvider.notifier).loadAll());
  }

  runApp(UncontrolledProviderScope(container: container, child: const MyApp()));
}
