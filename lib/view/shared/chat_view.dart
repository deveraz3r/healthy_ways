import 'package:healty_ways/utils/app_urls.dart';
import 'package:image_picker/image_picker.dart';

class ChatView extends StatelessWidget {
  final ChatViewModel chatVM = Get.find<ChatViewModel>();
  final TextEditingController messageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Obx(() {
          final chat = chatVM.currentChat.value;
          if (chat == null) return const Text('Chat');
          return FutureBuilder<UserModel>(
            future: _getParticipant(chat),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              } else if (snapshot.hasData) {
                return Text(snapshot.data!.fullName);
              } else {
                return const Text("Unknown User");
              }
            },
          );
        }),
      ),
      body: Column(
        children: [
          Expanded(
            child: Obx(
              () {
                final messages = chatVM.messages;

                if (messages.isEmpty) {
                  return const Center(child: Text('No messages yet.'));
                }

                return ListView.builder(
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final message = messages[index];
                    bool isCurrentUser =
                        message.senderId == chatVM.profileVM.profile?.uid;
                    return Align(
                      alignment: isCurrentUser
                          ? Alignment.centerRight
                          : Alignment.centerLeft,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 4.0,
                          horizontal: 10.0,
                        ),
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color:
                                isCurrentUser ? Colors.blue : Colors.grey[300],
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            message.content ?? "Unable to load message",
                            style: TextStyle(
                              color:
                                  isCurrentUser ? Colors.white : Colors.black,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.attach_file),
                  onPressed: () => _sendImageMessage(),
                ),
                Expanded(
                  child: TextField(
                    controller: messageController,
                    decoration: const InputDecoration(
                      hintText: 'Type a message',
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: () => _sendTextMessage(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _sendTextMessage() {
    final messageContent = messageController.text.trim();
    if (messageContent.isNotEmpty) {
      final currentChat = chatVM.currentChat.value;
      if (currentChat != null) {
        final receiverId = currentChat.participantIds.firstWhere(
            (id) => id != chatVM.profileVM.profile?.uid,
            orElse: () => chatVM.profileVM.profile?.uid ?? '');
        chatVM.sendTextMessage(currentChat.id, receiverId, messageContent);
        messageController.clear();
      }
    }
  }

  void _sendImageMessage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      final file = File(pickedFile.path);
      final currentChat = chatVM.currentChat.value;
      if (currentChat != null) {
        final receiverId = currentChat.participantIds.firstWhere(
          (id) => id != chatVM.profileVM.profile?.uid,
          orElse: () => chatVM.profileVM.profile?.uid ?? '',
        );
        chatVM.sendFileMessage(
          chatId: currentChat.id,
          receiverId: receiverId,
          file: file,
          type: MessageType.image,
        );
      }
    }
  }

  Future<UserModel> _getParticipant(ChatModel chat) async {
    final currentUser = chatVM.profileVM.profile;
    if (currentUser == null) {
      return UserModel(
        uid: 'unknown',
        fullName: 'Unknown',
        email: "unknown@unknown.com",
        role: UserRole.patient,
      );
    }

    final participantId = chat.participantIds.firstWhere(
      (id) => id != currentUser.uid,
      orElse: () => currentUser.uid,
    );

    return await chatVM.profileVM.getProfileDataById(participantId) ??
        currentUser;
  }
}
