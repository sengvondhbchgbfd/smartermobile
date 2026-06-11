import 'package:frontendmobile/features/hr/salaries/domain/entities/salaries_entity.dart';
import 'package:frontendmobile/features/hr/salaries/domain/entities/salary_staff_group_entity.dart';

import 'salaries_model.dart';

class SalaryStaffGroupModel {
  final int staffId;
  final int userId;
  final String username;
  final String fullName;
  final List<SalaryModel> salaries;

  SalaryStaffGroupModel({
    required this.staffId,
    required this.userId,
    required this.username,
    required this.fullName,
    required this.salaries,
  });

  factory SalaryStaffGroupModel.fromJson(Map<String, dynamic> json) {
    return SalaryStaffGroupModel(
      staffId: json['staff_id'],
      userId: json['user_id'],
      username: json['username'],
      fullName: json['full_name'],
      salaries: (json['salaries'] as List)
          .map((e) => SalaryModel.fromJson(e))
          .toList(),
    );
  }
}

extension SalaryStaffGroupMapper on SalaryStaffGroupModel {
  SalaryStaffGroupEntity toEntity() {
    return SalaryStaffGroupEntity(
      staffId: staffId,
      userId: userId,
      username: username,
      fullName: fullName,
      salaries: List<SalaryEntity>.from(salaries),
    );
  }
}
