import 'package:healty_ways/utils/app_urls.dart';

class AppointmentChatView extends StatelessWidget {
  final ChatViewModel chatVM = Get.find<ChatViewModel>();

  AppointmentChatView({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
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
              alignment:
                  isCurrentUser ? Alignment.centerRight : Alignment.centerLeft,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 4.0, horizontal: 10.0),
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: isCurrentUser ? Colors.blue : Colors.grey[300],
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    message.content ?? "Unable to load message",
                    style: TextStyle(
                      color: isCurrentUser ? Colors.white : Colors.black,
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
