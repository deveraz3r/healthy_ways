import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:healty_ways/model/assigned_medication_model.dart';
import 'package:healty_ways/model/medication_model.dart';
import 'package:healty_ways/model/medicine_model.dart';
import 'package:healty_ways/model/medicine_schedule_model.dart';

class AssignedMedicationViewModel extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final RxList<MedicineModel> availableMedicines = <MedicineModel>[].obs;
  final RxList<AssignedMedicationModel> assignedMedications =
      <AssignedMedicationModel>[].obs;

  final RxList<MedicineScheduleModel> selectedSchedules =
      <MedicineScheduleModel>[].obs;

  final Rx<DateTime> selectedDate = DateTime.now().obs;

  Future<void> fetchAvailableMedicines() async {
    final querySnapshot = await _firestore.collection('medicines').get();
    final meds = querySnapshot.docs
        .map(
            (doc) => MedicineModel.fromJson(doc.data()..addAll({'id': doc.id})))
        .toList();
    availableMedicines.assignAll(meds);
  }

  void addSchedule(MedicineScheduleModel schedule) {
    final exists =
        selectedSchedules.any((s) => s.medicine.id == schedule.medicine.id);
    if (!exists) selectedSchedules.add(schedule);
  }

  void removeSchedule(MedicineScheduleModel schedule) {
    selectedSchedules.removeWhere((s) => s.medicine.id == schedule.medicine.id);
  }

  void updateSchedule(MedicineScheduleModel updatedSchedule) {
    final index = selectedSchedules
        .indexWhere((s) => s.medicine.id == updatedSchedule.medicine.id);
    if (index != -1) {
      selectedSchedules[index] = updatedSchedule;
    }
  }

  Future<void> assignSchedulesToFirestore({
    required String patientId,
    required String doctorId,
    required String patientName,
  }) async {
    for (var schedule in selectedSchedules) {
      DateTime date = schedule.startDate;
      while (!date.isAfter(schedule.endDate)) {
        for (final time in schedule.times) {
          final assignedDateTime = DateTime(
            date.year,
            date.month,
            date.day,
            time.hour,
            time.minute,
          );

          final medication = MedicationModel(
            id: _firestore.collection('medications').doc().id,
            medicineId: schedule.medicine.id,
            assignedTime: assignedDateTime,
            assignedTo: patientId,
            assignedBy: doctorId,
            quantity: 1,
            isTaken: false,
          );

          await _firestore
              .collection('medications')
              .doc(medication.id)
              .set(medication.toJson());
        }
        date = date.add(const Duration(days: 1));
      }
    }

    selectedSchedules.clear(); // Clear after successful assignment
    Get.snackbar("Success", "Medications assigned to $patientName");
  }

  // Mark as taken
  void markAsTaken(String medicationId) {
    final medication =
        assignedMedications.firstWhere((med) => med.id == medicationId);
    medication.isTaken = !medication.isTaken;
    assignedMedications.refresh(); // Refresh to update UI
  }

  // Fetch medications for a specific date
  List<AssignedMedicationModel> getMedicationsForDate(DateTime date) {
    return assignedMedications.where((med) {
      final assigned = med.assignedTime;
      return assigned.year == date.year &&
          assigned.month == date.month &&
          assigned.day == date.day;
    }).toList();
  }

  // Update the selected date
  void updateSelectedDate(DateTime date) {
    selectedDate.value = date;
  }
}
