import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:frontendmobile/core/cache/cache_service.dart';
import 'package:frontendmobile/core/network/dio_client.dart';
import 'package:frontendmobile/core/network/network_info.dart';
import 'package:frontendmobile/core/storage/secure_storage_service.dart';
import 'package:frontendmobile/shared/providers/core_providers.dart';
import 'package:frontendmobile/shared/providers/sharedPreferencesProvider.dart';

final secureStorage = SecureStorageService(const FlutterSecureStorage());
//////////////////////////////////////////////////////////////////////
// ── Providers ────────────────────────────────
//////////////////////////////////////////////////////////////////////
final secureStorageProvider = Provider<SecureStorageService>((ref) {
  return SecureStorageService(const FlutterSecureStorage());
});

//////////////////////////////////////////////////////////////////////
// Network
///////////////////////////////////////////////////////////////////////

final networkInfoProvider = Provider<NetworkInfo>((ref) {
  final connectivity = ref.read(connectivityProvider);
  return NetworkInfoImpl(connectivity);
});

/////////////////////////////////////////////////////////////////////
// Cache
////////////////////////////////////////////////////////////////////
///
final cacheServiceProvider = FutureProvider<CacheService>((ref) async {
  final prefs = await ref.watch(sharedPreferencesProvider.future);
  return CacheService(prefs);
});

////////////////////////////////////////////////////////////////////
//
////////////////////////////////////////////////////////////////////

final dioClientProvider = FutureProvider<DioClient>((ref) async {
  final storage = ref.read(secureStorageProvider);
  final networkInfo = ref.read(networkInfoProvider);
  final cache = await ref.watch(cacheServiceProvider.future);
  return DioClient(storage, networkInfo, cache);
});
