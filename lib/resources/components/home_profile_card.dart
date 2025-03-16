import 'package:flutter/material.dart';
import 'package:healty_ways/utils/app_urls.dart';

class HomeProfileCard extends StatelessWidget {
  const HomeProfileCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Profile Picture
        const CircleAvatar(
          backgroundImage:
              AssetImage('assets/images/profile.jpg'), //TODO: fix the link
          radius: 20,
        ),
        const SizedBox(width: 12), // Spacing between picture and text
        // Name and Description
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              'Jane Smith',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            Text(
              'Patient',
              style: TextStyle(
                fontSize: 12,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
