import 'package:flutter/material.dart';
import 'package:healty_ways/utils/app_urls.dart';

class ChatView extends StatelessWidget {
  const ChatView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ReusableAppBar(
        titleText: "Chat View",
        enableBack: true,
      ),
    );
  }
}
