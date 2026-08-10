import 'package:frontendmobile/features/company/domain/entities/compay_status_history_entity.dart';

class CompanyStatusHistoryModel extends CompanyStatusHistoryEntity {
  const CompanyStatusHistoryModel({
    required super.id,
    required super.companyId,
    required super.oldStatus,
    required super.newStatus,
    super.reason,
    required super.changedBy,
    required super.changedAt,
  });

  factory CompanyStatusHistoryModel.fromJson(Map<String, dynamic> json) {
    return CompanyStatusHistoryModel(
      id: json['id'] ?? 0,
      companyId: json['company_id'] ?? 0,
      oldStatus: json['old_status'] ?? '',
      newStatus: json['new_status'] ?? '',
      reason: json['reason'],
      changedBy: json['changed_by'] ?? 0,
      changedAt: DateTime.tryParse(json['changed_at'] ?? '') ?? DateTime.now(),
    );
  }
}
