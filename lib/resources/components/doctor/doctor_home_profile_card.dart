import 'package:healty_ways/utils/app_urls.dart';
import 'package:healty_ways/view_model/profile_view_model.dart';

class DoctorHomeProfileCard extends StatelessWidget {
  DoctorHomeProfileCard({super.key});

  final ProfileViewModel _profileVM = Get.find<ProfileViewModel>();

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Get.toNamed(RouteName.doctorProfileView),
      child: Obx(() {
        final profile = _profileVM.profile;
        final profilePhoto = _getProfileImage(profile['profileImage']);
        final userName = profile['name'] ?? 'Junaid Ahmed';

        return Row(
          children: [
            CircleAvatar(
              radius: 20,
              backgroundImage: profilePhoto,
              onBackgroundImageError: (exception, stackTrace) =>
                  const AssetImage('assets/images/profile.jpg'),
            ),
            const SizedBox(width: 12),
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
                  'Doctor',
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
