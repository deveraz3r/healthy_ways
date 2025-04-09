import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:healty_ways/model/message_model.dart';

enum ChatType {
  oneToOne,
  event, // appointment-specific, etc.
}

class ChatModel {
  final String id;
  final List<String> participantIds;
  final String? eventId;
  final ChatType type;
  final MessageModel? lastMessage;
  final DateTime createdAt;
  final DateTime updatedAt;

  ChatModel({
    required this.id,
    required this.participantIds,
    this.eventId,
    required this.type,
    this.lastMessage,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ChatModel.fromMap(Map<String, dynamic> map) {
    return ChatModel(
      id: map['id'],
      participantIds: List<String>.from(map['participantIds']),
      eventId: map['eventId'],
      type: ChatType.values.firstWhere((e) => e.name == map['type']),
      lastMessage: map['lastMessage'] != null
          ? MessageModel.fromMap(map['lastMessage'])
          : null,
      createdAt: (map['createdAt'] as Timestamp).toDate(),
      updatedAt: (map['updatedAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'participantIds': participantIds,
      'eventId': eventId,
      'type': type.name,
      'lastMessage': lastMessage?.toMap(),
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }
}
