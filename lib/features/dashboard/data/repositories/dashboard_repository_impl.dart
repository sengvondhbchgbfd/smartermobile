import 'package:frontendmobile/features/dashboard/domain/entities/dashboard_stats.dart';
import 'package:frontendmobile/features/dashboard/domain/repositories/dashboard_repository.dart';
import '../datasource/dashboard_remote_datasource.dart';

class DashboardRepositoryImpl implements DashboardRepository {
  final DashboardRemoteDatasource remote;
  DashboardRepositoryImpl(this.remote);

  @override
  Future<DashboardStats> getStats({int days = 11}) {
    return remote.getStats(days: days);
  }
}