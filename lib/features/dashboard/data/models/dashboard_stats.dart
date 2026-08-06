import 'package:flutter/material.dart';

import '../../domain/entities/dashboard_stats.dart';

class StatCardModel extends StatCardData {
  const StatCardModel({
    required super.value,
    super.badgePct,
    required super.sub,
    required super.spark,
    super.stockIn,
    super.stockOut,
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
      liveChat: StatCardModel.fromJson(json['live_chat']),
      stock: StatCardModel.fromJson(json['stock']),
      expenses: StatCardModel.fromJson(json['expenses']),
      revenue: StatCardModel.fromJson(json['revenue']),
      stockValue: StatCardModel.fromJson(json['stock_value']),
    );
  }
}

/////////////////////////////////
///
///.////////////////////////////

class DashboardStat {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const DashboardStat({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  });
}



