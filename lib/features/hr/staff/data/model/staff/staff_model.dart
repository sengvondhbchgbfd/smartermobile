import 'package:frontendmobile/features/hr/staff/data/model/staff/create_staff_request.dart';
import 'package:frontendmobile/features/hr/staff/data/model/staff/update_staff_request.dart';
import 'package:frontendmobile/features/hr/staff/data/model/staff_role/staff_role_model.dart';
import 'package:frontendmobile/features/hr/staff/domain/entities/staff_entity.dart';

class StaffModel extends StaffEntity {
  const StaffModel({
    super.id,
    super.companyId,       // ✅ optional now
    super.userId,
    super.staffRoleId,
    required super.name,
    super.gender,          // ✅ optional now
    super.dateOfBirth,     // ✅ optional now
    super.address,         // ✅ optional now
    super.email,           // ✅ optional now
    super.phone,           // ✅ optional now
    super.age,             // ✅ add age
    super.createdAt,
    super.avatarUrl,
    super.avatarPublicId,
    super.staffRole,
  });

  factory StaffModel.fromJson(Map<String, dynamic> json) => StaffModel(
    id:            json['staff_id']      as int?,
    companyId:     json['company_id']    as int?,
    userId:        json['user_id']       as int?,
    staffRoleId:   json['staff_role_id'] as int?,
    name:          json['name']          as String,
    gender:        json['gender']        as String?,
    dateOfBirth:   json['date_of_birth'] as String?,
    address:       json['address']       as String?,
    email:         json['email']         as String?,
    phone:         json['phone']         as String?,
    age:           json['age']           as int?,
    createdAt:     json['created_at'] != null
                       ? DateTime.parse(json['created_at'] as String)
                       : null,
    avatarUrl:      json['avatar_url']        as String?,
    avatarPublicId: json['avatar_public_id']  as String?,
    staffRole:           json['staff_role'] != null
                        ? StaffRoleModel.fromJson(json['staff_role'] as Map<String, dynamic>)
                        : null,
  );

  Map<String, dynamic> toJson() => CreateStaffRequest(
    userId:      userId,
    staffRoleId: staffRoleId,
    name:        name,
    gender:      gender,
    dateOfBirth: dateOfBirth,
    address:     address,
    email:       email,
    phone:       phone,
  ).toJson();

  Map<String, dynamic> toUpdateJson() => UpdateStaffRequest(
    userId:        userId,
    staffRoleId:   staffRoleId,
    name:          name,
    gender:        gender,
    dateOfBirth:   dateOfBirth,
    address:       address,
    email:         email,
    phone:         phone,
    avatarUrl:     avatarUrl,
    avatarPublicId: avatarPublicId,
  ).toJson();

  factory StaffModel.fromEntity(StaffEntity entity) => StaffModel(
    id:            entity.id,
    companyId:     entity.companyId,
    userId:        entity.userId,
    staffRoleId:   entity.staffRoleId,
    name:          entity.name,
    gender:        entity.gender,
    dateOfBirth:   entity.dateOfBirth,
    address:       entity.address,
    email:         entity.email,
    phone:         entity.phone,
    age:           entity.age,          // ✅ add age
    createdAt:     entity.createdAt,
    avatarUrl:     entity.avatarUrl,
    avatarPublicId: entity.avatarPublicId,
    staffRole: entity.staffRole != null
        ? StaffRoleModel.fromEntity(entity.staffRole!)
        : null,
  );

  StaffEntity toEntity() => StaffEntity(
    id:            id,
    companyId:     companyId,
    userId:        userId,
    staffRoleId:   staffRoleId,
    name:          name,
    gender:        gender,
    dateOfBirth:   dateOfBirth,
    address:       address,
    email:         email,
    phone:         phone,
    age:           age,                 // ✅ add age
    createdAt:     createdAt,
    avatarUrl:     avatarUrl,
    avatarPublicId: avatarPublicId,
    staffRole:          staffRole,
  );
}