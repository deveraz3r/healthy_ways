import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:healty_ways/model/medication_model.dart';
import 'package:healty_ways/model/medicine_model.dart';
import 'package:healty_ways/model/medicine_schedule_model.dart';
import 'package:healty_ways/model/user_model.dart';
import 'package:healty_ways/view_model/inventory_view_model.dart';
import 'package:healty_ways/view_model/medicine_view_model.dart';
import 'package:healty_ways/view_model/profile_view_model.dart';
import 'package:intl/intl.dart';

class AssignedMedicationViewModel extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final MedicineViewModel medicineVM = Get.find();
  final ProfileViewModel _profileVM = Get.find();

  final RxList<MedicineModel> availableMedicines = <MedicineModel>[].obs;
  final RxList<MedicationModel> assignedMedications = <MedicationModel>[].obs;

  final RxList<MedicineScheduleModel> selectedSchedules =
      <MedicineScheduleModel>[].obs;

  final Rx<DateTime> selectedDate = DateTime.now().obs;

  @override
  void onInit() {
    super.onInit();

    fetchAvailableMedicines();

    if (_profileVM.profile!.role == UserRole.patient) {
      fetchAssignedMedication(_profileVM.profile!.uid);
    }
  }

  Future<void> fetchAvailableMedicines() async {
    // final querySnapshot = await _firestore.collection('medicines').get();
    // final meds = querySnapshot.docs
    //     .map(
    //         (doc) => MedicineModel.fromJson(doc.data()..addAll({'id': doc.id})))
    //     .toList();
    // ;
    await Get.find<MedicineViewModel>().fetchAllMedicines();
    availableMedicines.assignAll(medicineVM.allMedicines);
    print(
        "Available medicines: ${availableMedicines.map((m) => '${m.id} - ${m.name}').toList()}");
  }

  Future<void> fetchAssignedMedication(String patientId) async {
    try {
      final querySnapshot = await _firestore
          .collection("medications")
          .where("assignedTo", isEqualTo: patientId)
          .get();

      final medications = querySnapshot.docs
          .map((doc) => MedicationModel.fromJson(doc.data()..['id'] = doc.id))
          .toList();

      assignedMedications.assignAll(medications);
    } catch (e) {
      print("Error fetching medications: $e");
      assignedMedications.clear();
      Get.snackbar("Error", "Failed to fetch medications");
    }
  }

  void addSchedule(MedicineScheduleModel schedule) {
    final exists =
        selectedSchedules.any((s) => s.medicine.id == schedule.medicine.id);
    print(exists ? "Medicine already exsist!" : "medicine does not exsist");
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

  // Mark as taken and update in Firestore
  void markAsTaken(String medicationId) async {
    final medication =
        assignedMedications.firstWhere((med) => med.id == medicationId);

    final inventoryVM = Get.find<InventoryViewModel>();
    final inventoryItem = inventoryVM.inventory
        .firstWhereOrNull((item) => item.medicineId == medication.medicineId);

    if (medication.isTaken) {
      // ✅ Revert taken status and add back to inventory
      if (inventoryItem != null) {
        final restoredQuantity = inventoryItem.stock + medication.quantity;
        await inventoryVM.updateStock(medication.medicineId, restoredQuantity);
      }

      medication.isTaken = false;
      assignedMedications.refresh();

      try {
        final snapshot = await _firestore
            .collection('medications')
            .where('id', isEqualTo: medication.id)
            .get();

        for (var doc in snapshot.docs) {
          await _firestore
              .collection('medications')
              .doc(doc.id)
              .update({'isTaken': false});
        }
      } catch (e) {
        print('Error updating isTaken in Firestore: $e');
      }

      return;
    }

    // ✅ Trying to mark as taken - check stock first
    if (inventoryItem == null || inventoryItem.stock < medication.quantity) {
      Get.snackbar(
        "Not enough stock",
        "You don’t have enough ${getMedicine(medication.medicineId).name} in inventory.",
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    try {
      // Deduct stock
      final newQuantity = inventoryItem.stock - medication.quantity;
      await inventoryVM.updateStock(medication.medicineId, newQuantity);

      // Mark as taken
      medication.isTaken = true;
      assignedMedications.refresh();

      // Update in Firestore
      final snapshot = await _firestore
          .collection('medications')
          .where('id', isEqualTo: medication.id)
          .get();

      for (var doc in snapshot.docs) {
        await _firestore
            .collection('medications')
            .doc(doc.id)
            .update({'isTaken': true});
      }
    } catch (e) {
      print('Error marking medication as taken: $e');
      Get.snackbar("Error", "Failed to mark medication as taken");
    }
  }

  // Fetch medications for a specific date
  List<MedicationModel> getMedicationsForDate(DateTime date) {
    return assignedMedications.where((med) {
      final assigned = med.assignedTime;
      return assigned.year == date.year &&
          assigned.month == date.month &&
          assigned.day == date.day;
    }).toList();
  }

  // Update the selected date
  Future<void> updateSelectedDate(DateTime date) async {
    selectedDate.value = date;
  }

  MedicineModel getMedicine(String id) {
    return availableMedicines.firstWhere(
      (med) => med.id == id,
      orElse: () {
        throw Exception("Medicine with id $id not found");
      },
    );
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
}
