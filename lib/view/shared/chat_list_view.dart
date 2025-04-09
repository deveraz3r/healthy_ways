import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:healty_ways/utils/routes/route_name.dart';
import 'package:healty_ways/view_model/chat_view_model.dart';
import 'package:healty_ways/model/chat_room_model.dart';
import 'package:healty_ways/model/user_model.dart';
import 'package:healty_ways/view_model/profile_view_model.dart';

class ChatsListView extends StatelessWidget {
  final ChatViewModel chatVM = Get.find<ChatViewModel>();
  final ProfileViewModel profileVM = Get.find<ProfileViewModel>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Chats"),
      ),
      body: Obx(
        () {
          if (chatVM.chats.isEmpty) {
            return Center(child: Text('No chats available'));
          }

          return ListView.builder(
            itemCount: chatVM.chats.length,
            itemBuilder: (context, index) {
              final chat = chatVM.chats[index];
              final participant = _getParticipant(chat);

              return ListTile(
                onTap: () => _onChatTap(context, chat),
                leading: CircleAvatar(
                  backgroundImage: NetworkImage(participant.profileImage ?? ''),
                  radius: 24,
                ),
                title: Text(participant.fullName),
                subtitle: Text(chat.lastMessage?.content ?? 'No message'),
                trailing: Text(_formatTime(chat.updatedAt ?? DateTime.now())),
              );
            },
          );
        },
      ),
    );
  }

  void _onChatTap(BuildContext context, ChatModel chat) {
    chatVM.listenToMessages(chat.id); // Start listening for messages
    Get.toNamed(RouteName.chatView, arguments: chat);
  }

  UserModel _getParticipant(ChatModel chat) {
    final currentUser = profileVM.profile!;
    final participantId = chat.participantIds.firstWhere(
        (id) => id != currentUser.uid,
        orElse: () => currentUser.uid);

    if (participantId == currentUser.uid) {
      return currentUser;
    }

    // Assuming users are fetched and converted into the correct model
    return _fetchUserById(participantId);
  }

  UserModel _fetchUserById(String userId) {
    // This is a simplified approach; you may want to fetch actual users from Firebase or your backend
    return UserModel(
        uid: userId,
        fullName: 'John Doe',
        email: 'johndoe@example.com',
        role: UserRole.patient);
  }

  String _formatTime(DateTime dateTime) {
    return '${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}';
  }
}
