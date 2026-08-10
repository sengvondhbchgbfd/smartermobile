class CompanyStatusHistoryEntity {
  final int id;
  final int companyId;
  final String oldStatus;
  final String newStatus;
  final String? reason;
  final int changedBy;
  final DateTime changedAt;

  const CompanyStatusHistoryEntity({
    required this.id,
    required this.companyId,
    required this.oldStatus,
    required this.newStatus,
    this.reason,
    required this.changedBy,
    required this.changedAt,
  });
}
