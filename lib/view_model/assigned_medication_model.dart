import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:healty_ways/model/medication_model.dart';

class AssignedMedicineViewModel extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final RxList<MedicationModel> _medications = <MedicationModel>[].obs;

  List<MedicationModel> get medications => _medications;

  Future<void> fetchPatientMedications(String patientId) async {
    final query = await _firestore
        .collection('medications')
        .where('assignedTo', isEqualTo: patientId)
        .get();

    _medications.assignAll(
        query.docs.map((doc) => MedicationModel.fromJson(doc.data())).toList());
  }

  Future<void> markAsTaken(String medId) async {
    await _firestore
        .collection('medications')
        .doc(medId)
        .update({'isTaken': true});
    final index = _medications.indexWhere((m) => m.id == medId);
    if (index != -1) {
      _medications[index].isTaken = true;
      _medications.refresh();
    }
  }
}
