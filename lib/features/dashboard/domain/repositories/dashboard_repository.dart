import '../entities/dashboard_stats.dart';

abstract class DashboardRepository {
  Future<DashboardStats> getStats({int days = 11});
}