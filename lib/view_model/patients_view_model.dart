import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:healty_ways/model/doctor_model.dart';
import 'package:healty_ways/model/patient_model.dart';
import 'package:healty_ways/utils/app_urls.dart';
import 'package:healty_ways/view_model/profile_view_model.dart';

class PatientsViewModel extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final RxList<PatientModel> patients = <PatientModel>[].obs;
  final RxList<PatientModel> filteredPatients = <PatientModel>[].obs;

  final ProfileViewModel _profileVM = Get.find<ProfileViewModel>();

  final RxBool _isLoading = false.obs;
  bool get isLoading => _isLoading.value;

  @override
  void onInit() {
    super.onInit();
    fetchAllPatients();
  }

  Future<void> fetchAllPatients() async {
    try {
      _isLoading.value = true;

      final querySnapshot = await _firestore
          .collection('users')
          .where('role', isEqualTo: 'patient')
          .get();

      final allPatients = querySnapshot.docs
          .map((doc) => PatientModel.fromJson(doc.data()))
          .toList();

      patients.assignAll(allPatients);
      filteredPatients.assignAll(allPatients);
    } catch (e) {
      _handleError("Failed to fetch all patients", e);
    } finally {
      _isLoading.value = false;
    }
  }

  //only for doctors
  void fetchAssignedPatients() {
    try {
      final doctor = _profileVM.profile as DoctorModel;
      final List<String> assignedPatientIds = doctor.assignedPatients;

      if (assignedPatientIds.isEmpty) {
        filteredPatients.clear();
        return;
      }

      // Filter patients based on assigned IDs
      filteredPatients.value = patients
          .where((patient) => assignedPatientIds.contains(patient.uid))
          .toList();
    } catch (e) {
      _handleError("Failed to filter assigned patients", e);
    }
  }

  PatientModel? getPatientInfo(String patientId) {
    return patients.firstWhereOrNull((patient) => patient.uid == patientId);
  }

  void updateSearchQuery(String query) {
    if (query.isEmpty) {
      filteredPatients.value = patients;
    } else {
      filteredPatients.value = patients.where((patient) {
        return patient.fullName.toLowerCase().contains(query.toLowerCase());
      }).toList();
    }
  }

  void _handleError(String message, dynamic error) {
    Get.snackbar("Error", "$message: ${error.toString()}");
    debugPrint("$message: $error");
  }
}
