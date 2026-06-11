import 'package:equatable/equatable.dart';

enum WsEventType {
  newMessage,
  messageDeleted,
  messageRead,
  allMessagesRead,
  membersAdded,
  memberRemoved,
  groupDeleted,
  userOnline,
  userOffline,
  unknown,
}

class WsEventEntity extends Equatable {
  final WsEventType eventType;
  final Map<String, dynamic> payload;

  const WsEventEntity({required this.eventType, required this.payload});

  @override
  List<Object?> get props => [eventType, payload];
}
