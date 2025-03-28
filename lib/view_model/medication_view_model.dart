import 'package:get/get.dart';
import 'package:healty_ways/model/medication_model.dart';

class MedicationViewModel extends GetxController {
  final RxList<MedicationModel> _medications = <MedicationModel>[].obs;
  List<MedicationModel> get medications => _medications;

  @override
  void onInit() {
    super.onInit();
    _initializeDummyData();
  }

  void _initializeDummyData() {
    _medications.addAll([
      MedicationModel(
        id: 'medication1',
        medicineId: 'med1',
        quantity: 30,
        assignedTime: DateTime.now(),
        assignedTo: 'patient1',
        assignedBy: 'doctor1',
        isTaken: false,
      ),
      MedicationModel(
        id: 'medication2',
        medicineId: 'med2',
        quantity: 20,
        assignedTime: DateTime.now().add(const Duration(days: 1)),
        assignedTo: 'patient2',
        assignedBy: 'doctor1',
        isTaken: false,
      ),
    ]);
  }

  void addMedication(MedicationModel medication) {
    _medications.add(medication);
  }

  void removeMedication(String id) {
    _medications.removeWhere((medication) => medication.id == id);
  }

  void markAsTaken(String id) {
    final medication = _medications.firstWhere((m) => m.id == id);
    medication.isTaken = true;
    _medications.refresh();
  }

  List<MedicationModel> getMedicationsForPatient(String patientId) {
    return _medications.where((m) => m.assignedTo == patientId).toList();
  }
}
