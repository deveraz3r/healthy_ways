import 'package:healty_ways/utils/app_urls.dart';

class AssignedMedicationViewModel extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final ProfileViewModel _profileVM = Get.find<ProfileViewModel>();
  final InventoryViewModel _inventoryVM = Get.find<InventoryViewModel>();

  final RxList<MedicationModel> assignedMedications = <MedicationModel>[].obs;
  final RxList<MedicationModel> filterAssignedMedications =
      <MedicationModel>[].obs;
  get availableMedicines => Get.find<MedicineViewModel>().allMedicines;

  final RxList<MedicineScheduleModel> selectedSchedules =
      <MedicineScheduleModel>[].obs;
  final Rx<DateTime> selectedDate = DateTime.now().obs;

  get getMedicine => Get.find<MedicineViewModel>().getMedicine;

  @override
  void onInit() async {
    // remove async from onInit if it isn't calling automatically
    super.onInit();

    if (_profileVM.profile!.role == UserRole.patient) {
      // Only auto-fetch for patients
      await fetchAssignedMedication(_profileVM.profile!.uid);
    }
  }

  // Fetch medications assigned to the patient by id (so this function can be used by both patient and healthcare providers)
  Future<void> fetchAssignedMedication(String patientId) async {
    try {
      final querySnapshot = await _firestore
          .collection("medications")
          .where("assignedTo", isEqualTo: patientId)
          .get();

      final medications = querySnapshot.docs
          .map((doc) => MedicationModel.fromJson(doc.data()))
          .toList();

      assignedMedications.assignAll(medications);
      filterAssignedMedications.assignAll(medications); // Update filtered list
    } catch (e) {
      _handleError("Failed to fetch medications", e);
    }
  }

  Future<void> markAsTaken(String medicationId) async {
    final medication =
        assignedMedications.firstWhere((med) => med.id == medicationId);

    if (medication.isTaken) {
      // Revert taken status
      await _inventoryVM.revertStock(
        medication.medicineId,
        medication.quantity,
      );
      medication.isTaken = false;
    } else {
      // Check stock and mark as taken
      final success = await _inventoryVM.deductStock(
        medication.medicineId,
        medication.quantity,
      );
      if (!success) {
        Get.snackbar("Error", "Not enough stock");
        return;
      }
      medication.isTaken = true;
    }

    assignedMedications.refresh();
    filterAssignedMedications.refresh(); // Refresh filtered list
    await _updateMedicationStatusInFirestore(medication);
  }

  Future<void> _updateMedicationStatusInFirestore(
      MedicationModel medication) async {
    try {
      final snapshot = await _firestore
          .collection('medications')
          .where('id', isEqualTo: medication.id)
          .get();

      for (var doc in snapshot.docs) {
        await _firestore
            .collection('medications')
            .doc(doc.id)
            .update({'isTaken': medication.isTaken});
      }
    } catch (e) {
      _handleError('Error updating isTaken in Firestore', e);
    }
  }

  void filterMedicationsForDate() {
    filterAssignedMedications.assignAll(assignedMedications.where((med) =>
        med.assignedTime.year == selectedDate.value.year &&
        med.assignedTime.month == selectedDate.value.month &&
        med.assignedTime.day == selectedDate.value.day));
  }

  Future<void> updateSelectedDate(DateTime date) async {
    selectedDate.value = date;
    filterMedicationsForDate();
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

  String generateMedicationReport() {
    if (selectedSchedules.isEmpty) {
      return 'No medications assigned.';
    }

    final buffer = StringBuffer();
    final dateFormatter = DateFormat('yyyy-MM-dd');

    buffer.writeln('🩺 Medication Assignment Report');
    buffer.writeln('-----------------------------');

    for (var schedule in selectedSchedules) {
      final name = schedule.medicine.name;
      final formula = schedule.medicine.formula;
      final startDate = dateFormatter.format(schedule.startDate);
      final endDate = dateFormatter.format(schedule.endDate);
      final times =
          schedule.times.map((t) => t.format(Get.context!)).join(', ');

      buffer.writeln('• Medicine: $name');
      if (formula.isNotEmpty) buffer.writeln('  Formula: $formula');
      buffer.writeln('  Duration: $startDate → $endDate');
      buffer.writeln('  Times: $times');
      buffer.writeln('');
    }

    return buffer.toString();
  }

  _handleError(String message, dynamic error) {
    Get.snackbar("Error", "$message: ${error.toString()}");
    debugPrint("$message: $error");
  }
}
