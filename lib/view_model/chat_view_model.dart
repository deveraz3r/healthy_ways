import 'package:healty_ways/utils/app_urls.dart';

class ChatViewModel extends GetxController {
  final _firestore = FirebaseFirestore.instance;
  final _storage = FirebaseStorage.instance;

  RxList<ChatModel> chats = <ChatModel>[].obs; // For oneToOne chats
  RxList<ChatModel> appointmentChats =
      <ChatModel>[].obs; // For appointment chats

  Rx<ChatModel?> currentChat = Rx<ChatModel?>(null);
  RxList<MessageModel> messages = <MessageModel>[].obs;

  final profileVM = Get.find<ProfileViewModel>();

  @override
  void onInit() {
    super.onInit();
    try {
      listenToChats(); // Listen to oneToOne chats
      listenToAppointmentChats(); // Listen to appointment chats
    } catch (e) {
      _handleError("Failed to initialize chat view model", e);
    }
  }

  // Listen to oneToOne chats
  void listenToChats() {
    try {
      _firestore
          .collection('chats')
          .where('participantIds', arrayContains: profileVM.profile!.uid)
          .where('type', isEqualTo: ChatType.oneToOne.name)
          .snapshots()
          .listen((snapshot) {
        try {
          chats.value = snapshot.docs.map((doc) {
            return ChatModel.fromMap(doc.data());
          }).toList();
        } catch (e) {
          _handleError("Failed to parse chat data", e);
        }
      }, onError: (error) {
        _handleError("Failed to listen to chats", error);
      });
    } catch (e) {
      _handleError("Failed to set up chats listener", e);
    }
  }

  // Listen to appointment chats
  void listenToAppointmentChats() {
    try {
      _firestore
          .collection('chats')
          .where('participantIds', arrayContains: profileVM.profile!.uid)
          .where('type',
              isEqualTo: ChatType.appointment.name) // Filter by appointment
          .snapshots()
          .listen((snapshot) {
        try {
          appointmentChats.value = snapshot.docs.map((doc) {
            return ChatModel.fromMap(doc.data());
          }).toList();
        } catch (e) {
          _handleError("Failed to parse appointment chat data", e);
        }
      }, onError: (error) {
        _handleError("Failed to listen to appointment chats", error);
      });
    } catch (e) {
      _handleError("Failed to set up appointment chats listener", e);
    }
  }

  // Listen to messages in a specific chat
  void listenToMessages(String chatId) {
    try {
      currentChat.value = chats.firstWhereOrNull((chat) => chat.id == chatId) ??
          appointmentChats.firstWhereOrNull((chat) => chat.id == chatId);

      _firestore
          .collection('chats')
          .doc(chatId)
          .collection('messages')
          .orderBy('timestamp')
          .snapshots()
          .listen((snapshot) {
        try {
          messages.value = snapshot.docs
              .map((doc) => MessageModel.fromMap(doc.data()))
              .toList();
        } catch (e) {
          _handleError("Failed to parse message data", e);
        }
      }, onError: (error) {
        _handleError("Failed to listen to messages", error);
      });
    } catch (e) {
      _handleError("Failed to set up messages listener", e);
    }
  }

  Future<void> startChatWithUser(String otherUserId) async {
    try {
      final existingChat =
          await _checkExistingChat(otherUserId, ChatType.oneToOne);

      if (existingChat != null) {
        currentChat.value = existingChat;
        listenToMessages(existingChat.id);
      } else {
        ChatModel? chat = await _createNewChat(otherUserId, ChatType.oneToOne);
        currentChat.value = chat;
        listenToMessages(chat!.id);
      }
    } catch (e) {
      _handleError("Failed to start chat", e);
    }
  }

  Future<void> startAppointmentChat({
    required AppointmentModel appointment,
    required String otherUserId,
  }) async {
    try {
      final AppointmentsViewModel appointmentsVM =
          Get.find<AppointmentsViewModel>();
      ChatModel? chat;

      if (appointment.chatId != null && appointment.chatId!.isNotEmpty) {
        chat = await _checkExistingAppointmentChat(appointment.chatId);
      }

      if (chat != null) {
        currentChat.value = chat;
        listenToMessages(chat.id);
      } else {
        chat = await _createNewChat(otherUserId, ChatType.appointment);

        if (chat != null) {
          await appointmentsVM.saveChatId(appointment.appointmentId, chat.id);
          currentChat.value = chat;
          listenToMessages(chat.id);
        }
      }
    } catch (e) {
      _handleError("Failed to start appointment chat", e);
    }
  }

  Future<ChatModel?> _checkExistingChat(
      String otherUserId, ChatType chatType) async {
    try {
      final snapshot = await _firestore
          .collection('chats')
          .where('participantIds', arrayContains: profileVM.profile!.uid)
          .where("type", isEqualTo: chatType.name)
          .get();

      for (final doc in snapshot.docs) {
        final chat = ChatModel.fromMap(doc.data());
        if (chat.participantIds.contains(otherUserId)) {
          return chat;
        }
      }
      return null;
    } catch (e) {
      _handleError("Failed to check for existing chat", e);
      return null;
    }
  }

  Future<ChatModel?> _checkExistingAppointmentChat(String? chatId) async {
    if (chatId == null || chatId.isEmpty) return null;

    try {
      final snapshot = await _firestore.collection('chats').doc(chatId).get();
      if (snapshot.exists && snapshot.data() != null) {
        return ChatModel.fromMap(snapshot.data()!);
      } else {
        return null;
      }
    } catch (e) {
      _handleError("Failed to check for appointment chat", e);
      return null;
    }
  }

  Future<ChatModel?> _createNewChat(
      String otherUserId, ChatType chatType) async {
    try {
      final chatId = Uuid().v4();
      final chat = ChatModel(
        id: chatId,
        participantIds: [profileVM.profile!.uid, otherUserId],
        type: chatType,
        lastMessage: null,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      await _firestore.collection('chats').doc(chatId).set(chat.toMap());

      return chat;
    } catch (e) {
      _handleError("Failed to create new chat", e);
      return null;
    }
  }

  // Send a text message
  Future<void> sendTextMessage(
      String chatId, String receiverId, String content) async {
    try {
      final messageId = _firestore
          .collection('chats')
          .doc(chatId)
          .collection('messages')
          .doc()
          .id;

      final message = MessageModel(
        id: messageId,
        chatId: chatId,
        senderId: profileVM.profile!.uid,
        receiverId: receiverId,
        content: content,
        fileUrl: null,
        fileName: null,
        type: MessageType.text,
        timestamp: DateTime.now(),
        isRead: false,
      );

      await _firestore
          .collection('chats')
          .doc(chatId)
          .collection('messages')
          .doc(messageId)
          .set(message.toMap());

      // Update the last message in the chat
      await _firestore.collection('chats').doc(chatId).update({
        'lastMessage': message.toMap(),
        'updatedAt': DateTime.now(),
      });
    } catch (e) {
      _handleError("Failed to send text message", e);
    }
  }

  // Send a file message (e.g., image, video, etc.)
  Future<void> sendFileMessage({
    required String chatId,
    required String receiverId,
    required File file,
    required MessageType type,
  }) async {
    try {
      final fileName = file.path.split('/').last;
      final storageRef = _storage.ref().child('chat_files/$chatId/$fileName');

      // Upload the file to Firebase Storage
      final uploadTask = await storageRef.putFile(file);
      final fileUrl = await uploadTask.ref.getDownloadURL();

      final messageId = _firestore
          .collection('chats')
          .doc(chatId)
          .collection('messages')
          .doc()
          .id;

      final message = MessageModel(
        id: messageId,
        chatId: chatId,
        senderId: profileVM.profile!.uid,
        receiverId: receiverId,
        content: null,
        fileUrl: fileUrl,
        fileName: fileName,
        type: type,
        timestamp: DateTime.now(),
        isRead: false,
      );

      await _firestore
          .collection('chats')
          .doc(chatId)
          .collection('messages')
          .doc(messageId)
          .set(message.toMap());

      // Update the last message in the chat
      await _firestore.collection('chats').doc(chatId).update({
        'lastMessage': message.toMap(),
        'updatedAt': DateTime.now(),
      });
    } catch (e) {
      _handleError("Failed to send file message", e);
    }
  }

  void _handleError(String message, dynamic error) {
    Get.snackbar("Error", "$message: ${error.toString()}");
    debugPrint("$message: $error");
  }
}
