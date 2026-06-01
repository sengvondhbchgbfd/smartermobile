import 'package:equatable/equatable.dart';

enum ChatType { group, direct }

class ChatGroupEntity extends Equatable {
  final int groupId;
  final int companyId;
  final String? groupName;
  final ChatType chatType;
  final int createdBy;
  final bool isActive;

  ///////////////////////////////////////////
  ///
  ///////////////////////////////////////////

  const ChatGroupEntity({
    required this.groupId,
    required this.companyId,
    this.groupName,
    required this.chatType,
    required this.createdBy,
    required this.isActive,
  });

  ///////////////////////////////////////////
  ///
  ///////////////////////////////////////////

  @override
  List<Object?> get props => [
    groupId,
    companyId,
    groupName,
    chatType,
    createdBy,
    isActive,
  ];
}
