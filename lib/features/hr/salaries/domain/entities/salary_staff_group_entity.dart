import 'package:frontendmobile/features/hr/salaries/domain/entities/salaries_entity.dart';


class SalaryStaffGroupEntity {
  final int staffId;
  final int userId;
  final String username;
  final String fullName;
  final List<SalaryEntity> salaries;

  SalaryStaffGroupEntity({
    required this.staffId,
    required this.userId,
    required this.username,
    required this.fullName,
    required this.salaries,
  });
}