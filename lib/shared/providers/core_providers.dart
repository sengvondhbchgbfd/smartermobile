import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:frontendmobile/core/cache/cache_service.dart';
import 'package:frontendmobile/core/network/dio_client.dart';
import 'package:frontendmobile/core/network/network_info.dart';
import 'package:frontendmobile/core/storage/secure_storage_service.dart';
import 'package:frontendmobile/shared/providers/sharedPreferencesProvider.dart';

final secureStorageProvider = Provider<SecureStorageService>((ref) {
  return SecureStorageService(const FlutterSecureStorage());
});

final companyIdProvider = FutureProvider.autoDispose<String?>((ref) async {
  final storage = ref.read(secureStorageProvider);
  final id = await storage.getCompanyId();
  return id;
});

////////////////////////////////////////////////////////////////////
///
///////////////////////////////////////////////////////////////////

final connectivityProvider = Provider<Connectivity>((ref) {
  return Connectivity();
});

final networkInfoProvider = Provider<NetworkInfo>((ref) {
  return NetworkInfoImpl(ref.read(connectivityProvider));
});

final cacheServiceProvider = FutureProvider<CacheService>((ref) async {
  final prefs = await ref.watch(sharedPreferencesProvider.future);
  return CacheService(prefs);
});

final dioClientProvider = FutureProvider<DioClient>((ref) async {
  final storage = ref.read(secureStorageProvider);
  final networkInfo = ref.read(networkInfoProvider);
  final cache = await ref.watch(cacheServiceProvider.future);
  return DioClient(storage, networkInfo, cache);
});

final dioProvider = FutureProvider<Dio>((ref) async {
  final client = await ref.watch(dioClientProvider.future);
  return client.dio;
});
