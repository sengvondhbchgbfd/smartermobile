import 'package:equatable/equatable.dart';

enum LeaveType { sick, annual, unpaid, other }

enum LeaveStatus { pending, approved, rejected, cancelled }

class LeaveEntity extends Equatable {
  final int leaveId;
  final int companyId;
  final int staffId;
  final LeaveType leaveType;
  final DateTime startDate;
  final DateTime endDate;
  final String? reason;
  final LeaveStatus status;
  final int? approvedBy;
  final String? approvedByName;
  final DateTime createdAt;
  final String? staffName;
  final String? staffAvatarUrl;

  const LeaveEntity({
    required this.leaveId,
    required this.companyId,
    required this.staffId,
    required this.leaveType,
    required this.startDate,
    required this.endDate,
    this.reason,
    required this.status,
    this.approvedBy,
    this.approvedByName,
    required this.createdAt,
    this.staffName,
    this.staffAvatarUrl,
  });

  String get displayName => staffName ?? 'Staff #$staffId';

  @override
  List<Object?> get props => [
    leaveId,
    companyId,
    staffId,
    leaveType,
    startDate,
    endDate,
    reason,
    status,
    approvedBy,
    approvedByName,
    createdAt,
    staffName,
    staffAvatarUrl,
  ];
}
