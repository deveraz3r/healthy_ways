import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:healty_ways/utils/app_urls.dart';
import 'package:healty_ways/view_model/patient/patient_profile_view_model.dart';

class DoctorHomeProfileCard extends StatelessWidget {
  DoctorHomeProfileCard({super.key});

  final ProfileViewModel _profileViewModel = Get.put(ProfileViewModel());

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Get.toNamed(RouteName.doctorProfileView);
      },
      child: Obx(() {
        return Row(
          children: [
            // Profile Picture
            CircleAvatar(
              backgroundImage: _profileViewModel.profile?.profilePhotoUrl !=
                      null
                  ? NetworkImage(_profileViewModel.profile!.profilePhotoUrl!)
                  : const AssetImage('assets/images/profile.jpg')
                      as ImageProvider,
              radius: 20,
            ),
            const SizedBox(width: 12),
            // Name and Description
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _profileViewModel.profile?.name ??
                      'Guest', // Display name or fallback to 'Guest'
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
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
      }),
    );
  }
}
