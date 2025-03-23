import 'package:get/get.dart';

class Medication {
  final String name;
  final String dosage;
  final String time;
  final bool isTaken;

  Medication({
    required this.name,
    required this.dosage,
    required this.time,
    required this.isTaken,
  });
}

class DoctorAssignedPatientDetailsViewModel extends GetxController {
  var patientName = "John Doe".obs;
  var patientType = "Regular patient".obs;
  RxString? profileImage = null;

  var medications = <String, List<Medication>>{
    "March 10th, 2025": [
      Medication(
          name: "Panadol Extra",
          dosage: "2 Tabs",
          time: "1:30 pm",
          isTaken: false),
      Medication(
          name: "Panadol Extra",
          dosage: "2 Tabs",
          time: "9:30 pm",
          isTaken: false),
    ],
    "March 9th, 2025": [
      Medication(
          name: "Paracetamol",
          dosage: "2 Tabs",
          time: "8:30 pm",
          isTaken: true),
      Medication(
          name: "Arinac", dosage: "2 Tabs", time: "1:30 pm", isTaken: true),
      Medication(
          name: "Flygel", dosage: "2 Tabs", time: "9:00 pm", isTaken: true),
    ],
  }.obs;
}
