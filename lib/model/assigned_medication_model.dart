import 'package:healty_ways/model/medication_model.dart';
import 'package:healty_ways/model/medicine_model.dart';

class AssignedMedication {
  final MedicationModel medication;
  final MedicineModel medicine;

  AssignedMedication({
    required this.medication,
    required this.medicine,
  });

  // You can add convenience getters if needed
  String get medicineName => medicine.name;
  String? get medicineFormula => medicine.formula;
  DateTime get assignedTime => medication.assignedTime;
  bool get isTaken => medication.isTaken;
  // Add other combined properties as needed
}
