import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:healty_ways/model/assigned_medication_model.dart';
import 'package:healty_ways/model/medication_model.dart';
import 'package:healty_ways/model/medicine_model.dart';

class AssignedMedicationViewModel extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final RxList<AssignedMedicationModel> assignedMedications =
      <AssignedMedicationModel>[].obs;
  final Rx<DateTime> selectedDate = DateTime.now().obs;

  Future<void> fetchPatientMedications(String patientId) async {
    // Fetch medications
    final medicationsQuery = await _firestore
        .collection('medications')
        .where('assignedTo', isEqualTo: patientId)
        .get();

    // Fetch all related medicines in one query
    final medicationDocs = medicationsQuery.docs;
    final medicineIds =
        medicationDocs.map((doc) => doc['medicineId'] as String).toList();

    final medicinesQuery = await _firestore
        .collection('medicines')
        .where(FieldPath.documentId, whereIn: medicineIds)
        .get();

    // Create a map of medicines for quick lookup
    final medicinesMap = {
      for (var doc in medicinesQuery.docs)
        doc.id: MedicineModel.fromJson(doc.data())
    };

    // Combine medications with their medicines
    assignedMedications.assignAll(medicationDocs.map((doc) {
      final medication = MedicationModel.fromJson(doc.data());
      final medicine = medicinesMap[medication.medicineId] ??
          MedicineModel(
            id: medication.medicineId,
            name: 'Unknown Medicine',
            formula: "100 mg",
            stockType: '',
            description: 'Medicine data not found',
          );

      return AssignedMedicationModel(
        medication: medication,
        medicine: medicine,
      );
    }).toList());
  }

  Future<void> markAsTaken(String medId) async {
    await _firestore
        .collection('medications')
        .doc(medId)
        .update({'isTaken': true});

    final index =
        assignedMedications.indexWhere((am) => am.medication.id == medId);
    if (index != -1) {
      assignedMedications[index].medication.isTaken = true;
      assignedMedications.refresh();
    }
  }

  void updateSelectedDate(DateTime date) {
    selectedDate.value = date;
  }

  List<AssignedMedicationModel> getMedicationsForDate(DateTime date) {
    return assignedMedications
        .where((am) =>
            am.medication.assignedTime.year == date.year &&
            am.medication.assignedTime.month == date.month &&
            am.medication.assignedTime.day == date.day)
        .toList();
  }
}
