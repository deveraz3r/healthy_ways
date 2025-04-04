import 'package:healty_ways/model/user_model.dart';
import 'package:healty_ways/utils/app_urls.dart';
import 'package:healty_ways/view_model/auth_view_model.dart';
import 'package:healty_ways/view_model/profile_view_model.dart';

class ReusableUserProfileCard extends StatelessWidget {
  ReusableUserProfileCard({super.key});

  final ProfileViewModel _profileVM = Get.find<ProfileViewModel>();
  final AuthViewModel _authVM = Get.find<AuthViewModel>();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      // Check auth state first
      if (_authVM.user == null) {
        return _buildGuestCard();
      }

      // Then check profile
      if (_profileVM.profile == null) {
        // Trigger profile fetch if not loaded
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _profileVM.fetchProfile(
              _authVM.user!.uid, _authVM.selectedRole.value);
        });
        return _buildLoadingCard();
      }

      return GestureDetector(
        onTap: _navigateToProfile,
        child: Row(
          children: [
            CircleAvatar(
              radius: 20,
              backgroundImage:
                  _getProfileImage(_profileVM.profile?.profileImage),
              onBackgroundImageError: (exception, stackTrace) =>
                  const AssetImage('assets/images/profile.jpg'),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _profileVM.profile?.fullName ?? 'User',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  _getRoleName(_profileVM.currentRole),
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    });
  }

  Widget _buildGuestCard() {
    return Row(
      children: [
        const CircleAvatar(
          radius: 20,
          backgroundImage: AssetImage('assets/images/profile.jpg'),
        ),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Guest',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.red[400],
              ),
            ),
            Text(
              'Please login',
              style: TextStyle(
                fontSize: 12,
                color: Colors.red[300],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildLoadingCard() {
    return Row(
      children: [
        const CircleAvatar(
          radius: 20,
          backgroundImage: AssetImage('assets/images/profile.jpg'),
        ),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 100,
              height: 16,
              color: Colors.grey[300],
            ),
            const SizedBox(height: 4),
            Container(
              width: 60,
              height: 12,
              color: Colors.grey[300],
            ),
          ],
        ),
      ],
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

  String _getRoleName(UserRole role) {
    switch (role) {
      case UserRole.doctor:
        return 'Doctor';
      case UserRole.patient:
        return 'Patient';
      case UserRole.pharmacist:
        return 'Pharmacist';
    }
  }

  void _navigateToProfile() {
    if (_authVM.user == null) {
      Get.toNamed(RouteName.login);
      return;
    }

    switch (_profileVM.currentRole) {
      case UserRole.doctor:
        Get.toNamed(RouteName.doctorProfileView);
        break;
      case UserRole.patient:
        Get.toNamed(RouteName.patientProfileView);
        break;
      case UserRole.pharmacist:
        //TODO: handle pharmacist profile settings
        // Get.toNamed(RouteName.pharmacistProfileView);
        break;
    }
  }
}
