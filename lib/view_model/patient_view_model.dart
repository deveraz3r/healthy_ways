import 'package:get/get.dart';
import 'package:healty_ways/model/patient_model.dart';

class PatientViewModel extends GetxController {
  final Rx<PatientModel?> _currentPatient = Rx<PatientModel?>(null);
  PatientModel? get currentPatient => _currentPatient.value;
  set currentPatient(PatientModel? value) => _currentPatient.value = value;

  final RxList<PatientModel> _patients = <PatientModel>[].obs;
  List<PatientModel> get patients => _patients;

  @override
  void onInit() {
    super.onInit();
    _initializeDummyData();
  }

  void _initializeDummyData() {
    _patients.addAll([
      PatientModel(
        uid: 'patient1',
        fullName: 'Patient One',
        email: 'patient1@example.com',
        profileImage: 'https://example.com/patient1.jpg',
      ),
      PatientModel(
        uid: 'patient2',
        fullName: 'Patient Two',
        email: 'patient2@example.com',
        profileImage: 'https://example.com/patient2.jpg',
      ),
    ]);
  }

  void setCurrentPatient(PatientModel patient) {
    currentPatient = patient;
  }

  void addPatient(PatientModel patient) {
    _patients.add(patient);
  }

  void removePatient(String uid) {
    _patients.removeWhere((patient) => patient.uid == uid);
  }
}
