import 'package:frontendmobile/features/communication/chat/domain/entities/chat_group_entity.dart';

class ChatGroupModel extends ChatGroupEntity {
  const ChatGroupModel({
    required super.groupId,
    required super.companyId,
    super.groupName,
    required super.chatType,
    required super.createdBy,
    required super.isActive,
  });
  ///////////////////////////////////////////////////////
  ///
  //////////////////////////////////////////////////////

  factory ChatGroupModel.fromJson(Map<String, dynamic> json) {
    return ChatGroupModel(
      groupId: json['group_id'] as int,
      companyId: json['company_id'] as int,
      groupName: json['group_name']?.toString(),
      chatType: (json['chat_type'] as String?) == 'direct'
          ? ChatType.direct
          : ChatType.group,
      createdBy: json['created_by'] as int,
      isActive: json['is_active'] as bool? ?? true,
    );
  }

  ///////////////////////////////////////////////////////
  ///
  //////////////////////////////////////////////////////
  Map<String, dynamic> toJson() => {
    'group_id': groupId,
    'company_id': companyId,
    'group_name': groupName,
    'chat_type': chatType == ChatType.direct ? 'direct' : 'group',
    'created_by': createdBy,
    'is_active': isActive,
  };
}
