import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontendmobile/core/service/local_notification_service.dart';
import 'package:frontendmobile/features/communication/notifications/presentation/providers/notification_provider.dart';
import 'package:frontendmobile/features/hr/staff/presentation/providers/staff_notifier.dart';
import 'package:frontendmobile/features/inventory/product/presentation/providers/product_provider.dart';
import 'package:frontendmobile/features/profile/presentation/providers/profile_providers.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:frontendmobile/features/auth/presentation/providers/auth_provider.dart';
import 'package:frontendmobile/shared/providers/core_providers.dart';
import 'app.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'config/routes/app_router.dart';
import 'config/routes/route_names.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  await SharedPreferences.getInstance();

  final container = ProviderContainer();

  await LocalNotificationService.init(
    onNotificationAction: (actionId, payload) {
      final id = payload != null ? int.tryParse(payload) : null;
      if (id == null) return;

      switch (actionId) {
        case LocalNotificationService.actionMarkRead:
          container.read(notificationNotifierProvider.notifier).markOneRead(id);
          break;

        case LocalNotificationService.actionView:
        default:
          container.read(appRouterProvider).push(RouteNames.notifications);
          break;
      }
    },
  );

  final storage = container.read(secureStorageProvider);
  final token = await storage.getAccessToken();
  final user = await storage.getUserInfo();

  if (token != null && user != null) {
    container.read(currentUserProvider.notifier).state = user;
    unawaited(container.read(profileNotifierProvider.future));
    unawaited(container.read(staffNotifierProvider.future));
    unawaited(container.read(productNotifierProvider.notifier).loadAll());
  }

  runApp(UncontrolledProviderScope(container: container, child: const MyApp()));
}
