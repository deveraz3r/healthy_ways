import 'package:healty_ways/model/medication_model.dart';
import 'package:healty_ways/model/medicine_model.dart';

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
  bool get isTaken => medication.isTaken;
  // Add other combined properties as needed
}
