import 'package:equatable/equatable.dart';

class ChatMemberEntity extends Equatable {
  final int memberId;
  final int groupId;
  final int staffId;
  final int companyId;
  final DateTime joinedAt;
  final bool isAdmin;
  final String? staffName;

  const ChatMemberEntity({
    required this.memberId,
    required this.groupId,
    required this.staffId,
    required this.companyId,
    required this.joinedAt,
    required this.isAdmin,
    this.staffName,
  });
  @override
  List<Object> get props => [memberId, groupId, staffId, companyId];
}
