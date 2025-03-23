import 'package:get/get.dart';
import 'package:healty_ways/model/doctor/assigned_patient_model.dart';

class PatientViewModel extends GetxController {
  var patients = <AssignedPatientModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchPatients();
  }

  void fetchPatients() {
    patients.assignAll([
      AssignedPatientModel(
        name: "John",
        type: "Regular patient",
        imageUrl: "assets/profile.jpg",
      ),
      AssignedPatientModel(
        name: "Mark",
        type: "New patient",
        imageUrl: "assets/profile.jpg",
      ),
      AssignedPatientModel(
        name: "Alex",
        type: "Regular patient",
        imageUrl: "assets/profile.jpg",
      ),
      AssignedPatientModel(
        name: "Peter",
        type: "Regular patient",
        imageUrl: "assets/profile.jpg",
      ),
      AssignedPatientModel(
        name: "Tom",
        type: "New patient",
        imageUrl: "assets/profile.jpg",
      ),
      AssignedPatientModel(
        name: "Jerry",
        type: "New patient",
        imageUrl: "assets/profile.jpg",
      ),
    ]);
  }
}
