import 'package:get/get.dart';
import 'package:healty_ways/model/patient/medications.dart';

class MedicationsViewModel extends GetxController {
  // Make selectedDate reactive
  final Rx<DateTime> _selectedDate = DateTime.now().obs;
  DateTime get selectedDate => _selectedDate.value;

  // Method to update the selected date
  void updateSelectedDate(DateTime newDate) {
    _selectedDate.value = newDate;
  }

  final RxList<Medications> medications = [
    // Medications for March 15, 2025
    Medications(
      medicationName: 'Panadol Extra',
      dosage: 2,
      dosageType: 'Tabs',
      assignedBy: 'Dr Alex',
      time: DateTime(2025, 3, 15, 8, 30),
      isTaken: true,
    ),
    Medications(
      medicationName: 'Paracetamol',
      dosage: 1,
      dosageType: 'Tab',
      assignedBy: 'Dr Smith',
      time: DateTime(2025, 3, 15, 16, 30),
      isTaken: false,
    ),
    Medications(
      medicationName: 'Ibuprofen',
      dosage: 1,
      dosageType: 'Tab',
      assignedBy: 'Dr Jane',
      time: DateTime(2025, 3, 15, 10, 0),
      isTaken: true,
    ),
    Medications(
      medicationName: 'Aspirin',
      dosage: 1,
      dosageType: 'Tab',
      assignedBy: 'Dr John',
      time: DateTime(2025, 3, 15, 15, 0),
      isTaken: false,
    ),

    // Medications for March 14, 2025
    Medications(
      medicationName: 'Amoxicillin',
      dosage: 1,
      dosageType: 'Tab',
      assignedBy: 'Dr Emily',
      time: DateTime(2025, 3, 14, 9, 0),
      isTaken: true,
    ),
    Medications(
      medicationName: 'Cetirizine',
      dosage: 1,
      dosageType: 'Tab',
      assignedBy: 'Dr Michael',
      time: DateTime(2025, 3, 14, 14, 0),
      isTaken: false,
    ),
    Medications(
      medicationName: 'Metformin',
      dosage: 2,
      dosageType: 'Tabs',
      assignedBy: 'Dr Sarah',
      time: DateTime(2025, 3, 14, 8, 0),
      isTaken: true,
    ),

    // Medications for March 16, 2025
    Medications(
      medicationName: 'Lisinopril',
      dosage: 1,
      dosageType: 'Tab',
      assignedBy: 'Dr David',
      time: DateTime(2025, 3, 16, 10, 30),
      isTaken: false,
    ),
    Medications(
      medicationName: 'Atorvastatin',
      dosage: 1,
      dosageType: 'Tab',
      assignedBy: 'Dr Laura',
      time: DateTime(2025, 3, 16, 16, 0),
      isTaken: true,
    ),
    Medications(
      medicationName: 'Omeprazole',
      dosage: 1,
      dosageType: 'Tab',
      assignedBy: 'Dr James',
      time: DateTime(2025, 3, 16, 8, 0),
      isTaken: true,
    ),
    // Medications for March 16, 2025
    Medications(
      medicationName: 'Lisinopril',
      dosage: 1,
      dosageType: 'Tab',
      assignedBy: 'Dr David',
      time: DateTime(2025, 3, 16, 10, 30),
      isTaken: false,
    ),
    Medications(
      medicationName: 'Atorvastatin',
      dosage: 1,
      dosageType: 'Tab',
      assignedBy: 'Dr Laura',
      time: DateTime(2025, 3, 16, 16, 0),
      isTaken: true,
    ),
    Medications(
      medicationName: 'Omeprazole',
      dosage: 1,
      dosageType: 'Tab',
      assignedBy: 'Dr James',
      time: DateTime(2025, 3, 16, 8, 0),
      isTaken: true,
    ),
    // Medications for March 16, 2025
    Medications(
      medicationName: 'Lisinopril',
      dosage: 1,
      dosageType: 'Tab',
      assignedBy: 'Dr David',
      time: DateTime(2025, 3, 16, 10, 30),
      isTaken: false,
    ),
    Medications(
      medicationName: 'Atorvastatin',
      dosage: 1,
      dosageType: 'Tab',
      assignedBy: 'Dr Laura',
      time: DateTime(2025, 3, 16, 16, 0),
      isTaken: true,
    ),
    Medications(
      medicationName: 'Omeprazole',
      dosage: 1,
      dosageType: 'Tab',
      assignedBy: 'Dr James',
      time: DateTime(2025, 3, 16, 8, 0),
      isTaken: true,
    ),
  ].obs;

  // Method to toggle isTaken status
  void toggleMedicationStatus(Medications medication) {
    medication.isTaken = !medication.isTaken; // Toggle the status
    medications.refresh(); // Notify listeners
  }

  // // Convert Medications list to MedicationCard widgets
  // List<MedicationCard> get medicationCards {
  //   return medications
  //       .map((medication) => MedicationCard(medication: medication))
  //       .toList();
  // }
}

extension DateTimeExtensions on DateTime {
  bool isToday() {
    final now = DateTime.now();
    return year == now.year && month == now.month && day == now.day;
  }
}
