class StatCardData {
  final double value;
  final double? badgePct;
  final String sub;
  final List<double> spark;
  final double? stockIn;
  final double? stockOut;
  final double? currentPeriodValue;
  final double? previousPeriodValue;
  final double? allTimeValue;

  const StatCardData({
    required this.value,
    this.badgePct,
    required this.sub,
    required this.spark,
    this.stockIn,
    this.stockOut,
    this.currentPeriodValue,
    this.previousPeriodValue,
    this.allTimeValue,
  });
}

class DashboardStats {
  final StatCardData liveChat;
  final StatCardData stock;
  final StatCardData expenses;
  final StatCardData revenue;
  final StatCardData stockValue;

  const DashboardStats({
    required this.liveChat,
    required this.stock,
    required this.expenses,
    required this.revenue,
    required this.stockValue,
  });
}
