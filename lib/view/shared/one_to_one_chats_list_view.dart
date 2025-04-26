import 'package:healty_ways/utils/app_urls.dart';

class OneToOneChatsListView extends StatelessWidget {
  final ChatViewModel chatVM = Get.find<ChatViewModel>();
  final ProfileViewModel profileVM = Get.find<ProfileViewModel>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Chats"),
      ),
      body: Obx(
        () {
          if (chatVM.chats.isEmpty) {
            return const Center(child: Text('No chats available'));
          }

          return ListView.builder(
            itemCount: chatVM.chats.length,
            itemBuilder: (context, index) {
              final chat = chatVM.chats[index];
              final participantFuture = _getParticipant(chat);

              return FutureBuilder<UserModel>(
                future: participantFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const ListTile(
                      title: Text('Loading...'),
                      leading: CircularProgressIndicator(),
                    );
                  } else if (snapshot.hasError) {
                    return const ListTile(
                      title: Text('Error fetching participant'),
                      leading: Icon(Icons.error),
                    );
                  } else if (!snapshot.hasData) {
                    return const ListTile(
                      title: Text('No participant found'),
                      leading: Icon(Icons.error),
                    );
                  }

                  final participant = snapshot.data!;

                  return ListTile(
                    onTap: () => _onChatTap(context, chat, participant),
                    leading: CircleAvatar(
                      backgroundImage:
                          _getProfileImage(participant.profileImage),
                      radius: 24,
                    ),
                    title: Text(participant.fullName),
                    subtitle: Text(chat.lastMessage?.content ?? 'No message'),
                    trailing: Text(_formatTime(chat.updatedAt)),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }

  void _onChatTap(
    BuildContext context,
    ChatModel chat,
    UserModel participant,
  ) async {
    try {
      await chatVM.startChatWithUser(participant.uid);
      Get.toNamed(RouteName.chatView, arguments: chat);
    } catch (e) {
      Get.snackbar("Error", "Failed to open chat: ${e.toString()}");
    }
  }

  Future<UserModel> _getParticipant(ChatModel chat) async {
    final currentUser = profileVM.profile!;
    final participantId = chat.participantIds.firstWhere(
      (id) => id != currentUser.uid,
      orElse: () => currentUser.uid,
    );

    if (participantId == currentUser.uid) {
      return currentUser;
    }

    final participant = await profileVM.getProfileDataById(participantId);

    if (participant == null) {
      return UserModel(
        uid: participantId,
        fullName: 'Unknown User',
        email: 'unknown@example.com',
        role: UserRole.patient,
      );
    }

    return participant;
  }

  ImageProvider _getProfileImage(String? imageUrl) {
    if (imageUrl == null || imageUrl.isEmpty) {
      return const AssetImage('assets/images/profile.jpg');
    }
    try {
      return NetworkImage(imageUrl);
    } catch (e) {
      return const AssetImage('assets/images/profile.jpg');
    }
  }

  String _formatTime(DateTime? dateTime) {
    if (dateTime == null) return 'Unknown';
    return '${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}';
  }
}
