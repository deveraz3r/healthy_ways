import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:healty_ways/view_model/profile_view_model.dart';

class PatientHomeProfileCard extends StatelessWidget {
  PatientHomeProfileCard({super.key});

  final ProfileViewModel _profileVM = Get.find<ProfileViewModel>();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final profile = _profileVM.profile;
      final profilePhoto = _getProfileImage(profile?['profileImage']);
      final userName = profile?['name'] ?? 'Guest';

      return Row(
        children: [
          // Profile Picture with error handling
          CircleAvatar(
            radius: 20,
            backgroundImage: profilePhoto,
            onBackgroundImageError: (exception, stackTrace) =>
                const AssetImage('assets/images/profile.jpg'),
          ),
          const SizedBox(width: 12),
          // Name and Description
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                userName,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const Text(
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
    });
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
}
