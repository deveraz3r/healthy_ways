import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import 'package:healty_ways/model/chat_room_model.dart';
import 'package:healty_ways/model/message_model.dart';
import 'package:healty_ways/view_model/profile_view_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';

class ChatViewModel extends GetxController {
  final _firestore = FirebaseFirestore.instance;
  final _storage = FirebaseStorage.instance;

  RxList<ChatModel> chats = <ChatModel>[].obs;
  Rx<ChatModel?> currentChat = Rx<ChatModel?>(null);
  RxList<MessageModel> messages = <MessageModel>[].obs;

  final profileVM = Get.find<ProfileViewModel>();

  @override
  void onInit() {
    super.onInit();
    listenToChats();
  }

  void listenToChats() {
    _firestore
        .collection('chats')
        .where('participantIds', arrayContains: profileVM.profile!.uid)
        .orderBy('updatedAt', descending: true)
        .snapshots()
        .listen((snapshot) {
      chats.value = snapshot.docs.map((doc) {
        return ChatModel.fromMap(doc.data());
      }).toList();
    });
  }

  void listenToMessages(String chatId) {
    currentChat.value = chats.firstWhereOrNull((chat) => chat.id == chatId);
    _firestore
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .orderBy('timestamp')
        .snapshots()
        .listen((snapshot) {
      messages.value =
          snapshot.docs.map((doc) => MessageModel.fromMap(doc.data())).toList();
    });
  }

  Future<void> sendTextMessage(
    String chatId,
    String receiverId,
    String content,
  ) async {
    final message = MessageModel(
      id: const Uuid().v4(),
      chatId: chatId,
      senderId: profileVM.profile!.uid,
      receiverId: receiverId,
      content: content,
      type: MessageType.text,
      timestamp: DateTime.now(),
      isRead: false,
    );

    // Send the message
    await _firestore
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .doc(message.id)
        .set(message.toMap());

    // Update the last message in the chat
    await _firestore.collection('chats').doc(chatId).update({
      'lastMessage': message.toMap(),
      'updatedAt': DateTime.now(),
    });
  }

  Future<void> sendFileMessage({
    required String chatId,
    required String receiverId,
    required File file,
    required MessageType type,
  }) async {
    final uuid = Uuid(); // Initialize the Uuid instance
    final fileName = file.path.split('/').last;
    final ref = _storage.ref().child('chat_files/$chatId/$fileName');

    // Upload the file and get the download URL
    await ref.putFile(file);

    final fileUrl = await ref.getDownloadURL();

    final message = MessageModel(
      id: uuid.v4(), // Use the v4() method to generate a unique id
      chatId: chatId,
      senderId: profileVM.profile!.uid,
      receiverId: receiverId,
      fileUrl: fileUrl,
      fileName: fileName,
      type: type,
      timestamp: DateTime.now(),
      isRead: false,
    );

    // Send the file message
    await _firestore
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .doc(message.id)
        .set(message.toMap());

    // Update the last message in the chat
    await _firestore.collection('chats').doc(chatId).update({
      'lastMessage': message.toMap(),
      'updatedAt': DateTime.now(),
    });
  }
}
