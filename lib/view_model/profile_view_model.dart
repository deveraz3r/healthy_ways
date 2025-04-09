import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:healty_ways/model/doctor_model.dart';
import 'package:healty_ways/model/patient_model.dart';
import 'package:healty_ways/model/pharmacist_model.dart';
import 'package:healty_ways/model/user_model.dart';
import 'package:healty_ways/view_model/auth_view_model.dart';

class ProfileViewModel extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final Rx<UserModel?> _profile = Rx<UserModel?>(null);
  final Rx<UserRole> _currentRole = UserRole.patient.obs;

  UserModel? get profile => _profile.value;
  UserRole get currentRole => _currentRole.value;

  Future<void> fetchProfile(String uid, UserRole role) async {
    try {
      _currentRole.value = role;

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

      print("Profile Uid: ${profile?.uid}");

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

  // Helper getters for role checks
  bool get isDoctor => _currentRole.value == UserRole.doctor;
  bool get isPatient => _currentRole.value == UserRole.patient;
  bool get isPharmacist => _currentRole.value == UserRole.pharmacist;

  // Get role-specific data with type safety
  T? getRoleData<T>() {
    if (_profile.value is T) {
      return _profile.value as T;
    }
    return null;
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
