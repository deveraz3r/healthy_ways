// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:healty_ways/model/chat_room_model.dart';
// import 'package:healty_ways/model/user_model.dart';
// import 'package:healty_ways/utils/app_urls.dart';
// import 'package:healty_ways/view_model/chat_view_model.dart';
// import 'package:healty_ways/model/message_model.dart';
// import 'package:image_picker/image_picker.dart';
// import 'dart:io';

// class ChatView extends StatelessWidget {
//   final ChatViewModel chatVM = Get.find<ChatViewModel>();
//   final TextEditingController messageController = TextEditingController();

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Obx(() {
//           final chat = chatVM.currentChat.value;
//           if (chat == null) return Text('Chat');
//           // Use the async method to fetch the participant
//           return FutureBuilder<UserModel>(
//             future: _getParticipant(chat),
//             builder: (context, snapshot) {
//               if (snapshot.connectionState == ConnectionState.waiting) {
//                 return CircularProgressIndicator();
//               } else if (snapshot.hasData) {
//                 return Text(snapshot.data!.fullName);
//               } else {
//                 return Text("Unknown User");
//               }
//             },
//           );
//         }),
//       ),
//       body: Column(
//         children: [
//           Expanded(
//             child: Obx(
//               () {
//                 final messages = chatVM.messages;

//                 if (messages.isEmpty) {
//                   return Center(child: Text('No messages yet.'));
//                 }

//                 return ListView.builder(
//                   itemCount: messages.length,
//                   itemBuilder: (context, index) {
//                     final message = messages[index];
//                     bool isCurrentUser =
//                         message.senderId == chatVM.profileVM.profile?.uid;
//                     return Align(
//                       alignment: isCurrentUser
//                           ? Alignment.centerRight
//                           : Alignment.centerLeft,
//                       child: Padding(
//                         padding: const EdgeInsets.symmetric(
//                             vertical: 4.0, horizontal: 10.0),
//                         child: Container(
//                           padding: EdgeInsets.all(10),
//                           decoration: BoxDecoration(
//                             color:
//                                 isCurrentUser ? Colors.blue : Colors.grey[300],
//                             borderRadius: BorderRadius.circular(10),
//                           ),
//                           child: Column(
//                             crossAxisAlignment: isCurrentUser
//                                 ? CrossAxisAlignment.end
//                                 : CrossAxisAlignment.start,
//                             children: [
//                               if (!isCurrentUser)
//                                 FutureBuilder<UserModel>(
//                                   future: _getParticipant(
//                                       chatVM.currentChat.value!),
//                                   builder: (context, snapshot) {
//                                     if (snapshot.connectionState ==
//                                         ConnectionState.waiting) {
//                                       return CircularProgressIndicator();
//                                     } else if (snapshot.hasData) {
//                                       return Text(
//                                         snapshot.data!.fullName,
//                                         style: TextStyle(
//                                             fontWeight: FontWeight.bold),
//                                       );
//                                     } else {
//                                       return Text(
//                                         "Unknown User",
//                                         style: TextStyle(
//                                             fontWeight: FontWeight.bold),
//                                       );
//                                     }
//                                   },
//                                 ),
//                               Text(
//                                 message.content ?? "Unable to load message",
//                                 style: TextStyle(
//                                     color: isCurrentUser
//                                         ? Colors.white
//                                         : Colors.black),
//                               ),
//                               if (message.type == MessageType.file)
//                                 Text(
//                                   "File: ${message.fileName}",
//                                   style: TextStyle(
//                                       color: isCurrentUser
//                                           ? Colors.white70
//                                           : Colors.black87),
//                                 ),
//                             ],
//                           ),
//                         ),
//                       ),
//                     );
//                   },
//                 );
//               },
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: Row(
//               children: [
//                 IconButton(
//                   icon: Icon(Icons.attach_file),
//                   onPressed: () => _sendImageMessage(),
//                 ),
//                 Expanded(
//                   child: TextField(
//                     controller: messageController,
//                     decoration: InputDecoration(
//                       hintText: 'Type a message',
//                     ),
//                   ),
//                 ),
//                 IconButton(
//                   icon: Icon(Icons.send),
//                   onPressed: () => _sendTextMessage(),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   void _sendTextMessage() {
//     final messageContent = messageController.text.trim();
//     if (messageContent.isNotEmpty) {
//       final currentChat = chatVM.currentChat.value;
//       if (currentChat != null) {
//         final receiverId = currentChat.participantIds.firstWhere(
//             (id) => id != chatVM.profileVM.profile?.uid,
//             orElse: () => chatVM.profileVM.profile?.uid ?? '');
//         chatVM.sendTextMessage(
//           currentChat.id,
//           receiverId,
//           messageContent,
//         );
//         messageController.clear();
//       }
//     }
//   }

//   void _sendImageMessage() async {
//     final picker = ImagePicker();
//     final pickedFile = await picker.pickImage(source: ImageSource.gallery);
//     if (pickedFile != null) {
//       final file = File(pickedFile.path);
//       final currentChat = chatVM.currentChat.value;
//       if (currentChat != null) {
//         final receiverId = currentChat.participantIds.firstWhere(
//           (id) => id != chatVM.profileVM.profile?.uid,
//           orElse: () => chatVM.profileVM.profile?.uid ?? '',
//         );
//         chatVM.sendFileMessage(
//           chatId: currentChat.id,
//           receiverId: receiverId,
//           file: file,
//           type: MessageType.image,
//         );
//       }
//     }
//   }

//   Future<UserModel> _getParticipant(ChatModel chat) async {
//     final currentUser = chatVM.profileVM.profile;
//     if (currentUser == null) {
//       // If profile is null, return a fallback value (e.g., empty UserModel)
//       return UserModel(
//         uid: 'unknown',
//         fullName: 'Unknown',
//         email: "unknown@unknown.com",
//         role: UserRole.patient,
//       );
//     }

//     final participantId = chat.participantIds.firstWhere(
//       (id) => id != currentUser.uid,
//       orElse: () => currentUser.uid,
//     );

//     // Fetch the participant asynchronously from the ProfileViewModel
//     return await _getUserFromId(participantId) ?? currentUser;
//   }

//   Future<UserModel> _getUserFromId(String userId) async {
//     // Fetch the user by their ID from the ProfileViewModel
//     final UserModel? user =
//         await Get.find<ProfileViewModel>().getProfileDataById(userId);

//     if (user != null) {
//       return user;
//     } else {
//       throw Exception('User not found for id: $userId');
//     }
//   }
// }
