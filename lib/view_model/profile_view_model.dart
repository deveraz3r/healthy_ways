import 'package:healty_ways/utils/app_urls.dart';

class ProfileViewModel extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final Rx<UserModel?> _profile = Rx<UserModel?>(null);

  UserModel? get profile => _profile.value;
  UserRole get currentRole => _profile.value!.role;

  // Helper getters for role checks
  bool get isDoctor => currentRole == UserRole.doctor;
  bool get isPatient => currentRole == UserRole.patient;
  bool get isPharmacist => currentRole == UserRole.pharmacist;

  Future<void> fetchProfile(String uid, UserRole role) async {
    try {
      final doc = await _firestore.collection('users').doc(uid).get();

      if (!doc.exists || doc.data() == null) {
        _profile.value = null;
        return;
      }

      final data = doc.data()!;

      // Ensure basic fields exist
      if (data['email'] == null || data['name'] == null) {
        throw Exception("Required user fields are missing");
      }

      switch (role) {
        case UserRole.doctor:
          _profile.value = DoctorModel.fromJson(data);
          break;
        case UserRole.patient:
          _profile.value = PatientModel.fromJson(data);
          break;
        case UserRole.pharmacist:
          _profile.value = PharmacistModel.fromJson(data);
          break;
      }
    } catch (e) {
      Get.snackbar("Profile Error", "Failed to load profile data");
      _profile.value = null;
    }
  }

  Future<T?> getProfileDataById<T extends UserModel>(String uid) async {
    try {
      final doc = await _firestore.collection('users').doc(uid).get();
      if (!doc.exists) return null;

      final data = doc.data()!;

      if (T == PharmacistModel) {
        return PharmacistModel.fromJson(data) as T;
      } else if (T == DoctorModel) {
        return DoctorModel.fromJson(data) as T;
      } else if (T == PatientModel) {
        return PatientModel.fromJson(data) as T;
      }

      throw Exception('Unsupported model type');
    } catch (e) {
      Get.snackbar("Error", e.toString());
      return null;
    }
  }

  Future<void> updateProfile(UserModel updatedProfile) async {
    await _firestore
        .collection('users')
        .doc(updatedProfile.uid)
        .update(updatedProfile.toJson());
    _profile.value = updatedProfile;
  }
}
