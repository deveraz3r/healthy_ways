import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:healty_ways/model/patient/patient_profile.dart';

class ProfileViewModel extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Reactive profile object
  final Rx<Profile?> _profile = Rx<Profile?>(null);

  // Getter for the profile
  Profile? get profile => _profile.value;

  // Fetch profile data from Firestore
  Future<void> fetchProfile(String uid) async {
    try {
      final DocumentSnapshot<Map<String, dynamic>> snapshot =
          await _firestore.collection('profiles').doc(uid).get();

      if (snapshot.exists) {
        _profile.value = Profile.fromMap(snapshot.data()!);
      } else {
        _profile.value = null; // No profile found
      }
    } catch (e) {
      print('Error fetching profile: $e');
      rethrow;
    }
  }

  // Update profile data in Firestore
  Future<void> updateProfile(Profile updatedProfile) async {
    try {
      await _firestore
          .collection('profiles')
          .doc(updatedProfile.uid)
          .set(updatedProfile.toMap(), SetOptions(merge: true));
      _profile.value = updatedProfile; // Update the reactive profile
    } catch (e) {
      print('Error updating profile: $e');
      rethrow;
    }
  }

  // Clear profile data (e.g., on logout)
  void clearProfile() {
    _profile.value = null;
  }
}
