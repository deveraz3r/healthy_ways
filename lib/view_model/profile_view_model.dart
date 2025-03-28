import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProfileViewModel extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final RxMap<String, dynamic> _profile = RxMap<String, dynamic>();

  Map<String, dynamic> get profile => _profile;

  Future<void> fetchProfile(String uid) async {
    final doc = await _firestore.collection('users').doc(uid).get();
    _profile.value = doc.data() ?? {};
  }

  Future<void> updateProfile(String uid, Map<String, dynamic> data) async {
    await _firestore.collection('users').doc(uid).update(data);
    _profile.refresh();
  }
}
