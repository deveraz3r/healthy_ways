import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:healty_ways/model/doctor_model.dart';
import 'package:healty_ways/model/patient_model.dart';
import 'package:healty_ways/view_model/profile_view_model.dart';

class PatientsViewModel extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final RxList<PatientModel> patients = <PatientModel>[].obs;
  final RxList<PatientModel> filteredPatients = <PatientModel>[].obs;

  final ProfileViewModel _profileVM = Get.find<ProfileViewModel>();

  @override
  void onInit() {
    super.onInit();
    fetchDoctorPatients(_profileVM.profile?.uid ??
        ""); // Fetch assigned patients for the doctor
    fetchAllPatients(); // Fetch all patients
  }

  // Fetch patients assigned to the doctor
  Future<void> fetchDoctorPatients(String doctorId) async {
    final DoctorModel doctorProfile = _profileVM.profile as DoctorModel;
    final List<String> assignedPatients = doctorProfile.assignedPatients;

    if (assignedPatients.isEmpty) {
      patients.clear();
      return;
    }

    try {
      List<QuerySnapshot> querySnapshots = await Future.wait(
        assignedPatients
            .chunked(10) // Splits the list into chunks of 10
            .map((chunk) => _firestore
                .collection('users')
                .where('uid', whereIn: chunk)
                .get()),
      );

      // Merge results from all chunks
      final allPatients =
          querySnapshots.expand((snapshot) => snapshot.docs).toList();

      // Update the observable list
      patients.assignAll(allPatients
          .map((doc) =>
              PatientModel.fromJson(doc.data() as Map<String, dynamic>))
          .toList());
    } catch (e) {
      print('Error fetching assigned patients: $e');
    }
  }

  // Fetch all patients from Firestore
  Future<void> fetchAllPatients() async {
    try {
      final querySnapshot = await _firestore
          .collection('users')
          .where('role', isEqualTo: 'patient')
          .get();

      final allPatients = querySnapshot.docs
          .map((doc) =>
              PatientModel.fromJson(doc.data() as Map<String, dynamic>))
          .toList();

      // Assign the fetched list of all patients to the observable list
      patients.assignAll(allPatients);

      // Initially, set the filtered list to all patients
      filteredPatients.assignAll(allPatients);
    } catch (e) {
      print('Error fetching all patients: $e');
    }
  }

  // Fetch patient details by patientId
  Future<PatientModel?> getPatientDetails(String patientId) async {
    try {
      final doc = await _firestore.collection('users').doc(patientId).get();
      return PatientModel.fromJson(doc.data()!);
    } catch (e) {
      return null;
    }
  }

  // Filter patients based on the search term
  void filterPatients(String searchTerm) {
    if (searchTerm.isEmpty) {
      filteredPatients.assignAll(patients);
    } else {
      filteredPatients.assignAll(patients.where((patient) {
        return patient.fullName
            .toLowerCase()
            .contains(searchTerm.toLowerCase());
      }).toList());
    }
  }
}

// Helper function to split list into chunks of 10
extension ListExtensions<T> on List<T> {
  List<List<T>> chunked(int size) {
    List<List<T>> chunks = [];
    for (var i = 0; i < length; i += size) {
      chunks.add(sublist(i, i + size > length ? length : i + size));
    }
    return chunks;
  }
}
