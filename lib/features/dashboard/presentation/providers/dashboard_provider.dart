import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontendmobile/features/dashboard/data/datasource/dashboard_remote_datasource.dart';
import 'package:frontendmobile/features/dashboard/domain/repositories/dashboard_repository.dart';
import 'package:frontendmobile/shared/providers/core_providers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../data/repositories/dashboard_repository_impl.dart';
import '../../domain/entities/dashboard_stats.dart';

part 'dashboard_provider.g.dart';

@riverpod
Future<DashboardRemoteDatasource> dashboardRemoteDatasource(Ref ref) async {
  final client = await ref.watch(dioClientProvider.future);
  return DashboardRemoteDatasource(client);
}

@riverpod
Future<DashboardRepository> dashboardRepository(Ref ref) async {
  final ds = await ref.watch(dashboardRemoteDatasourceProvider.future);
  return DashboardRepositoryImpl(ds);
}

@riverpod
class DashboardStatsNotifier extends _$DashboardStatsNotifier {
  @override
  Future<DashboardStats> build({int days = 11}) async {
    final repo = await ref.watch(dashboardRepositoryProvider.future);
    return repo.getStats(days: days);
  }

  Future<void> refresh({int days = 11}) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final repo = await ref.read(dashboardRepositoryProvider.future);
      return repo.getStats(days: days);
    });
  }
}
