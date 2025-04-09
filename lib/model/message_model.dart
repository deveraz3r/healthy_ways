import 'package:cloud_firestore/cloud_firestore.dart';

enum MessageType {
  text,
  image,
  file,
  audio,
  video,
}

class MessageModel {
  final String id;
  final String chatId;
  final String senderId;
  final String receiverId;
  final String? content; // for text messages
  final String? fileUrl; // for image/file/audio
  final String? fileName; // optional for file-type
  final MessageType type;
  final DateTime timestamp;
  final bool isRead;

  MessageModel({
    required this.id,
    required this.chatId,
    required this.senderId,
    required this.receiverId,
    this.content,
    this.fileUrl,
    this.fileName,
    required this.type,
    required this.timestamp,
    required this.isRead,
  });

  factory MessageModel.fromMap(Map<String, dynamic> map) {
    return MessageModel(
      id: map['id'],
      chatId: map['chatId'],
      senderId: map['senderId'],
      receiverId: map['receiverId'],
      content: map['content'],
      fileUrl: map['fileUrl'],
      fileName: map['fileName'],
      type: MessageType.values.firstWhere((e) => e.name == map['type']),
      timestamp: (map['timestamp'] as Timestamp).toDate(),
      isRead: map['isRead'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'chatId': chatId,
      'senderId': senderId,
      'receiverId': receiverId,
      'content': content,
      'fileUrl': fileUrl,
      'fileName': fileName,
      'type': type.name,
      'timestamp': timestamp,
      'isRead': isRead,
    };
  }
}
