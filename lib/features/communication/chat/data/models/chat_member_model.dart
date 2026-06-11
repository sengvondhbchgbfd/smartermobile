import 'package:frontendmobile/features/communication/chat/domain/entities/chat_member_entity.dart';

class ChatMemberModel extends ChatMemberEntity {
  const ChatMemberModel({
    required super.memberId,
    required super.groupId,
    required super.staffId,
    required super.companyId,
    required super.joinedAt,
    required super.isAdmin,
    super.staffName,
  });
  /////////////////////////////////////////////////////////////////
  ///
  ////////////////////////////////////////////////////////////////
  factory ChatMemberModel.fromJson(Map<String, dynamic> json) {
    return ChatMemberModel(
      memberId: json['member_id'] as int,
      groupId: json['group_id'] as int,
      staffId: json['staff_id'] as int,
      companyId: json['company_id'] as int,
      joinedAt:
          DateTime.tryParse(json['joined_at'] as String? ?? '') ??
          DateTime.now(),
      isAdmin: json['is_admin'] as bool? ?? false,
      staffName: json['staff_name'] as String?,
    );
  }
  /////////////////////////////////////////////////////////////////
  ///
  ////////////////////////////////////////////////////////////////
}
