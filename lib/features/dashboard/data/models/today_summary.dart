class TodaySummary {
  final int totalEmployees;
  final int presentCount;
  final int absentCount;
  final int lateCount;

  const TodaySummary({
    required this.totalEmployees,
    required this.presentCount,
    required this.absentCount,
    required this.lateCount,
  });

  double get attendancePercentage =>
      totalEmployees > 0 ? (presentCount / totalEmployees) * 100 : 0;

  factory TodaySummary.fromJson(Map<String, dynamic> json) {
    return TodaySummary(
      totalEmployees: json['total_employees'] ?? json['totalEmployees'] ?? 0,
      presentCount: json['present_count'] ?? json['presentCount'] ?? 0,
      absentCount: json['absent_count'] ?? json['absentCount'] ?? 0,
      lateCount: json['late_count'] ?? json['lateCount'] ?? 0,
    );
  }
}
