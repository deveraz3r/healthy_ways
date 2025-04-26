import 'package:healty_ways/utils/app_urls.dart';

class AssignedMedicationModel {
  final MedicationModel medication;
  final MedicineModel medicine;

  AssignedMedicationModel({
    required this.medication,
    required this.medicine,
  });

  // You can add convenience getters if needed
  String get medicineName => medicine.name;
  String get medicineFormula => medicine.formula;
  String get medicineStockType => medicine.stockType;
  DateTime get assignedTime => medication.assignedTime;

  // This is how you access `isTaken` through the `medication` model
  bool get isTaken => medication.isTaken;

  // If you need to set `isTaken`, you can delegate it to the `medication` model
  set isTaken(bool value) {
    medication.isTaken = value;
  }

  // Access the `id` of `MedicationModel` through the `medication` field
  String get id => medication.id;

  // Add other combined properties as needed
}
