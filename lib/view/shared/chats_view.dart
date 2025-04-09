import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:healty_ways/model/doctor_model.dart';
import 'package:healty_ways/model/patient_model.dart';
import 'package:healty_ways/model/pharmacist_model.dart';
import 'package:healty_ways/model/user_model.dart';
import 'package:healty_ways/view_model/chat_view_model.dart';
import 'package:healty_ways/model/chat_room_model.dart';
import 'package:healty_ways/model/message_model.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class ChatView extends StatelessWidget {
  final ChatModel chat = Get.arguments;
  final ChatViewModel chatVM = Get.find<ChatViewModel>();
  final TextEditingController messageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_getParticipant(chat).fullName),
      ),
      body: Column(
        children: [
          Expanded(
            child: Obx(
              () {
                final messages = chatVM.messages;

                if (messages.isEmpty) {
                  return Center(child: Text('No messages yet.'));
                }

                return ListView.builder(
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final message = messages[index];
                    return ListTile(
                      title: Text(message.content ?? "Unable to load message"),
                      subtitle: message.type == MessageType.file
                          ? Text("File: ${message.fileName}")
                          : null,
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
                  icon: Icon(Icons.attach_file),
                  onPressed: () => _sendImageMessage(),
                ),
                Expanded(
                  child: TextField(
                    controller: messageController,
                    decoration: InputDecoration(
                      hintText: 'Type a message',
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
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
      chatVM.sendTextMessage(
          chat.id,
          chat.participantIds
              .firstWhere((id) => id != chatVM.profileVM.profile!.uid),
          messageContent);
      messageController.clear();
    }
  }

  void _sendImageMessage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      final file = File(pickedFile.path);
      chatVM.sendFileMessage(
        chatId: chat.id,
        receiverId: chat.participantIds
            .firstWhere((id) => id != chatVM.profileVM.profile!.uid),
        file: file,
        type: MessageType.image,
      );
    }
  }

  UserModel _getParticipant(ChatModel chat) {
    final currentUser = chatVM.profileVM.profile!;
    final participantId = chat.participantIds.firstWhere(
        (id) => id != currentUser.uid,
        orElse: () => currentUser.uid);

    if (participantId == currentUser.uid) {
      return currentUser;
    }

    // Directly return the participant using profileVM instead of calling _fetchUserById
    return _getUserFromProfile(participantId);
  }

  UserModel _getUserFromProfile(String userId) {
    // Here we directly return the user based on the profileVM profile
    if (chatVM.profileVM.profile!.uid == userId) {
      return chatVM.profileVM.profile!;
    }

    // Assuming the profileVM already holds all user data based on role
    if (chatVM.profileVM.profile!.role == UserRole.patient) {
      return chatVM.profileVM.profile as PatientModel;
    } else if (chatVM.profileVM.profile!.role == UserRole.doctor) {
      return chatVM.profileVM.profile as DoctorModel;
    } else if (chatVM.profileVM.profile!.role == UserRole.pharmacist) {
      return chatVM.profileVM.profile as PharmacistModel;
    } else {
      throw Exception('Unknown user role');
    }
  }
}
