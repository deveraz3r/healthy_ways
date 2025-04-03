import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:healty_ways/model/doctor_model.dart';
import 'package:healty_ways/utils/app_urls.dart';
import 'package:healty_ways/view_model/profile_view_model.dart';

class DoctorsViewModel extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final RxList<DoctorModel> _allDoctors = <DoctorModel>[].obs;
  final RxList<DoctorModel> _filteredDoctors = <DoctorModel>[].obs;
  final RxString _searchQuery = ''.obs;
  final RxBool _isLoading = false.obs;

  List<DoctorModel> get doctors => _filteredDoctors;
  bool get isLoading => _isLoading.value;

  // ProfileViewModel instance to get current user profile
  final ProfileViewModel _profileViewModel = Get.find();

  @override
  void onInit() {
    super.onInit();
    fetchAllDoctors();
  }

  Future<void> fetchAllDoctors() async {
    try {
      _isLoading.value = true;
      final querySnapshot = await _firestore
          .collection('users')
          .where('role', isEqualTo: 'doctor')
          .get();

      _allDoctors.assignAll(querySnapshot.docs.map(_convertToDoctorModel));
      _filteredDoctors.assignAll(_allDoctors);
    } catch (e) {
      _handleError("Failed to fetch doctors", e);
    } finally {
      _isLoading.value = false;
    }
  }

  void updateSearchQuery(String query) {
    _searchQuery.value = query.toLowerCase();
    if (query.isEmpty) {
      _filteredDoctors.assignAll(_allDoctors);
    } else {
      _filteredDoctors.assignAll(_allDoctors.where((doctor) =>
          (doctor.fullName.toLowerCase().contains(query)) ||
          (doctor.specialty.toLowerCase().contains(query)) ||
          (doctor.qualification.toLowerCase().contains(query)) ||
          (doctor.location.toLowerCase().contains(query))));
    }
  }

  DoctorModel _convertToDoctorModel(
      QueryDocumentSnapshot<Map<String, dynamic>> doc) {
    return DoctorModel.fromJson({
      ...doc.data(),
      'uid': doc.id,
    });
  }

  void _handleError(String message, dynamic error) {
    Get.snackbar("Error", "$message: ${error.toString()}");
    debugPrint("$message: $error");
  }

  void updateDoctorSchedule(Map<String, List<AppointmentSlot>> schedule) {
    final doctor = _profileViewModel.getRoleData<DoctorModel>();
    if (doctor == null) return;

    final updatedDoctor = DoctorModel(
      uid: doctor.uid,
      fullName: doctor.fullName,
      email: doctor.email,
      profileImage: doctor.profileImage,
      qualification: doctor.qualification,
      specialty: doctor.specialty,
      location: doctor.location,
      bio: doctor.bio,
      ratings: doctor.ratings,
      weeklySchedule: schedule, // New schedule update
      assignedPatients: doctor.assignedPatients,
    );

    FirebaseFirestore.instance
        .collection('users')
        .doc(doctor.uid)
        .update(updatedDoctor.toJson());
  }
}
