import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:healty_ways/model/patient_model.dart';

class PatientsViewModel extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final RxList<PatientModel> _patients = <PatientModel>[].obs;

  List<PatientModel> get patients => _patients;

  Future<void> fetchDoctorPatients(String doctorId) async {
    final query = await _firestore
        .collection('patients')
        .where('assignedDoctor', isEqualTo: doctorId)
        .get();

    _patients.assignAll(
        query.docs.map((doc) => PatientModel.fromJson(doc.data())).toList());
  }

  Future<PatientModel?> getPatientDetails(String patientId) async {
    try {
      final doc = await _firestore.collection('patients').doc(patientId).get();
      return PatientModel.fromJson(doc.data()!);
    } catch (e) {
      return null;
    }
  }
}
