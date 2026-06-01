import 'package:frontendmobile/features/hr/leave/domain/entities/leave_entity.dart';

class LeaveModel {
  final int leaveId;
  final int? companyId;
  final int staffId;
  final String leaveType;
  final String startDate;
  final String endDate;
  final String? reason;
  final String status;
  final int? approvedBy;
  final String createdAt;
  final String? staffName; // ✅ from nested staff object
  final String? staffAvatarUrl; // ✅ from nested staff object

  const LeaveModel({
    required this.leaveId,
    this.companyId,
    required this.staffId,
    required this.leaveType,
    required this.startDate,
    required this.endDate,
    this.reason,
    required this.status,
    this.approvedBy,
    required this.createdAt,
    this.staffName,
    this.staffAvatarUrl,
  });

  factory LeaveModel.fromJson(Map<String, dynamic> json) {
    final staff = json['staff'] as Map<String, dynamic>?;
    return LeaveModel(
      leaveId: json['leave_id'] as int,
      companyId: json['company_id'] as int?,
      staffId: json['staff_id'] as int,
      leaveType: json['leave_type'] as String,
      startDate: json['start_date'] as String,
      endDate: json['end_date'] as String,
      reason: json['reason'] as String?,
      status: json['status'] as String,
      approvedBy: json['approved_by'] as int?,
      createdAt: json['created_at'] as String,
      staffName: staff?['name'] as String?,
      staffAvatarUrl: staff?['avatar_url'] as String?,
    );
  }

  LeaveEntity toEntity() => LeaveEntity(
    leaveId: leaveId,
    companyId: companyId ?? 0,
    staffId: staffId,
    leaveType: _mapLeaveType(leaveType),
    startDate: DateTime.parse(startDate),
    endDate: DateTime.parse(endDate),
    reason: reason,
    status: _mapLeaveStatus(status),
    approvedBy: approvedBy == 0 ? null : approvedBy,
    createdAt: DateTime.parse(createdAt),
    staffName: staffName,
    staffAvatarUrl: staffAvatarUrl,
  );

  LeaveType _mapLeaveType(String t) => switch (t) {
    'sick' => LeaveType.sick,
    'annual' => LeaveType.annual,
    'unpaid' => LeaveType.unpaid,
    _ => LeaveType.other,
  };

  LeaveStatus _mapLeaveStatus(String s) => switch (s) {
    'approved' => LeaveStatus.approved,
    'rejected' => LeaveStatus.rejected,
    'cancelled' => LeaveStatus.cancelled,
    _ => LeaveStatus.pending,
  };
}
