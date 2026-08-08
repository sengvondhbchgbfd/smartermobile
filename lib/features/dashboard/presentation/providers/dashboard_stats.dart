import '../../domain/entities/dashboard_stats.dart';

class StatCardModel extends StatCardData {
  const StatCardModel({
    required super.value,
    super.badgePct,
    required super.sub,
    required super.spark,
    super.stockIn,
    super.stockOut,
    super.currentPeriodValue,
    super.previousPeriodValue,
    super.allTimeValue,
  });

  factory StatCardModel.fromJson(Map<String, dynamic> json) {
    return StatCardModel(
      value: (json['value'] as num).toDouble(),
      badgePct: json['badge_pct'] != null
          ? (json['badge_pct'] as num).toDouble()
          : null,
      sub: json['sub'] as String,
      spark: (json['spark'] as List).map((e) => (e as num).toDouble()).toList(),
      stockIn: json['stock_in'] != null
          ? (json['stock_in'] as num).toDouble()
          : null,
      stockOut: json['stock_out'] != null
          ? (json['stock_out'] as num).toDouble()
          : null,
      currentPeriodValue: json['current_period_value'] != null
          ? (json['current_period_value'] as num).toDouble()
          : null,
      previousPeriodValue: json['previous_period_value'] != null
          ? (json['previous_period_value'] as num).toDouble()
          : null,
      allTimeValue: json['all_time_value'] != null
          ? (json['all_time_value'] as num).toDouble()
          : null,
    );
  }
}

class DashboardStatsModel extends DashboardStats {
  const DashboardStatsModel({
    required super.liveChat,
    required super.stock,
    required super.expenses,
    required super.revenue,
    required super.stockValue,
  });

  factory DashboardStatsModel.fromJson(Map<String, dynamic> json) {
    return DashboardStatsModel(
      liveChat: json['live_chat'] != null
          ? StatCardModel.fromJson(json['live_chat'])
          : const StatCardModel(value: 0, sub: '', spark: []),
      stock: StatCardModel.fromJson(json['stock']),
      expenses: StatCardModel.fromJson(json['expenses']),
      revenue: StatCardModel.fromJson(json['revenue']),
      stockValue: StatCardModel.fromJson(json['stock_value']),
    );
  }
}
